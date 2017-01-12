# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Plan.create(name: 'basic', price: 0) unless Plan.find_by(name: 'basic')
Plan.create(name: 'group', price: 10) unless Plan.find_by(name: 'group')
Plan.create(name: 'pro', price: 100) unless Plan.find_by(name: 'pro')

Organization.create(name: 'None', owner_id: 0) unless Organization.find_by(name: 'None')