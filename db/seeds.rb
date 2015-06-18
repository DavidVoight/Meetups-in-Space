# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Example:
#
#   Person.create(first_name: 'Eric', last_name: 'Kelly')


  Meetup.create(name: "Six Flags", description: "Theme Park", location: "Jackson, NJ")
  Meetup.create(name: "Harvard", description: "A tour of the college", location: "Cambridge, MA")

  User.create( provider: 'github', uid: 'dude', email: 'somedude@gmail.com', username: 'Duuuude', avatar_url: 'dude.com')
	User.create( provider: 'github1', uid: 'somedude', email: 'someotherdude@gmail.com', username: 'Wheresmycar?', avatar_url: 'wheres your car dude.com')

  Connection.create(meetup_id: 1, user_id: 1, owner: true)
  Connection.create(meetup_id: 2, user_id: 2, owner: true)
