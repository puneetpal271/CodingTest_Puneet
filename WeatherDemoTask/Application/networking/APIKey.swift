//
//  APIKey.swift
//  WeatherDemoTask
//
//  Created by Puneetpal Singh on 5/16/23.
//

import Foundation

class APIKey{
    
    //MARK: - API Key get from Info.plit file to security purpose

    static func getWeatherAPIString() -> String {
        var keyString = ""
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let valueDict = NSDictionary(contentsOfFile: path) {
            keyString = valueDict["OPEN_WEATHER_API_KEY"] as? String ?? ""
        }
        return "appid=\(keyString)"
    }
}
