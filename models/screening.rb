require('pg')
require("pry")
require_relative('../db/sql_runner')
#ADVANCED EXTENSION
class Screening

  attr_accessor :start_time, :seats_remaining, :film_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @start_time = options['start_time']
    @film_id = options['film_id'].to_i
    @seats_remaining = options['seats_remaining'].to_i
  end

  def save
    sql = 'INSERT INTO screenings (start_time, film_id, seats_remaining) VALUES ($1, $2, $3) RETURNING id'
    values = [@start_time, @film_id, @seats_remaining]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id']
  end

  def update
    sql = 'UPDATE screenings SET (start_time, film_id, seats_remaining) = ($1, $2, $3) WHERE id = $4'
    values = [@start_time, @film_id, @seats_remaining, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM screenings WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def customer_count
    sql = 'SELECT COUNT(*) FROM customers INNER JOIN tickets
            ON customer_id = customers.id WHERE tickets.screening_id = $1'
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result[0]['count']
  end

  def self.find(id)
    sql = 'SELECT * FROM screenings WHERE id = $1'
    values = [id]
    result = SqlRunner.run(sql, values)
    return Screening.new(result[0])
  end

  def self.all
    sql = 'SELECT * FROM screenings'
    result = SqlRunner.run(sql)
    return self.map_items(result)
  end

  #PERSONAL ADVANCED EXTENSION
  def self.all_with_title
    sql = 'SELECT title, screenings.start_time FROM films INNER JOIN screenings
          ON films.id = screenings.film_id
          ORDER BY start_time'
    result = SqlRunner.run(sql)
    film_screenings = result.map {|screening| "#{screening['start_time']}: #{screening['title']}"}
  end

  def self.delete_all
    sql = "DELETE FROM screenings"
    result = SqlRunner.run(sql)
  end

  def self.map_items(data)
    result = data.map { |data| Screening.new( data ) }
    return result
  end


end
