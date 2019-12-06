//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    //initializing the WeatherManager struct to make the api call
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //For the custom Protocol we must this class to delegate
        weatherManager.delegate = self
        
        // Do any additional setup after loading the view.
        //setting the searchTextField.delegate to this class
        searchTextField.delegate = self
    }
    
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

