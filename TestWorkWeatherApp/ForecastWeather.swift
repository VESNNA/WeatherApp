//
//  ForecastWeather.swift
//  TestWorkWeatherApp
//
//  Created by Nikita Vesna on 24.06.2020.
//  Copyright © 2020 Nikita Vesna. All rights reserved.
//

import Foundation

struct ForecastWeather {
    
    /*
    let feelsLike: Double
    let humidity: Double
    let pressure: Double
    let description: String
    */
    
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
            //var forecastData = ForecastData(),
            
            //Day 1
            let day1 = list[0] as? NSDictionary,
            let main = day1["main"] as? NSDictionary,
            let temperature = main["temp"] as? Double,
            let date = day1["dt_txt"] as? String,
            
            let forecastData: [ForecastData] = [ForecastData(temperature: temperature, date: date)]
            
            /*
            //Day2
            let day2 = list[index+modifier] as? NSDictionary,
            let main = day2["main"] as? NSDictionary,
            let temperature = main["temp"] as? Double,
            let forecastDate = day2["dt_txt"] as? String,
            
            //Day3
            let day3 = list[index+2*modifier] as? NSDictionary,
            let main = day3["main"] as? NSDictionary,
            let temperature = main["temp"] as? Double,
            let forecastDate = day3["dt_txt"] as? String,
            //Day4
            let day4 = list[index+3*modifier] as? NSDictionary,
            let main = day4["main"] as? NSDictionary,
            let temperature = main["temp"] as? Double,
            let forecastDate = day4["dt_txt"] as? String,
            //Day5
            let day5 = list[index+4*modifier] as? NSDictionary,
            let main = day5["main"] as? NSDictionary,
            let temperature = main["temp"] as? Double,
            let forecastDate = day5["dt_txt"] as? String,
            */
        
        
        else {
            print("JSON proceccing error")
            return nil
        }
        
        
        self.id = id
        self.city = city
        self.country = country
        
        self.forecastData = forecastData
        
        /*
         self.temperature = temperature
         self.feelsLike = feelsLike
         self.humidity = humidity
         self.pressure = pressure
         self.city = city
         self.id = id
         self.country = country
         */
        
        
    }
}

