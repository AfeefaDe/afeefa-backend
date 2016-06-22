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

orga1 = Orga.create(title: 'Afeefa')
orga2 = Orga.create(title: 'Dresden für Alle e.V.')
orga3 = Orga.create(title: 'TU Dresden')


Role.create(user: user6, orga: orga1, title: Role::ORGA_ADMIN)
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

user1 = User.create(email: 'email1@afeefa.de', forename: 'forename1', surname: 'surname1', password: 'password1')
user2 = User.create(email: 'email2@afeefa.de', forename: 'forename2', surname: 'surname2', password: 'password2')
user3 = User.create(email: 'email3@afeefa.de', forename: 'forename3', surname: 'surname3', password: 'password3')
user4 = User.create(email: 'email4@afeefa.de', forename: 'forename4', surname: 'surname4', password: 'password4')
user5 = User.create(email: 'email5@afeefa.de', forename: 'forename5', surname: 'surname5', password: 'password5')
user6 = User.create(email: 'email6@afeefa.de', forename: 'forename6', surname: 'surname6', password: 'password6')
user7 = User.create(email: 'email7@afeefa.de', forename: 'forename7', surname: 'surname7', password: 'password7')

orga1 = Orga.create(title: 'orga1')
orga2 = Orga.create(title: 'orga2')
orga3 = Orga.create(title: 'orga3')


Role.create(user: user1, orga: orga1, title: Role::ORGA_ADMIN)
Role.create(user: user2, orga: orga1, title: Role::ORGA_MEMBER)
Role.create(user: user3, orga: orga1, title: Role::ORGA_MEMBER)
Role.create(user: user4, orga: orga1, title: Role::ORGA_MEMBER)
Role.create(user: user5, orga: orga1, title: Role::ORGA_MEMBER)

Role.create(user: user1, orga: orga2, title: Role::ORGA_MEMBER)
Role.create(user: user2, orga: orga2, title: Role::ORGA_MEMBER)
Role.create(user: user6, orga: orga2, title: Role::ORGA_ADMIN)
Role.create(user: user7, orga: orga2, title: Role::ORGA_MEMBER)

Role.create(user: user1, orga: orga3, title: Role::ORGA_ADMIN)