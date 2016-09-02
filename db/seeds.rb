# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user1 = User.create(email: 'rudi@afeefa.de', forename: 'Rudi', surname: 'Dutschke', password: 'password1')
user2 = User.create(email: 'steve@afeefa.de', forename: 'Steve', surname: 'Reinke', password: 'password1')
user3 = User.create(email: 'joschka@afeefa.de', forename: 'Joschka', surname: 'Heinrich', password: 'password2')
user4 = User.create(email: 'peter@afeefa.de', forename: 'Peter', surname: 'Hirsch', password: 'password3')
user5 = User.create(email: 'benny@afeefa.de', forename: 'Benny', surname: 'Thomä', password: 'password4')
user6 = User.create(email: 'felix@afeefa.de', forename: 'Felix', surname: 'Schönfeld', password: 'password5')
user7 = User.create(email: 'anna@afeefa.de', forename: 'Anna', surname: 'Neumann', password: 'password1')

orga1 = Orga.create(title: 'Afeefa')
orga2 = Orga.create(title: 'Dresden für Alle e.V.')
orga3 = Orga.create(title: 'TU Dresden')
orga4 = Orga.create(title: 'Ausländerrat')
orga5 = Orga.create(title: 'Frauentreff "Hand in Hand"')
orga6 = Orga.create(title: 'Integrations- und Ausländerbeauftragte')
orga7 = Orga.create(title: 'Übersetzer Deutsch-Englisch-Französisch')
event1 = Event.create(title: 'Sommerfest', parent_id: orga4)
event2 = Event.create(title: 'Deutschkurs', parent_id: orga5)
event3 = Event.create(title: 'Kulturtreff', parent_id: orga5)
event4 = Event.create(title: 'Offenes Netzwerktreffen Dresden für Alle', parent_id: orga2)
suborga1 = Orga.create(title: 'Interkultureller Frauentreff', parent_orga: orga4)
suborga2 = Orga.create(title: 'Außenstelle Adlergasse', parent_orga: orga4)


Role.create(user: user6, orga: orga1, title: Role::ORGA_ADMIN)
Role.create(user: user7, orga: orga1, title: Role::ORGA_ADMIN)
Role.create(user: user1, orga: orga1, title: Role::ORGA_MEMBER)
Role.create(user: user2, orga: orga1, title: Role::ORGA_MEMBER)
Role.create(user: user3, orga: orga1, title: Role::ORGA_MEMBER)
Role.create(user: user4, orga: orga1, title: Role::ORGA_MEMBER)
Role.create(user: user5, orga: orga1, title: Role::ORGA_MEMBER)

Role.create(user: user3, orga: orga2, title: Role::ORGA_ADMIN)
Role.create(user: user1, orga: orga2, title: Role::ORGA_MEMBER)

Role.create(user: user4, orga: orga3, title: Role::ORGA_ADMIN)
Role.create(user: user1, orga: orga3, title: Role::ORGA_MEMBER)
Role.create(user: user3, orga: orga3, title: Role::ORGA_MEMBER)
Role.create(user: user5, orga: orga3, title: Role::ORGA_MEMBER)
