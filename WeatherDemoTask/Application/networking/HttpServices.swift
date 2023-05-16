//
//  HttpServices.swift
//  WeatherDemoTask
//
//  Created by Puneetpal Singh on 5/16/23.
//

import Foundation
import UIKit
class HttpServices{
    private let key = APIKey.getWeatherAPIString()
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    typealias JSonDictionary = [String: Any]
    typealias ResponseResult = (JSonDictionary) -> Void
    func getResultsByLatLong(url:String,viewController:UIViewController, completion: @escaping ResponseResult) {

        var urlEndpoint = url

        dataTask?.cancel()

        urlEndpoint  = "\(urlEndpoint)&\(key)"
        if(!InternetChecker().isAvailable()){
            AlertView().showNoInternetAlert(delegate: viewController, pop: false) {
                self.getResultsByLatLong(url:url,viewController:viewController, completion: completion)
            }
            return
        }
        urlEndpoint = urlEndpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let  url = URL(string: urlEndpoint) else {
            print("URL is nill")
            return
        }


        print(url)
        viewController.pleaseWait()
        dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            viewController.dismissLoader()
            if let error = error {
                print("error: \(error.localizedDescription)")
                if let errorCode = error as NSError?, errorCode.code == NSURLErrorTimedOut {
                    print("###Time out###")
                    return
                }
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {

                var responseData: JSonDictionary?
                do {
                    responseData = try JSONSerialization.jsonObject(with: data, options: []) as? JSonDictionary
                } catch let parseError as NSError {
                    print("JSONSerialization error: \(parseError.localizedDescription)")
                    return
                }

                DispatchQueue.main.async {
                    print("\(String(describing: responseData))")
                    completion(responseData!)
                }
            }else {
                DispatchQueue.main.async {

                AlertView().showAlert(message: "lbl_NoDataFound".localized(), delegate: viewController, pop: false)
                }
            }
        }
        dataTask?.resume()

    }
}



