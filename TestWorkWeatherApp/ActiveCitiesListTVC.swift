//
//  ActiveCitiesListTVC.swift
//  TestWorkWeatherApp
//
//  Created by Nikita Vesna on 23.06.2020.
//  Copyright © 2020 Nikita Vesna. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

class ActiveCitiesListTVC: UITableViewController, UISearchBarDelegate {
    
    var storedCities: Results<Cities>!
    var citiesList: [Cities] = []
    
    
    static let weatherManager = APIWeatherManager(apiKey: "8ed4a42d3c54264f52124709334fd797")
    
    var refreshTimer: Timer!
    
    
    static var sharedId: Int!
    
    
    @IBAction func refreshBtnPressed(_ sender: UIBarButtonItem) {
        refreshEveryHour()
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storedCities = realm.objects(Cities.self)
        
        setupSearchBar()
        
        //Locating on startup
        checkLocationServices()
        
        //Filling array of active cities
        
        if !storedCities.isEmpty {
            for city in storedCities {
                let transfer = Cities(name: city.name, country: city.country, id: city.id)
                citiesList.append(transfer)
            }
        }
        
        
        setupTimer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            let location = self.getLocation()
            self.getCurrentWeatherData(coordinates: location)
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! ActiveCitiesListCell
        
        cell.cityTempLbl.text = ""
        cell.cityNameLbl.text = citiesList[indexPath.row].name
        
        
        ActiveCitiesListTVC.weatherManager.fetchCompactWeatherWithID(id: citiesList[indexPath.row].id) { (result) in
            
            switch result {
            case .Success(let currentWeather):
                
                cell.cityTempLbl.text = currentWeather.temperatureString
                
                
            case .Failure(let error as NSError):
                
                let alertController = UIAlertController(title: "Unable to get data ", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        
        return cell
    }
    
    
    
    //MARK: - Searching
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard searchBar.text != "" else {
            showAlert(title: "Unable perform search", message: "Enter city name,country")
            return
        }
        
        searchCity(searchString: searchBar.text!)
        searchBar.text = ""
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchCity(searchString: String) {
        DispatchQueue.global(qos: .userInitiated).sync {
            ActiveCitiesListTVC.weatherManager.fetchCurrentWeatherWithSearch(searchString: searchString) { (result) in
                
                switch result {
                case .Success(let currentWeather):
                    /*
                     if currentWeather.code == 404 {
                     
                     DispatchQueue.main.async {
                     self.showAlert(title: "City not found", message: "Check the entered data correction")
                     }
                     
                     } else {
                     
                     }
                     */
                    
                    
                    //Saving new city to DB
                    DispatchQueue.global(qos: .userInteractive).sync {
                        
                        let newCity = Cities(name: currentWeather.city, country: currentWeather.country, id: currentWeather.id)
                        
                        StorageManager.saveObject(newCity)
                        self.citiesList.isEmpty ? self.citiesList.insert(newCity, at: 0) : self.citiesList.insert(newCity, at: 1)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case .Failure(let error as NSError):
                    
                    let alertController = UIAlertController(title: "Unable to get data ", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    //MARK: - Updating UI
    
    func setupSearchBar() {
        searchBar.showsCancelButton = true
        searchBar.delegate = self
    }
    
    
    //MARK: - Autorefreshing
    
    func setupTimer() {
        refreshTimer = Timer(timeInterval: 60*60, target: self, selector: #selector(refreshEveryHour), userInfo: nil, repeats: true)
        RunLoop.main.add(refreshTimer, forMode: .default)
    }
    
    @objc func refreshEveryHour() {
        resetTimer()
        tableView.reloadData()
    }
    
    func resetTimer() {
        refreshTimer.invalidate()
        refreshTimer = nil
        setupTimer()
    }
    
    //MARK: - Fetching Data
    
    //TODO Activity inicator on downloading
    /*
     func toggleActivityIndicator(active: Bool) {
     refreshBtn.isEnabled = active
     if active {
     activityIndicator.startAnimating()
     } else {
     activityIndicator.stopAnimating()
     }
     }
     */
    
    
    func getCurrentWeatherData(coordinates: Coordinates) {
        
        DispatchQueue.global(qos: .userInitiated).sync {
            ActiveCitiesListTVC.weatherManager.fetchCurrentWeatherWithCoordinates(coordinates: coordinates) { (result) in
                
                switch result {
                case .Success(let currentWeather):
                    
                    self.citiesList.insert(Cities(name: currentWeather.city, country: currentWeather.country, id: currentWeather.id), at: 0)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case .Failure(let error as NSError):
                    
                    let alertController = UIAlertController(title: "Unable to get data ", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //BUG! FOR SOME REASON INDEXPATH HAS 2 VALUES
        
        DispatchQueue.global().sync {
            ActiveCitiesListTVC.sharedId = self.citiesList[indexPath[1]].id
            self.performSegue(withIdentifier: "detailSegue", sender: nil)
        }
        
        self.performSegue(withIdentifier: "detailSegue", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - UserLocation
    
    private let locationManager = CLLocationManager()
    
    private func getLocation() -> Coordinates {
        
        if let location = locationManager.location?.coordinate {
            return Coordinates(latitude: location.latitude, longitude: location.longitude)
        } else {
            showAlert(title: "Your location is not available",
                      message: "To give permission go to: Settings -> WeatherApp -> Location and restart the app")
            return Coordinates(latitude: 0, longitude: 0)
        }
    }
    
    private func checkLocationServices () {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            checkLocationAuthorization()
            
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.showAlert(title: "Your location is not available",
                               message: "To give permission go to: Settings -> WeatherApp -> Location and restart the app")
            }
        }
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            break
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Your location is not available",
                               message: "To give permission go to: Settings -> WeatherApp -> Location and restart the app")
            }
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Your location is not available",
                               message: "To give permission go to: Settings -> WeatherApp -> Location and restart the app")
            }
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("New case is available")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: "Your location is not available",
                                      message: "To give permission go to: Settings -> WeatherApp -> Location and restart the app",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    
}
