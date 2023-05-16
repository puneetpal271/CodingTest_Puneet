//
//  LocationDataModel.swift
//  WeatherDemoTask
//
//  Created by Puneetpal Singh on 5/16/23.
//

import Foundation
class LocationDataModel{
    var address = ""
    var city = ""
    var state = ""
    var country = ""
    var lat = 0.0
    var lng = 0.0
    init(){

    }
    init(address: String = "", city: String = "", state: String = "", country: String = "", lat: Double = 0.0, lng: Double = 0.0) {
        self.address = address
        self.city = city
        self.state = state
        self.country = country
        self.lat = lat
        self.lng = lng
    }
}
