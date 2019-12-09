//
//  WeatherModel.swift
//  Clima
//
//  Created by FGT MAC on 12/6/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    //Store properties
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    //Computed property to convert Int to String
    var temperatureString: String{
        return String(format: "%.1f", temperature)
    }
    
    //Computed property
    var conditionName: String {
        //Creating switch base on code return by api
        // https://openweathermap.org/weather-conditions
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...803:
            return "cloud.sun"
        default:
            return "cloud"
        }
    }
}

