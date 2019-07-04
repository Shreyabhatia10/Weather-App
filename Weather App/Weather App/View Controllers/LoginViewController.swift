//
//  LoginViewController.swift
//  Weather App
//
//  Created by Shreya Bhatia on 03/07/19.
//  Copyright © 2019 Shreya Bhatia. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    let forecastAPIKey = "e4de2fb428a668e314ba0d8833957863"
    var weatherReport: CurrentWeather = CurrentWeather(json: [:])
    
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        self.longitude.text = ""
        self.latitude.text = ""
        self.longitude.delegate = self
        self.latitude.delegate = self
    }
    
    //MARK:- IBActions
    @IBAction func didTapToCheck(_ sender: Any) {
        let forecastService = ForecastAPIService(APIKey: forecastAPIKey)
        if (!(latitude.text?.isEmpty)!) || (!(longitude.text?.isEmpty)!) {
            forecastService.getForecast(latitude: Double(latitude.text!)!, longitude: Double(longitude.text!)!) { (currentWeather) in
                if let currentWeather = currentWeather {
                    DispatchQueue.main.sync {
                        self.weatherReport = currentWeather
                        self.performSegue(withIdentifier: "loadDetailsViewController", sender: self)
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Details not Found!", message: "Please, enter both latitude and longitude", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
        return replacementText.isValidDouble(maxDecimalPlaces: 4)
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
}

