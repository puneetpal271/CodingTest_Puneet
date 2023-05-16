//
//  Extension+WeatherView+SearchBar.swift
//  WeatherDemoTask
//  Created by Puneetpal Singh on 5/16/23.
//

import Foundation
import UIKit
import MapKit
// MARK: Searching

extension WeatherView: UISearchResultsUpdating ,UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        selectedScopeIndex=selectedScope
        print(selectedScopeIndex)
        if(selectedScopeIndex==1){
            results.locations = []
            results.tableView.reloadData()
        }
    }

    ///  MEHTOD DELEGATE : updateSearchResults

    public func updateSearchResults(for searchController: UISearchController) {
        print(#function)

        guard let term = searchController.searchBar.text else { return }
        print(term)
        if(selectedScopeIndex==1){
            return
        }

        searchTimer?.invalidate()

        let searchTerm = term.trimmingCharacters(in: CharacterSet.whitespaces)

        if !searchTerm.isEmpty {
            showItemsForSearchResult(nil)
            searchTimer = Timer.scheduledTimer(timeInterval: 0.2,
                                               target: self, selector: #selector(searchFromTimer(_:)),
                                               userInfo: [WeatherView.SearchTermKey: searchTerm],
                                               repeats: false)
        }
    }

    ///  MEHTOD  : searchBarSearchButtonClicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if(selectedScopeIndex==1){
            let textData = searchBar.text ?? "";
            if(!(searchBar.text!.isEmpty)){
                //STORE SEARCH DATA IN LOCAL STORE
                UserDefaultHelper.storeSearchData(text: textData, lat: 0.0, long: 0.0)
                self.vm.delegate = self
                dismiss(animated: true) {
                    self.vm.getWeatherInformationByQuery(text: textData, viewController: self)
                }
            }

        }

    }


    ///  MEHTOD  : searchFromTimer
    ///  While Typing that method invoked
    ///
    @objc func searchFromTimer(_ timer: Timer) {
        guard let userInfo = timer.userInfo as? [String: AnyObject],
              let term = userInfo[WeatherView.SearchTermKey] as? String
        else { return }
        if(!InternetChecker().isAvailable()){
            AlertView().showNoInternetAlert(delegate: self, pop: false,isDismissButton: true) {

            }
            return
        }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = term

        localSearch?.cancel()
        localSearch = MKLocalSearch(request: request)
        localSearch!.start { response, _ in
            self.showItemsForSearchResult(response)
        }
    }

    ///  MEHTOD  : showItemsForSearchResult
    ///  Parse Searched Locations
    ///  
    func showItemsForSearchResult(_ searchResult: MKLocalSearch.Response?) {
        results.locations = searchResult?.mapItems.map { Location(name: $0.name, placemark: $0.placemark) } ?? []
        results.isShowingHistory = false
        results.tableView.reloadData()
    }


    ///  MEHTOD  : selectedLocation
    ///  When Select lication fron suggestion list then Invoke method

    func selectedLocation(_ location: Location) {
        // dismiss search results
        var textData = "";
        if let text = location.name{
            self.searchController.searchBar.text =  text
            textData = text
        }

        dismiss(animated: true) {
            let lat = location.location.coordinate.latitude
            let lng = location.location.coordinate.longitude
            //STORE SEARCH DATA IN LOCAL STORE
            UserDefaultHelper.storeSearchData(text: textData, lat: lat, long: lng)
            self.vm.delegate = self
            self.vm.getWeatherInformationByLatLong(lat: lat, lng: lng, viewController: self)
        }
    }
}

/*

 //set specific country
 //        let usaCoordinate =  CLLocationCoordinate2D(latitude: 37.090194, longitude:-95.712889)
 //       request.region = MKCoordinateRegion(center: usaCoordinate, span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
 //   request.region = MKCoordinateRegion(.)

 //(latitude: usaCoordinate.latitude, longitude: usaCoordinate.longitude)
 */
