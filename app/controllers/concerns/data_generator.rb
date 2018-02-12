module Data_Generator
  extend ActiveSupport::Concern

  SONG_LIST = [
      "Toxic",
      "Bad Blood",
      "Never Gonna Give You Up",
      "Champagne Supernova",
      "Wonderwall",
      "Bad Touch",
      "Pump It",
      "Violin Concerto in F Minor",
      "Jump on It",
      "Shake it Off",
      "Crazy in Love",
      "Prytania",
      "White Blank Page",
      "Womanizer",
      "Umbrella",
      "Hollaback Girl",
      "Burnin' Up",
      "Buttons",
      "Fishin' in the Dark",
      "Tik Tok",
      "Vindicated",
      "Sugar We're Going Down",
      "Monkey Wrench",
      "Wake Me Up When September Ends",
  ]

  def add_songs(room_id)
    for i in 0..4
      song_num = rand(SONG_LIST.length)
      Song.create(title: SONG_LIST[song_num], room_id:room_id)
    end
  end
end
