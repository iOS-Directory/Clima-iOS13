//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

//1. For location / gps
import CoreLocation

//Instead of including the Protocols here
//Two separate extensions were created to handle those methods
class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    //initializing the WeatherManager struct to make the api call
    var weatherManager = WeatherManager()
    
    //2.Creeating instance of location
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //3.Set its self as delegate for location
        //You must set this before the request for permission and location
        locationManager.delegate = self
        
        //4.Requesting permmision from user to use their location
        locationManager.requestWhenInUseAuthorization()
        
        //5.After adding property to plist
        //This will get the location and since is in the viewDidLoad()
        //it will happen when the app launches
        //if you would need constant location update use:
        // locationManager.startUpdatingLocation()
        locationManager.requestLocation()
        
        
        
        //For the custom Protocol we must this class to delegate
        weatherManager.delegate = self
        
        // Do any additional setup after loading the view.
        //setting the searchTextField.delegate to this class
        searchTextField.delegate = self
    }
    

}


//By using the mark: - keyword we can devide the code as shown below

//MARK: - UITextFieldDelegate

//1.Created extension to move methods and organized code
//So we extended the WeatherViewController class to include
//the UITextFieldDelegate and its methods
extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        //this will dismiss the keyboard after pressing search
        searchTextField.endEditing(true)
    }
    
    //This will trigger theresponse when pressing the retirn button
    //on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //this will dismiss the keyboard after pressing search
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    //This is useful to prevent the user for searching if the field is empty
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            textField.placeholder = "Search"
            return true
        }else{
            textField.placeholder = "Field cannot be blank"
            return false
        }
    }
    
    //This will trigger an action after we press search
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Use the searchTextField.text to get the weather for that city
        //before reset to empty string
        //using and if let to unwrap the text only if it exist
        if let city = searchTextField.text {
            //now if there is a value we pass it to the WeatherManager
            //method to do the api call
            weatherManager.fetchWeather(cityName: city)
        }
        
        //here we clear the text field after pressign search
        searchTextField.text = ""
    }
}


//By using the mark: - keyword we can devide the code as shown below

//MARK: - WeatherManagerDelegate




//2.Created extension to move methods and organized code
//So we extended the WeatherViewController class to include
//the WeatherManagerDelegate and its methods
extension WeatherViewController: WeatherManagerDelegate{
    //Declaring the protocol method using inplicit parameter
    func didUpdateWeather(_ weatherManager: WeatherManager , weather: WeatherModel) {
        //Since this is a networking call we must wrap the ui update
        //to DispatchQueue.main.async
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            //Getting the switch result to set the condition image
            //the systemName expects a name that matches the SF Symbole
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

//Creating an extension of WeatherViewController
//To include CLLocationManagerDelegate
//to get location
extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationButton(_ sender: UIButton) {
        
        //Requesting the location when pressing the button
          locationManager.requestLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Here we access the array of locations being return by didUpdateLocations
        //and access the last location in the array locations.last which is an optional
        if let location = locations.last {
            //Stop requesting the location if one has been set
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
//            print(lat)
//            print(lon)
            weatherManager.fetchWeather(latitude: lat, longitud:lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error", error )
    }
}
