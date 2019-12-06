//
//  WeatherManager.swift
//  Clima
//
//  Created by FGT MAC on 12/5/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation

//Struct for API calls to the openweather api
struct WeatherManager {
    //The queries to the api order does not metter
    
    //URL make sure to use https secure
    let weatherURL =  "https://api.openweathermap.org/data/2.5/weather?appid=edee7c3774cea803358c17ed3bf36159"
    
    func fetchWeather(cityName: String){
        //using string interpolation to complete the query using the city the
        //user passes
        let unitType = "units=imperial"
        
        let urlString = "\(weatherURL)&q=\(cityName)&\(unitType)"
        
        //Call the performRequest method
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        //1.Create url Object
        //Here we are using a URL build in method set to an option string
        //and we unwrap using a if  statement
        if let url = URL(string: urlString) {
            
            //2.Create URLSession object
            let session = URLSession(configuration: .default)
            
            //3.Give the session a task to retrive data using the following method with a trailing Closure
            let task = session.dataTask(with: url) { (data, response, error) in
                //IF there is an error print it and return to terminate process
                if error != nil{
                    print("error")
                    return
                }
                
                if let safeData = data {
                    //if we call a method of the current class insde a closure we must use self
                    self.parseJSON(weatherData: safeData)
                }
            }
            //4.Start the task, is call resume because
            //always start in a suspended state so resume to start
            task.resume()
        }
    }
    //creating a method to parse the JSON coming from API to swift
    func parseJSON(weatherData: Data){
        //initializing the decoder
        let decoder = JSONDecoder()
        //creating decode passing the WeatherData struct
        //and the weatherData coming from API
        do{
           let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.main.temp)
            print(decodedData.weather[0].description)
        }catch{
            print(error)
        }
    }
}
