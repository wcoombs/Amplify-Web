# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
Voter.create([{room_id: 1}, {room_id: 1}])
Vote.create([{score: 1, song_id: 1, voter_id: 1}, {score: -1, song_id: 2, voter_id: 2}, {score: 1, song_id: 1, voter_id: 1}, {score: -1, song_id: 2, voter_id: 2}])
songs = Song.create([{ title: 'Toxic' }, {title: 'Wonderwall'}, {title: 'Take Me to Church'}])
Room.create([{songs: songs}])
