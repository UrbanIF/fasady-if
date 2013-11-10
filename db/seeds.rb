# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
if User.count == 0
puts 'DEFAULT USERS'
user = User.create! :name => 'admin', :email => 'admin@admin.com', :password => '11111111', :password_confirmation => '11111111'
puts 'user: ' << user.name
end




puts 'Create category'
category1 = Category.create(name: "Заклади культури та освіти", color: 'green')
category2 = Category.create(name: "Заклади громадського харчування", color: 'red')
category3 = Category.create(name: "Інше", color: 'yellow')
category4 = Category.create(name: "Державні установи", color: 'blue')
category5 = Category.create(name: "Заклади обслуговування", color: 'purple')

puts 'Create map object'

MapObject.create(name: "Приватна хата", category: category1, user: user, address: Address.new(prefix: 'вул.', street: "Паркова", building_number: "20"), location: [48.9260402, 24.74123899999995]  )
MapObject.create(name: "MTB bike", category: category2, user: user, address: Address.new(prefix: 'вулиця', street: "Андрія Мельника", building_number: "11"), location: [48.918657,24.71507])
MapObject.create(name: "Загс", category: category3, user: user, address: Address.new(prefix: 'пл.', street: "Ринок", building_number: "1"), location: [48.923306,24.710033])
MapObject.create(name: "Войцех", category: category4, user: user, address: Address.new(prefix: 'вул.', street: "Чорновола", building_number: "25"), location: [48.917441,24.70646])
MapObject.create(name: "Партія удар", category: category5, user: user, address: Address.new(prefix: 'вул.', street: "Січових стрільців", building_number: "34"), location: [48.918695, 24.709444])







