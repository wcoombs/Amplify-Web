class SongListController < ApplicationController
  def index
    # this will eventually get song data from database, then we can pass votes into the view as well
    @songs = ["Africa", "Come Sail Away", "The Final Countdown", "Lake Shore Drive",
    "Mr. Blue Sky", "Twist and Shout", "Viva La Vida", "Toxic"]
  end
end
