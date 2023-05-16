//
//  WeatherDataModel.swift
//  WeatherDemoTask
//
//  Created by Puneetpal Singh on 5/16/23.
//

import Foundation

struct WeatherDataModel {
    let name: String
    let main: String
    let description: String
    let temp: Double
    let temp_max: Double
    let temp_min: Double

    let sunrise: Int64
    let sunset: Int64
    let clouds: Int64
    let humidity: Int64
    let wind: NSDictionary
    let feels_like: Double
    let pressure: Int64
    let visibility: Int64
    let timezone: Int64
    let icon: String
    init(){
        self.name = ""
        self.main = ""
        self.description = ""
        self.temp = 0.0
        self.temp_max = 0.0
        self.temp_min = 0.0

        self.sunrise = 0
        self.sunset = 0
        self.clouds = 0
        self.humidity = 0
        self.wind = NSDictionary()
        self.feels_like = 0.0
        self.pressure = 0
        self.visibility = 0

        self.timezone = 0
        self.icon = ""
    }
    
    init(name: String, main: String, description: String, temp: Double, temp_max: Double, temp_min: Double,
         sunrise: Int64, sunset: Int64, clouds: Int64, humidity: Int64, wind: NSDictionary, feels_like: Double,
         pressure: Int64, visibility: Int64, timezone: Int64,icon:String) {
        self.name = name
        self.main = main
        self.description = description
        self.temp = temp
        self.temp_max = temp_max
        self.temp_min = temp_min

        self.sunrise = sunrise
        self.sunset = sunset
        self.clouds = clouds
        self.humidity = humidity
        self.wind = wind
        self.feels_like = feels_like
        self.pressure = pressure
        self.visibility = visibility

        self.timezone = timezone
        self.icon = icon
    }

    init?(dict: [String: Any]) {
        self.name = dict["name"] as? String ?? ""
        self.visibility = dict["visibility"] as? Int64 ?? 0
        self.timezone = dict["timezone"] as? Int64 ?? 0

        let main = dict["main"] as? NSDictionary
        self.temp = main?.value(forKey: "temp") as? Double ?? 0
        self.temp_max = main?.value(forKey: "temp_max") as? Double ?? 0
        self.temp_min = main?.value(forKey: "temp_min") as? Double ?? 0
        self.feels_like = main?.value(forKey: "feels_like") as? Double ?? 0
        self.humidity = main?.value(forKey: "humidity") as? Int64 ?? 0
        self.pressure = main?.value(forKey: "pressure") as? Int64 ?? 0

        let weather = (dict["weather"] as? NSArray)?.firstObject as? NSDictionary
        self.main = weather?["main"] as? String ?? ""
        self.description = weather?["description"] as? String ?? ""
        self.icon = weather?["icon"] as? String ?? ""
        let sys = dict["sys"] as? NSDictionary ?? [:]
        self.sunrise = sys.value(forKey: "sunrise") as? Int64 ?? 0
        self.sunset = sys.value(forKey: "sunset") as? Int64 ?? 0

        let clouds = dict["clouds"] as? NSDictionary
        self.clouds = clouds?.value(forKey: "all") as? Int64 ?? 0

        self.wind = dict["wind"] as? NSDictionary ?? [:]

    }
}
