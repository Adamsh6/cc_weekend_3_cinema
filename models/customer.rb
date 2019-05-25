require('pg')
require("pry")
require_relative('../db/sql_runner')

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds']
  end

  def save
    sql = 'INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id'
    values = [@name, @funds]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id']
  end

  def update
    sql = 'UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3'
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def films
    sql = "SELECT * FROM films INNER JOIN tickets
            ON films.id = tickets.film_id
            WHERE customer_id = $1
            ORDER BY films.title"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return Film.map_items(result)
  end

  def ticket_count
    sql = "SELECT COUNT(*) FROM tickets WHERE customer_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result[0]['count']
  end

  def buy_ticket(screening_time)
    sql = 'SELECT * FROM screenings
            WHERE start_time = $1'
    values = [screening_time]
    screening = SqlRunner.run(sql, values)[0]
    screening = Screening.new(screening)
    sql = 'SELECT price FROM films
            WHERE id = $1'
    values = [screening.film_id.to_i]
    film = SqlRunner.run(sql, values)[0]
    return "Insufficient funds" if film['price'].to_i > @funds
    return "No seats remaining" if screening.seats_remaining == 0
    screening.seats_remaining  -= 1
    ticket = Ticket.new({'customer_id' => @id, 'screening_id' => screening.id.to_i, 'film_id' => screening.film_id.to_i})
    ticket.save
    screening.update
    @funds -= film['price'].to_i
    update
  end


  def self.find(id)
    sql = 'SELECT * FROM customers WHERE id = $1'
    values = [id]
    result = SqlRunner.run(sql, values)
    return Customer.new(result[0])
  end

  def self.all
    sql = 'SELECT name, funds FROM customers'
    result = SqlRunner.run(sql)
    return self.map_items(result)
  end

  def self.delete_all
    sql = "DELETE FROM customers"
    result = SqlRunner.run(sql)
  end

  def self.map_items(data)
    result = data.map { |data| Customer.new( data ) }
    return result
  end


end
