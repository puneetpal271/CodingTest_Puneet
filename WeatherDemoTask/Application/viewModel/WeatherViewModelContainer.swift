//
//  WeatherViewModelContainer.swift
//  WeatherDemoTask
//
//  Created by Puneetpal Singh on 5/16/23.
//

import Foundation
import UIKit
protocol WeatherViewModelContainerDelegate {
    func viewModelDidUpdate()
    func viewModelUpdateFailed(error : String)
}

class WeatherViewModelContainer: NSObject {

    var delegate : WeatherViewModelContainerDelegate? = nil
    var httpService = HttpServices()
    var weather = WeatherDataModel()

    //MARK: - METHOD getWeatherInformationByLatLong
    /////search weather by Lat Long
    func getWeatherInformationByLatLong(lat:Double,lng:Double,viewController:UIViewController){
        httpService.getResultsByLatLong(url: UrlConstant.WS_GET_WEATHER+"lat=\(lat)&lon=\(lng)", viewController: viewController) { jsonDic in
            print(#function)
            print(jsonDic)
            self.weather = WeatherDataModel(dict: jsonDic) ??  self.weather
            self.delegate?.viewModelDidUpdate()
        }
    }
    //MARK: - METHOD getWeatherInformationBySeparateCityCountryZipCode

    func getWeatherInformationByCity_Country_ZipCode(city:String = "",country:String = "",zipcode:String = "",viewController:UIViewController){

        var url = UrlConstant.WS_GET_WEATHER+"q=";
        var param = [String]()
        if(city != ""){
            param.append(city)
        }
        if(country != ""){
            param.append(country)
        }
        if(zipcode != ""){
            param.append(zipcode)
        }
        url = param.joined(separator: ",")
        httpService.getResultsByLatLong(url:url, viewController: viewController) { jsonDic in
            print(#function)
            print(jsonDic)
            self.weather = WeatherDataModel(dict: jsonDic) ??  self.weather
            self.delegate?.viewModelDidUpdate()
        }
    }
    //MARK: - METHOD getWeatherInformationByText

    func getWeatherInformationByQuery(text:String,viewController:UIViewController){

        let url = UrlConstant.WS_GET_WEATHER+"q=\(text)";

        httpService.getResultsByLatLong(url:url, viewController: viewController) { jsonDic in
            print(#function)
            print(jsonDic)
            self.weather = WeatherDataModel(dict: jsonDic) ??  self.weather
            self.delegate?.viewModelDidUpdate()
        }
    }
}
