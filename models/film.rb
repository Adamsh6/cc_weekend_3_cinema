require('pg')
require("pry")
require_relative('../db/sql_runner')

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price']
  end

  def save
    sql = 'INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id'
    values = [@title, @price]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id']
  end

  def update
    sql = 'UPDATE films SET (title, price) = ($1, $2) WHERE id = $3'
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def customers
    sql = "SELECT * FROM customers INNER JOIN tickets
            ON customers.id = tickets.customer_id
            WHERE film_id = $1
            ORDER BY name"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return Customer.map_items(result)
  end

  #EXTENSION
  def customer_count
    #Used this methodology until I realised it would be simpler to just use a different method
    # sql = "SELECT COUNT(*) FROM customers INNER JOIN tickets
    #         ON customers.id = tickets.customer_id
    #         WHERE film_id = $1"
    # values = [@id]
    # count = SqlRunner.run(sql, values)
    # return count[0]['count']
    return customers.size
  end

  #ADVANCED EXTENSION
  def most_popular_screening
    sql = "SELECT * FROM screenings WHERE film_id = $1"
    values = [@id]
    screenings = SqlRunner.run(sql, values)
    screenings = screenings.map{|screening| Screening.new(screening)}
    most_popular = screenings.max {|a, b| a.customer_count <=> b.customer_count}
    return most_popular
  end

  def self.find(id)
    sql = 'SELECT * FROM films WHERE id = $1'
    values = [id]
    result = SqlRunner.run(sql, values)
    return Film.new(result[0])
  end

  def self.all
    sql = 'SELECT title, price FROM films'
    result = SqlRunner.run(sql)
    return self.map_items(result)
  end

  def self.delete_all
    sql = "DELETE FROM films"
    result = SqlRunner.run(sql)
  end

  def self.map_items(data)
    result = data.map { |data| Film.new( data ) }
    return result
  end


end
