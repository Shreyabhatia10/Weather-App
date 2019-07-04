//
//  CurrentWeatherViewController.swift
//  Weather App
//
//  Created by Shreya Bhatia on 03/07/19.
//  Copyright © 2019 Shreya Bhatia. All rights reserved.
//

import Foundation
import UIKit


class CurrentWeatherViewController: UIViewController {
    
    var weather: CurrentWeather!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var temperatureUnit: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var timeZone: UILabel!
    @IBOutlet weak var humidity: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.didLoadDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    fileprivate func didLoadDetails() {
        self.summary.text = self.weather.summary
        self.temperature.text = "\(self.weather.temperature!)"
        self.temperatureUnit.text = "Fehranite"
        self.timeZone.text = self.weather.timezone
        self.humidity.text = "Humidity: \(self.weather.humidity!)"
    }
}

