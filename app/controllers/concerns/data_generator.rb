module Data_Generator
  extend ActiveSupport::Concern
  include Mapping

  SONG_LIST = [
      {title: "Toxic", artist: "Britney Spears", duration: "198800", uri: "spotify:track:6I9VzXrHxO9rA9A5euc8Ak"},
      {title: "Bad Blood", artist: "T-Swift", duration: "211933", uri: "spotify:track:273dCMFseLcVsoSWx59IoE"},
      {title: "Buttons", artist: "Pussycat Dolls", duration: "225560", uri: "spotify:track:3BxWKCI06eQ5Od8TY2JBeA"},
      {title: "Wake Me Up When September Ends", artist: "Green Day", duration: "285653", uri: "spotify:track:3ZffCQKLFLUvYM59XKLbVm"},
      {title: "Never Gonna Give You Up", artist: "Rick Astley", duration: "213573", uri: "spotify:track:4uLU6hMCjMI75M1A2tKUQC"},
      {title: "Champagne Supernova", artist: "Oasis", duration: "448438", uri: "spotify:track:40bynawzslg9U7ACq07fAj"},
      {title: "Wonderwall", artist: "Oasis", duration: "258732", uri: "spotify:track:5wj4E6IsrVtn8IBJQOd0Cl"},
      {title: "Bad Touch", artist: "Bloodhound Gang", duration: "260506", uri: "spotify:track:5EYdTPdJD74r9EVZBztqGG"},
      {title: "Pump It", artist: "The Black Eyed Peas", duration: "213066", uri: "spotify:track:6btyEL6NwUa97Nex9cZFvo"},
      {title: "Violin Concerto in F Minor", artist: "Antonio Vivaldi", duration: "117906", uri: "spotify:track:7njAZhca4o80qQdCgyEWya"},
      {title: "Jump on It!", artist: "Sugarhill Gang", duration: "184360", uri: "spotify:track:1njjatLjMVkfmMumRg0WV1"},
      {title: "Shake it Off", artist: "T-Swift", duration: "219200", uri: "spotify:track:5xTtaWoae3wi06K5WfVUUH"},
      {title: "Crazy in Love", artist: "Beyonce", duration: "236133", uri: "spotify:track:5IVuqXILoxVWvWEPm82Jxr"},
      {title: "Prytania", artist: "Mutemath", duration: "252720", uri: "spotify:track:2dM3803quujZOCs9I4auDZ"},
      {title: "White Blank Page", artist: "Mumford and Sons", duration: "254160", uri: "spotify:track:2QulT0LDnhH7011gzjFvLS"},
      {title: "Womanizer", artist: "Britney Spears", duration: "224400", uri: "spotify:track:4fixebDZAVToLbUCuEloa2"},
      {title: "Umbrella", artist: "Rihanna", duration: "275986", uri: "spotify:track:49FYlytm3dAAraYgpoJZux"},
      {title: "Hollaback Girl", artist: "Gwen Stefani", duration: "199906", uri: "spotify:track:6RcQOut9fWL6FSqeIr5M1r"},
      {title: "Burnin' Up", artist: "Jonas Brothers", duration: "175093", uri: "spotify:track:3cfYgVP1zAiX87oz23nFyZ"},
      {title: "Fishin' in the Dark", artist: "Nitty Gritty Dirt Band", duration: "202786", uri: "spotify:track:19Pwe795pS5bS2Jr57gHK3"},
      {title: "Tik Tok", artist: "Kesha", duration: "199693", uri: "spotify:track:5OMwQFBcte0aWFJFqrr5oj"},
      {title: "Vindicated", artist: "Dashboard Confessional", duration: "201346", uri: "spotify:track:1EotcFbWTbMCXeKFVEtX6Y"},
      {title: "Sugar We're Going Down", artist: "Fall Out Boy", duration: "229093", uri: "spotify:track:2TfSHkHiFO4gRztVIkggkE"},
      {title: "Monkey Wrench", artist: "Foo Fighters", duration: "231480", uri: "spotify:track:44wXefe8WB9Fd6xwtmAwbR"}
  ]

  def add_songs(room_id)
    for i in 0..4
      song_num = rand(SONG_LIST.length)
      song = Song.create(title: SONG_LIST[song_num][:title],
                         artist: SONG_LIST[song_num][:artist],
                         duration: SONG_LIST[song_num][:duration],
                         uri: SONG_LIST[song_num][:uri],
                         room_id: room_id)
      if i == 0
        song.update(song_status: Song::UP_NEXT_STATUS)
      end
    end
  end
end
