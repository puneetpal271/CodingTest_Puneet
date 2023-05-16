//
//  UrlConstant.swift
//  WeatherDemoTask
//
//  Created by Puneetpal Singh on 5/16/23.
//

import Foundation
class UrlConstant{
    static let BASEURL = "https://api.openweathermap.org/"
    static let BASEURL_VERSION = BASEURL+"data/2.5/"
    static let WS_WEATHER = BASEURL_VERSION+"weather?"
    static let WS_GET_WEATHER = WS_WEATHER
    static let WS_IMAGE_URL = "https://openweathermap.org/img/wn/{IMAGENAME}@2x.png"

}
