//
//  CurrentWeather.swift
//  TestWorkWeatherApp
//
//  Created by Nikita Vesna on 24.06.2020.
//  Copyright © 2020 Nikita Vesna. All rights reserved.
//

import Foundation

struct SearchWeather {
    let temperature: Double
    let id: Int
    let city: String
    let country: String
}

extension SearchWeather: JSONDecodable {
    init?(JSON: [String: AnyObject]) {
        
        guard let main = JSON["main"] as? NSDictionary,
            let temperature = main["temp"] as? Double,
            
            let city = JSON["name"] as? String,
            let id = JSON["id"] as? Int,
            
            let sys = JSON["sys"] as? NSDictionary,
            let country = sys["country"] as? String
            
            else {
                print("JSON proceccing error")
                return nil
        }
        
        self.temperature = temperature
        self.city = city
        self.id = id
        self.country = country
    }
}

extension SearchWeather {
   
    var temperatureString: String {
        return "\(Int(temperature))˚C"
    }
    
}
