//
//  WeatherManager.swift
//  Clima
//
//  Created by FGT MAC on 12/5/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation


//creating a protocol
//As convention the protocol MUST be created in the same file
//That will use the protocol
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

//Struct for API calls to the openweather api
struct WeatherManager {
    //The queries to the api order does not metter
    
    //URL make sure to use https secure
    let weatherURL =  "https://api.openweathermap.org/data/2.5/weather?appid=edee7c3774cea803358c17ed3bf36159"
    
    //user could select a button to switch between F and C
    let unitType = "units=imperial"
    //Setting the delegate optional
    var delegate: WeatherManagerDelegate?
    
    //For user using location service / GPS
    //In SWIFT we can use the same func/method names as long as the paremeters are
    //different
    func fetchWeather(latitude: Double, longitud: Double){
        let urlString = "\(weatherURL)&\(unitType)&lat=\(latitude)&lon=\(longitud)"
        //Call the performRequest method
 
        performRequest(with: urlString)
    }
    
    //For user manually entering city name
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&\(unitType)&q=\(cityName)"
 
        //Call the performRequest method
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //1.Create url Object
        //Here we are using a URL build in method set to an option string
        //and we unwrap using a if  statement
        if let url = URL(string: urlString) {
//            print(url)
            //2.Create URLSession object
            let session = URLSession(configuration: .default)
            
            //3.Give the session a task to retrive data using the following method with a trailing Closure
            let task = session.dataTask(with: url) { (data, response, error) in
                //IF there is an error print it and return to terminate process
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    //if we call a method of the current class insde a closure we must use self
                    if let weather = self.parseJSON(safeData) {
                        
                        //implementing delegate to trigger action/func
                        self.delegate?.didUpdateWeather(self, weather:weather)
                    }
                }
                
            }
            //4.Start the task, is call resume because
            //always start in a suspended state so resume to start
            task.resume()
        }
    }
    //creating a method to parse the JSON coming from API to swift
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        //initializing the decoder
        let decoder = JSONDecoder()
        //creating decode passing the WeatherData struct
        //and the weatherData coming from API
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let temp = decodedData.main.temp
            let weatherID = decodedData.weather[0].id
            let name = decodedData.name
            //now passing the data to a struct instead of calling the func here
            //to make the code more organized
            let weather = WeatherModel(conditionId: weatherID, cityName: name, temperature: temp)
            return weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
