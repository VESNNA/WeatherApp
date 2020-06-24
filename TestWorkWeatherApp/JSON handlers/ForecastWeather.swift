//
//  ForecastWeather.swift
//  TestWorkWeatherApp
//
//  Created by Nikita Vesna on 24.06.2020.
//  Copyright © 2020 Nikita Vesna. All rights reserved.
//

import Foundation

struct ForecastWeather {
    
    let feelsLike: Double
    let humidity: Double
    let pressure: Double
    
    let id: Int
    let city: String
    let country: String
    
    
    let forecastData: [ForecastData]
    
}

struct ForecastData {
    let temperature: Double
    let date: String
}

extension ForecastWeather: JSONDecodable {
    init?(JSON: [String: AnyObject]) {
        
        
        guard let cityData = JSON["city"] as? NSDictionary,
            
            let id = cityData["id"] as? Int,
            let city = cityData["name"] as? String,
            let country = cityData["country"] as? String,
            
            
            
            let list = JSON["list"] as? NSArray,
            
            //TODO Refactor to cycles
            
            //Day 1
            let day1 = list[0] as? NSDictionary,
            let main1 = day1["main"] as? NSDictionary,
            let temperature1 = main1["temp"] as? Double,
            let date1 = day1["dt_txt"] as? String,
            let feelsLike = main1["feels_like"] as? Double,
            let humidity = main1["humidity"] as? Double,
            let pressure = main1["pressure"] as? Double,
            
            //Day2
            let day2 = list[8] as? NSDictionary,
            let main2 = day2["main"] as? NSDictionary,
            let temperature2 = main2["temp"] as? Double,
            let date2 = day2["dt_txt"] as? String,
            
            //Day3
            let day3 = list[16] as? NSDictionary,
            let main3 = day3["main"] as? NSDictionary,
            let temperature3 = main3["temp"] as? Double,
            let date3 = day3["dt_txt"] as? String,
            //Day4
            let day4 = list[24] as? NSDictionary,
            let main4 = day4["main"] as? NSDictionary,
            let temperature4 = main4["temp"] as? Double,
            let date4 = day4["dt_txt"] as? String,
            //Day5
            let day5 = list[32] as? NSDictionary,
            let main5 = day5["main"] as? NSDictionary,
            let temperature5 = main5["temp"] as? Double,
            let date5 = day5["dt_txt"] as? String,
            
            let forecastData: [ForecastData] = [ForecastData(temperature: temperature1, date: date1),
                                                ForecastData(temperature: temperature2, date: date2),
                                                ForecastData(temperature: temperature3, date: date3),
                                                ForecastData(temperature: temperature4, date: date4),
                                                ForecastData(temperature: temperature5, date: date5)]
            
            
            else {
                print("JSON proceccing error")
                return nil
        }
        
        
        self.id = id
        self.city = city
        self.country = country
        
        self.forecastData = forecastData
        
        self.feelsLike = feelsLike
        self.humidity = humidity
        self.pressure = pressure
        
    }
}

extension ForecastWeather {
    var locationString: String {
        return "\(city), \(country)"
    }
}

