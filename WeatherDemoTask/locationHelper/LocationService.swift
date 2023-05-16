//
//  LocationService.swift
//


import Foundation
import UIKit
import CoreLocation
protocol LocationServiceDelegate{
    func locationResult(locationData:LocationDataModel)
    func locationError()
}
class LocationService:NSObject,CLLocationManagerDelegate{
    static let shared = LocationService()
    var locationManager:CLLocationManager!
    var ceo: CLGeocoder = CLGeocoder()
    var delegate:LocationServiceDelegate!
    typealias completionBlock = (String?)->Void
    func startDetectLocation(delegate:LocationServiceDelegate){

        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        self.delegate = delegate
        if(!InternetChecker().isAvailable()){
            AlertView().showNoInternetAlert(delegate: delegate as! UIViewController, pop: false,isDismissButton: true) {

            }
            self.delegate.locationError()
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied){
            AlertView().showLocationSettingAlert(message: "msg_location_Permission".localized(), delegate: self.delegate as! UIViewController, pop: false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let  location = locations.first!
//        let  latitude =  "\(location.coordinate.latitude)"
//        let  Longitute = "\(location.coordinate.longitude)"
        locationManager.stopUpdatingLocation()
        ceo.reverseGeocodeLocation(CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)) { (placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
                self.delegate.locationError()
            }
            if(placemarks == nil){
                self.delegate.locationError()
                return
            }
            let pm = placemarks! as [CLPlacemark]
            if pm.count > 0 {
                let pm = placemarks![0]
//                print(pm.name ?? "")
//                print(pm.country ?? "")
//                print(pm.locality ?? "")
//                print(pm.subLocality ?? "")
//                print(pm.thoroughfare ?? "")
//                print(pm.postalCode ?? "")
//                print(pm.administrativeArea ?? "")
//                print(pm.subThoroughfare ?? "")
                
                var addressString : String = ""
                
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.administrativeArea != nil {
                    addressString = addressString + pm.administrativeArea! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                debugPrint(addressString)
                let data = LocationDataModel()
                data.address = addressString
                data.city = pm.locality ?? ""
                data.state = pm.administrativeArea ?? ""
                data.country = pm.country ?? ""
                data.lat = pm.location?.coordinate.latitude ?? 0.0
                data.lng = pm.location?.coordinate.longitude ?? 0.0
                self.delegate.locationResult(locationData: data)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        self.delegate.locationError()
    }

}

