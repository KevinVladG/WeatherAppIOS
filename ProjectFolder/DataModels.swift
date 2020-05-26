//
//  DataModels.swift
//  HW04
//
//  Created by Kevin Granados on 4/2/20.
//  Copyright © 2020 Kevin Granados. All rights reserved.
//

import Foundation
import SwiftyJSON

public class WeatherData {
    var time: String?
    var weather:WeatherInfo?
    var main:mainInfo?
    var wind:windInfo?
    var clouds:cloudInfo?
    
    init(json:JSON){
        self.time = json["dt_txt"].stringValue
        let weather = json["weather"].arrayValue
        self.weather = WeatherInfo(jsonWeather: weather[0])
        self.main = mainInfo(JsonMain: json["main"])
        self.wind = windInfo(json: json["wind"])
        self.clouds = cloudInfo(json: json["clouds"])
    }
}

class mainInfo{
    var temperature:String?
    var temperatureMax:String?
    var temperatureMin:String?
    var humidity:String?
    
    init(JsonMain:JSON){
        self.temperature = "\(String(format: "%.1f",convertToF(temperature: JsonMain["temp"].doubleValue)))"
        self.temperatureMax = "\(String(format: "%.1f",convertToF(temperature: JsonMain["temp_max"].doubleValue)))"
        self.temperatureMin = "\(String(format: "%.1f",convertToF(temperature: JsonMain["temp_min"].doubleValue)))"
        self.humidity = "\(JsonMain["humidity"].stringValue)%"
    }
    
    func convertToF(temperature:Double) -> Double{
        let result = (temperature - 273.15) * (9/5) + 32
        
        return result
    }
    
}

class WeatherInfo{
    var description:String?
    var icon:String?

    init(jsonWeather:JSON){
        self.description = jsonWeather["description"].stringValue
        self.icon = "https://openweathermap.org/img/wn/\(jsonWeather["icon"].stringValue)@2x.png"
    }
    
}

class windInfo{
    var windSpeed:String?
    var windDegree:String?
    init(json:JSON){
        self.windSpeed = "\(json["speed"].stringValue) miles/hr"
        self.windDegree = "\(json["deg"].stringValue) degrees"
    }
}

class cloudInfo {
    var cloudiness:String?
    init(json:JSON){
        self.cloudiness = "\(json["all"].stringValue)%"
    }
}



