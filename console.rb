require('pry')
require_relative('models/customer')
require_relative('models/film')
require_relative('models/screening')
require_relative('models/ticket')

Film.delete_all
Customer.delete_all
Screening.delete_all
Ticket.delete_all

film1 = Film.new({'title' => 'X-men: Dark Phoenix', 'price' => 12})
film2 = Film.new({'title' => 'John Wick 3', 'price' => 10})
film3 = Film.new({'title' => 'Aladdin', 'price' => 8})
film1.save
film2.save
film3.save

customer1 = Customer.new({'name' => 'Dirk', 'funds' => 84})
customer2 = Customer.new({'name' => 'James', 'funds' => 66})
customer3 = Customer.new({'name' => 'Thomas', 'funds' => 14})
customer4 = Customer.new({'name' => 'Lydia', 'funds' => 54})
customer5 = Customer.new({'name' => 'Sandy', 'funds' => 26})
customer1.save
customer2.save
customer3.save
customer4.save
customer5.save

screening1 = Screening.new({'start_time' => '12:30', 'film_id' => film1.id, 'seats_remaining' => 10})
screening2 = Screening.new({'start_time' => '14:15', 'film_id' => film2.id, 'seats_remaining' => 10})
screening3 = Screening.new({'start_time' => '16:10', 'film_id' => film3.id, 'seats_remaining' => 10})
screening4 = Screening.new({'start_time' => '18:42', 'film_id' => film1.id, 'seats_remaining' => 10})
screening5 = Screening.new({'start_time' => '20:16', 'film_id' => film2.id, 'seats_remaining' => 10})
screening6 = Screening.new({'start_time' => '21:50', 'film_id' => film3.id, 'seats_remaining' => 10})
screening7 = Screening.new({'start_time' => '17:20', 'film_id' => film1.id, 'seats_remaining' => 2})
screening1.save
screening2.save
screening3.save
screening4.save
screening5.save
screening6.save
screening7.save

customer1.buy_ticket('12:30')
customer1.buy_ticket('21:50')
customer1.buy_ticket('12:30')
customer2.buy_ticket('20:16')
customer3.buy_ticket('14:15')
customer3.buy_ticket('17:20')
customer4.buy_ticket('21:50')
customer4.buy_ticket('16:10')
customer5.buy_ticket('14:15')
customer5.buy_ticket('18:42')



binding.pry
nil
