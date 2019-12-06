//
//  WeatherData.swift
//  Clima
//
//  Created by FGT MAC on 12/6/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation

//We must add the Codable Protocol to the struct to decode and
//encode the JSON responce Codable = Decodable & Encodable
struct WeatherData: Codable {
    //the property names MUST match the names key names
    //coming from the API JSON tree
    let name: String
    let main: Main
    //Since the weather property holds an array of objects so we use type []
    let weather: [Weather]
}

//Because the JSON response has a subsection called main
//we must create another struct to represent it
struct Main: Codable {
    let temp: Double
}

//Accessing an array within the weather
struct Weather: Codable {
    let id: Int
}
