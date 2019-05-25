require('pg')
require("pry")
require_relative('../db/sql_runner')


#TODO ensure that a ticket cannot be sold for a screening/movie pair that doesn't exist
class Ticket

  attr_accessor :customer_id, :film_id, :screening_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id']
    @film_id = options['film_id']
    @screening_id = options['screening_id']
  end

  def save
    sql = 'INSERT INTO tickets (customer_id, film_id, screening_id) VALUES ($1, $2, $3) RETURNING id'
    values = [@customer_id, @film_id, @screening_id]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id']
  end

  def update
    sql = 'UPDATE tickets SET (customer_id, film_id, screening_id) = ($1, $2, $3) WHERE id = $4'
    values = [@customer_id, @film_id, @screening_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.find(id)
    sql = 'SELECT * FROM tickets WHERE id = $1'
    values = [id]
    result = SqlRunner.run(sql, values)
    return Ticket.new(result[0])
  end

  def self.all
    sql = 'SELECT customer_id, film_id, screening_id FROM tickets'
    result = SqlRunner.run(sql)
    return self.map_items(result)
  end

  def self.delete_all
    sql = "DELETE FROM tickets"
    result = SqlRunner.run(sql)
  end

  def self.map_items(data)
    result = data.map { |data| Ticket.new( data ) }
    return result
  end


end
