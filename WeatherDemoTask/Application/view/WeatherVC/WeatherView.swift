//
//  WeatherView.swift
//  WeatherDemoTask
//
//  Created by Puneetpal Singh on 5/16/23.
//

import UIKit
import CoreLocation
import MapKit

class WeatherView: UIViewController {
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var mintemperature: UILabel!
    @IBOutlet weak var maxtemperature: UILabel!
    @IBOutlet weak var sunRiseTime: UILabel!
    @IBOutlet weak var sunSetTime: UILabel!
    @IBOutlet weak var humidityResult: UILabel!
    @IBOutlet weak var feelLikeResult: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var vStackView: UIStackView!
    var selectedScopeIndex = 0;
    //LOCATION PICKER RESULT VIEW
    lazy var results: LocationSearchResultsViewController = {
        let results = LocationSearchResultsViewController()
        results.onSelectLocation = { [weak self] in self?.selectedLocation($0) }
        return results
    }()

    static let SearchTermKey = "SearchTermKey"

    let geocoder = CLGeocoder()

    var localSearch: MKLocalSearch?

    var searchTimer: Timer?

    //SEARCH CONTROLLER WITH PASS LOCATION PICKER RESULT VIEW AS RESULT VARIABLE

    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: self.results)
        search.searchResultsUpdater = self
        search.hidesNavigationBarDuringPresentation = false
        return search
    }()
    var vm = WeatherViewModelContainer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title =  "title_Nav_Bar_Weather".localized()
        spinner.startAnimating()
        searchInit()
        self.vStackView.isHidden = true

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        getLastSearchData()
    }
   func getLastSearchData(){
        if let searchLastData =   UserDefaultHelper.getLastSearchData(){
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
            vm.delegate = self
            searchController.searchBar.text = searchLastData.address

            if(searchLastData.lat != 0.0){
                vm.getWeatherInformationByLatLong(lat:searchLastData.lat,lng:searchLastData.lng, viewController: self)
            }else{
                vm.getWeatherInformationByQuery(text: searchLastData.address, viewController: self)
            }
        }else{
            LocationService.shared.startDetectLocation(delegate: self)
        }
    }
    //MARK: - SEARCH INIT

    func searchInit() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "plc_Search_Bar".localized()
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = ["lbl_WithAutoComplete".localized(), "lbl_WithoutAutoComplete".localized()]
        searchController.searchBar.showsScopeBar = true

    }

    //MARK: - SET DATA IN UI COMPONENTS

    func setData(){
        self.vStackView.isHidden = false
        locationName.text = vm.weather.name
        weatherDescription.text = vm.weather.description
        temperature.text =  WeatherManager.convertTemp(temp: vm.weather.temp, from: .kelvin, to: .celsius, tempStringUnit: .withDegree)
        mintemperature.text =  WeatherManager.convertTemp(temp: vm.weather.temp_min, from: .kelvin, to: .celsius, tempStringUnit: .withDegree)
        maxtemperature.text =  WeatherManager.convertTemp(temp: vm.weather.temp_max, from: .kelvin, to: .celsius, tempStringUnit: .withDegree)
        sunRiseTime.text = WeatherManager.convertUnixTime(time: vm.weather.sunrise, timeZone: vm.weather.timezone)
        sunSetTime.text = WeatherManager.convertUnixTime(time: vm.weather.sunset, timeZone: vm.weather.timezone)
        humidityResult.text = String(format: "%d %@", vm.weather.humidity, "%")
        feelLikeResult.text = WeatherManager.convertTemp(temp: vm.weather.feels_like, from: .kelvin, to: .celsius, tempStringUnit: .withDegree)
        var  urlString =  UrlConstant.WS_IMAGE_URL
        urlString = urlString.replacingOccurrences(of: "{IMAGENAME}", with:vm.weather.icon )
        if let imgUrl = URL(string:urlString){
            icon.loadImages(url: imgUrl )
        }

    }
}


//MARK: - LocationServiceDelegate

extension WeatherView :LocationServiceDelegate{
    func locationResult(locationData: LocationDataModel) {
        vm.delegate = self
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }

        vm.getWeatherInformationByLatLong(lat:locationData.lat,lng:locationData.lng, viewController: self)
    }
    func locationError() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
}


//MARK: - WeatherViewModelContainerDelegate

extension WeatherView :WeatherViewModelContainerDelegate{
    func viewModelDidUpdate() {
        setData()
    }

    func viewModelUpdateFailed(error: String) {

    }

}
