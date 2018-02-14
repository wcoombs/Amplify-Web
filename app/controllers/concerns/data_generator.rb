module Data_Generator
  extend ActiveSupport::Concern

  SONG_LIST = [
      {title: "Toxic", artist: "Britney Spears"},
      {title: "Bad Blood", artist: "T-Swift"},
      {title: "Buttons", artist: "Pussycat Dolls"},
      {title: "Wake Me Up When September Ends", artist: "Green Day"},
      {title: "Never Gonna Give You Up", artist: "Rick Astley"},
      {title: "Champagne Supernova", artist: "Oasis"},
      {title: "Wonderwall", artist: "Oasis"},
      {title: "Bad Touch", artist: "Bloodhound Gang"},
      {title: "Pump It", artist: "The Black Eyed Peas"},
      {title: "Violin Concerto in F Minor", artist: "Antonio Vivaldi"},
      {title: "Jump on It", artist: "Sugarhill Gang"},
      {title: "Shake it Off", artist: "T-Swift"},
      {title: "Crazy in Love", artist: "Beyonce"},
      {title: "Prytania", artist: "Mutemath"},
      {title: "White Blank Page", artist: "Mumford and Sons"},
      {title: "Womanizer", artist: "Britney Spears"},
      {title: "Umbrella", artist: "Rihanna"},
      {title: "Hollaback Girl", artist: "Gwen Stefani"},
      {title: "Burnin' Up", artist: "Jonas Brothers"},
      {title: "Fishin' in the Dark", artist: "Nitty Gritty Dirt Band"},
      {title: "Tik Tok", artist: "Kesha"},
      {title: "Vindicated", artist: "Dashboard Confessional"},
      {title: "Sugar We're Going Down", artist: "Fall Out Boy"},
      {title: "Monkey Wrench", artist: "Foo Fighters"}
  ]

  def add_songs(room_id)
    for i in 0..4
      song_num = rand(SONG_LIST.length)
      Song.create(title: SONG_LIST[song_num][:title],
                  artist: SONG_LIST[song_num][:artist],
                  room_id:room_id)
    end
  end
end
