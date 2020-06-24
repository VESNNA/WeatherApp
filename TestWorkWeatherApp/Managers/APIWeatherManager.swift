//
//  APIWeatherManager.swift
//  TestWorkWeatherApp
//
//  Created by Nikita Vesna on 22.06.2020.
//  Copyright © 2020 Nikita Vesna. All rights reserved.
//

import Foundation

//struct Coordinates {
//    let latitude: Double
//    let longitude: Double
//}

enum ForecastType: FinalURLPoint  {
    
    case Search(apiKey: String, searchString: String)
    case Current(apiKey: String, coordinates: Coordinates)
    case ByID(apiKey: String, id: Int)
    case Forecast(apiKey: String, id: Int)
    
    
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org")!
    }
    
    var path: String {
        switch self {
        case .Current(let apiKey, let coordinates):
            return "/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(apiKey)&units=metric"
        case .ByID(let apiKey, let id):
            return "/data/2.5/weather?id=\(id)&appid=\(apiKey)&units=metric"
        case .Search(let apiKey, let searchString):
            return "/data/2.5/weather?q=\(searchString)&appid=\(apiKey)&units=metric"
        case .Forecast(let apiKey, let id):
            return "/data/2.5/forecast?id=\(id)&appid=\(apiKey)&units=metric"
            
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
}

final class APIWeatherManager: APIManager {
    
    let sessionConfiguration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    } ()
    
    let apiKey : String
    
    init(sessionConfiguration: URLSessionConfiguration, apiKey: String) {
        self.sessionConfiguration = sessionConfiguration
        self.apiKey = apiKey
    }
    
    convenience init(apiKey: String) {
        self.init(sessionConfiguration: URLSessionConfiguration.default, apiKey: apiKey)
    }
    
    func fetchCurrentWeatherWithCoordinates(coordinates: Coordinates, completionHandler: @escaping (APIResult<SearchWeather>) -> Void) {
        let request = ForecastType.Current(apiKey: self.apiKey, coordinates: coordinates).request
        
        fetch(request: request, parse: { (json) -> SearchWeather? in
            let dictionary:[String: AnyObject] = json
            return SearchWeather(JSON: dictionary)
            
        }, completionHandler: completionHandler)
    }
    
    func fetchCurrentWeatherWithSearch(searchString: String, completionHandler: @escaping (APIResult<SearchWeather>) -> Void) {
        let request = ForecastType.Search(apiKey: apiKey, searchString: searchString).request
        
        fetch(request: request, parse: { (json) -> SearchWeather? in
            let dictionary:[String: AnyObject] = json
            return SearchWeather(JSON: dictionary)
            
        }, completionHandler: completionHandler)
    }
    
    
    func fetchCompactWeatherWithID(id: Int, completionHandler: @escaping (APIResult<CompactWeather>) -> Void) {
        let request = ForecastType.ByID(apiKey: self.apiKey, id: id).request
        
        fetch(request: request, parse: { (json) -> CompactWeather? in
            let dictionary:[String: AnyObject] = json
            return CompactWeather(JSON: dictionary)
            
        }, completionHandler: completionHandler)
    }
    
    func fetchCurrentWeatherForecast(id: Int, completionHandler: @escaping (APIResult<ForecastWeather>) -> Void) {
        let request = ForecastType.Forecast(apiKey: self.apiKey, id: id).request
        
        fetch(request: request, parse: { (json) -> ForecastWeather? in
            let dictionary:[String: AnyObject] = json
            return ForecastWeather(JSON: dictionary)
            
        }, completionHandler: completionHandler)
    }
    
}

