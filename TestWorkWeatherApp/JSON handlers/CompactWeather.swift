//
//  CompactWeather.swift
//  TestWorkWeatherApp
//
//  Created by Nikita Vesna on 24.06.2020.
//  Copyright © 2020 Nikita Vesna. All rights reserved.
//

import Foundation

struct CompactWeather {
    let temperature: Double
    let id: Int
}

extension CompactWeather: JSONDecodable {
    init?(JSON: [String: AnyObject]) {
        
        guard let main = JSON["main"] as? NSDictionary,
            let temperature = main["temp"] as? Double,
            let id = JSON["id"] as? Int
            
            else {
                print("JSON proceccing error")
                return nil
        }
        
        self.temperature = temperature
        self.id = id
    }
}

extension CompactWeather {
    
    var temperatureString: String {
        return "\(Int(temperature))˚C"
    }
}
