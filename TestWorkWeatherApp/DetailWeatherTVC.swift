//
//  DetailWeatherTVC.swift
//  TestWorkWeatherApp
//
//  Created by Nikita Vesna on 23.06.2020.
//  Copyright © 2020 Nikita Vesna. All rights reserved.
//

import UIKit

class DetailWeatherTVC: UITableViewController {
    
    var forecast: ForecastWeather!

    //Current weather section
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var pressureLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    
    //5-day forecast section
    @IBOutlet weak var date1Lbl: UILabel!
    @IBOutlet weak var forecast1Lbl: UILabel!
    @IBOutlet weak var date2Lbl: UILabel!
    @IBOutlet weak var forecast2Lbl: UILabel!
    @IBOutlet weak var date3Lbl: UILabel!
    @IBOutlet weak var forecast3Lbl: UILabel!
    @IBOutlet weak var date4Lbl: UILabel!
    @IBOutlet weak var forecast4Lbl: UILabel!
    @IBOutlet weak var date5Lbl: UILabel!
    @IBOutlet weak var forecast5Lbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DispatchQueue.global(qos: .userInitiated).sync {
            getForecast(id: ActiveCitiesListTVC.sharedId)
        }
        
    }
    
    func updateUI(forecast: ForecastWeather) {
        
        locationLbl.text = forecast.locationString
        tempLbl.text = "\(String(forecast.forecastData[0].temperature))˚C"
        pressureLbl.text = "\(String(forecast.pressure))mm"
        humidityLbl.text = "\(String(forecast.humidity))%"
        
        forecast1Lbl.text = String(forecast.forecastData[0].temperature)
        forecast2Lbl.text = String(forecast.forecastData[1].temperature)
        forecast3Lbl.text = String(forecast.forecastData[2].temperature)
        forecast4Lbl.text = String(forecast.forecastData[3].temperature)
        forecast5Lbl.text = String(forecast.forecastData[4].temperature)
        
        date1Lbl.text = forecast.forecastData[0].date
        date2Lbl.text = forecast.forecastData[1].date
        date3Lbl.text = forecast.forecastData[2].date
        date4Lbl.text = forecast.forecastData[3].date
        date5Lbl.text = forecast.forecastData[4].date
        
        
    }

    func getForecast(id: Int) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            ActiveCitiesListTVC.weatherManager.fetchCurrentWeatherForecast(id: id) { (result) in
                
                switch result {
                case .Success(let currentWeather):
                    
                    self.updateUI(forecast: currentWeather)
                    
                case .Failure(let error as NSError):
                    
                    let alertController = UIAlertController(title: "Unable to get data ", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK: - Navigation
    
    @IBAction func backToList(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
