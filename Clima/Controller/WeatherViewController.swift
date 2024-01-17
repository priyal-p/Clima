//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    lazy var weatherManager = WeatherManager(delegate: self)
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        searchTextField.delegate = self
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        updateWeatherData(for: textField.text)
        textField.text = nil
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let isEmpty = textField.text?.isEmpty ?? false
        if isEmpty {
            textField.placeholder = "Enter city name"
        }
        return !isEmpty
    }
}

private extension WeatherViewController {
    func updateWeatherData(for cityName: String?) {
        guard let cityName else { return }
        weatherManager.fetchWeather(cityName: cityName)
    }
}

//MARK: WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeatherData(_ weatherDataResult: WeatherAPIResult) {
        switch weatherDataResult {
        case .success(let weatherData):
            DispatchQueue.main.async {
                self.cityLabel.text = weatherData.cityName
                self.temperatureLabel.text = String(weatherData.temperatureString)
                self.conditionImageView.image = UIImage(systemName: weatherData.icon)
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

//MARK: CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            print("Found users's location: \(location)")
            weatherManager.fetchWeather(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude))
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
