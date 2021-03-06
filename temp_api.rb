
game_array = Football.where("home_team = ?", "New York Giants")
date_array =[]
game_array.each do |game|
  mintemp = []
  meantemp = []
  maxtemp = []
  minwind = []
  meanwind = []
  maxwind = []
  precip = []
  cldcvr = []
  hum = []
  cache = Weather.new({game_id: game.game_id})
  if cache.class.exists?(game_id: game.game_id) == false
    for i in 1..6
      date_array = game.date.split("-")
      date_array[0] = date_array[0].to_i - i
      game_date = date_array.join("-")
      url = "https://api.weathersource.com/v1/#{ENV['WEATHERSOURCE_CLIENT_ID']}/history_by_postal_code.json?period=day&postal_code_eq=#{game[:zip]}&country_eq=US&timestamp_eq=#{game_date}&fields=tempMax,tempAvg,tempMin,precip,snowfall,windSpdMax,windSpdAvg,windSpdMin,cldCvrAvg,relHumAvg"
      response = HTTParty.get(url)
      if response[0] != nil
        mintemp << response[0]["tempMin"]
        meantemp << response[0]["tempAvg"]
        maxtemp << response[0]["tempMax"]
        minwind << response[0]["windSpdMin"]
        meanwind << response[0]["windSpdAvg"]
        maxwind << response[0]["windSpdMax"]
        precip << response[0]["precip"]
        cldcvr << response[0]["cldCvrAvg"]
        hum << response[0]["relHumAvg"]
      else
        mintemp << "nil"
        meantemp << "nil"
        maxtemp << "nil"
        minwind << "nil"
        meanwind << "nil"
        maxwind << "nil"
        precip << "nil"
        cldcvr << "nil"
        hum << "nil"
        # puts "none"
      end
      puts i
      sleep 0.1
    end
    cache = Weather.new({
          sport: game.class.name,
          game_id: game.game_id,
          min_temp: mintemp.join(","),
          mean_temp: meantemp.join(","),
          max_temp: maxtemp.join(","),
          min_wind: minwind.join(","),
          mean_wind: meanwind.join(","),
          max_wind: maxwind.join(","),
          precipitation: precip.join(","),
          cloud_cover: cldcvr.join(","),
          humidity: hum.join(",")
        })
    cache.save
    sleep 40
  else
    puts "entry exists already"
  end

end
