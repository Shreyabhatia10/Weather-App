//
//  LoginViewController.swift
//  Weather App
//
//  Created by Shreya Bhatia on 03/07/19.
//  Copyright © 2019 Shreya Bhatia. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class LoginViewController: UIViewController, CLLocationManagerDelegate {
    
    let forecastAPIKey = "e4de2fb428a668e314ba0d8833957863"
    var weatherReport: CurrentWeather = CurrentWeather(json: [:])
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!

    func askForLocationPermission() {
        //ASK for permission
//        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        self.latitude.text = String(locationValue.latitude)
        self.longitude.text = String(locationValue.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.loadAlertViewController(title: "Details not Found!", message: error.localizedDescription)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        self.longitude.text = ""
        self.latitude.text = ""
        self.longitude.delegate = self
        self.latitude.delegate = self
        askForLocationPermission()
    }
    
    //MARK:- IBActions
    @IBAction func didTapToCheck(_ sender: Any) {
        
        if (!(latitude.text?.isEmpty)!) || (!(longitude.text?.isEmpty)!) {
            self.fetchCurrentWeatherData()
        } else {
            self.loadAlertViewController(title: "Details not Found!", message: "Please, enter both latitude and longitude")
        }
    }
    
    func loadAlertViewController(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    fileprivate func fetchCurrentWeatherData() {
        let forecastService = ForecastAPIService(APIKey: forecastAPIKey)
        forecastService.getForecast(latitude: Double(latitude.text!)!, longitude: Double(longitude.text!)!) { (currentWeather) in
            if let currentWeather = currentWeather {
                DispatchQueue.main.sync {
                    self.weatherReport = currentWeather
                    self.performSegue(withIdentifier: "loadDetailsViewController", sender: self)
                }
            } else {
                DispatchQueue.main.sync {
                    self.loadAlertViewController(title: "Details not Found!", message: "Please, enter correct latitude and longitude")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let currentWeatherViewController = segue.destination as? CurrentWeatherViewController {
            currentWeatherViewController.weather = weatherReport
        }
    }
    
}

//MARK:- Text Field Delegate
extension LoginViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string.isEmpty { return true }
        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // only has the specified amount of decimal places.
        return replacementText.isValidDouble(maxDecimalPlaces: 4) || replacementText.beginsWithNegativeSign()
    }

}

//MARK:- Extension for string
extension String {
    func isValidDouble(maxDecimalPlaces: Int) -> Bool {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true // Default is true, be explicit anyways
        let decimalSeparator = formatter.decimalSeparator ?? "."
        if formatter.number(from: self) != nil {
            let split = self.components(separatedBy: decimalSeparator)
            let digits = split.count == 2 ? split.last ?? "" : ""

            // Finally check if we're <= the allowed digits
            return digits.characters.count <= maxDecimalPlaces
        }

        return false // couldn't turn string into a valid number
    }
    
    func beginsWithNegativeSign() -> Bool {
        var negativeSign = false
        if self.first == "-" {
            negativeSign = true
        }
        let remainingString = self.dropFirst()
        if remainingString.contains("-") {
            negativeSign = false
        }
        return negativeSign
    }
    
}


