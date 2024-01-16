//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
}

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

extension WeatherViewController {
    func updateWeatherData(for cityName: String?) {
        guard let cityName else { return }
        print(cityName)
        weatherManager.fetchWeather(cityName: cityName) {[weak self] result in
            guard let self else { return }
            switch result {
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
}
