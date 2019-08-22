# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

c =  Company.find(3)
d1 = c.departments.create(name: "CSM Department", description: "This is the CSM Department of the Company.")
d2 = c.departments.create(name: "Development Department", description: "This is the Development Department of the Company.")
d3 = c.departments.create(name: "Product Department", description: "This is the Product Department of the Company.")