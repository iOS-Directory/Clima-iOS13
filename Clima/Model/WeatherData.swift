//
//  WeatherData.swift
//  Clima
//
//  Created by FGT MAC on 12/6/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation

//We must add the Decodable type to the struct
struct WeatherData: Decodable {
    //the property names MUST match the names key names
    //coming from the API JSON tree
    let name: String
    let main: Main
    let weather: [Weather]
}

//Because the JSON response has a subsection called main
//we must create another struct to represent it
struct Main: Decodable {
    let temp: Double
}

//Accessing an array within the object
struct Weather: Decodable {
    let description: String
}
