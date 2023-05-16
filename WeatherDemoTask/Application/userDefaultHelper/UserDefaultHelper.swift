//
//  UserDefaultHelper.swift
//  WeatherDemoTask


import Foundation
class UserDefaultHelper{
    static let UD_LastSearchText  : String = "UD_LastSearchData"
    static let UD_LastSearchLat  : String = "UD_LastSearchLat"
    static let UD_LastSearchLong  : String = "UD_LastSearchLong"

    static func storeSearchData(text:String,lat:Double,long:Double){
        UserDefaults.standard.set(text, forKey: UserDefaultHelper.UD_LastSearchText)
        UserDefaults.standard.set(lat, forKey: UserDefaultHelper.UD_LastSearchLat)
        UserDefaults.standard.set(long, forKey: UserDefaultHelper.UD_LastSearchLong)
    }

    static func getLastSearchData()->LocationDataModel?{
        let text = UserDefaults.standard.string(forKey: UserDefaultHelper.UD_LastSearchText) ?? ""
        let lat = UserDefaults.standard.double(forKey: UserDefaultHelper.UD_LastSearchLat)
        let long = UserDefaults.standard.double(forKey: UserDefaultHelper.UD_LastSearchLong)
    
        if(lat == 0.0  && long == 0.0 && text == ""){
            return nil
        }else{
          return  LocationDataModel(address: text,lat: lat,lng: long)
        }

    }
}
