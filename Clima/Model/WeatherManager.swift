//
//  WeatherManager.swift
//  Clima
//
//  Created by Priyal PORWAL on 15/01/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate: AnyObject {
    func didUpdateWeatherData(_ weatherDataResult: WeatherAPIResult)
}

typealias WeatherAPIResult = Result<WeatherModel, Error>

class WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric"
    // q=London&

    weak var delegate: WeatherManagerDelegate?

    init(delegate: WeatherManagerDelegate? = nil) {
        self.delegate = delegate
    }
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        debugPrint(urlString)
        performRequest(with: urlString)
    }

    func fetchWeather(latitude: String, longitude: String) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        debugPrint(urlString)
        performRequest(with: urlString)
    }

    func performRequest(with urlString: String) {
        guard let url = URL(string: urlString) else { return }

        let session = URLSession(configuration: .default)

        let task = session.dataTask(with: url) {[weak self] data, response, error in
            guard let self else { return }
            if let error {
                debugPrint("*********Error************")
                debugPrint("Response Error:")
                debugPrint(error)
                debugPrint("*********Error************")
                delegate?.didUpdateWeatherData(.failure(error))
                return
            }

            if let safeData = data {
                debugPrint("*********Response************")
                debugPrint("Response Data:")
                debugPrint(safeData.prettyPrinted())
                debugPrint("*********Response************")
                delegate?.didUpdateWeatherData(parseJSON(from: safeData))
            }
        }

        task.resume()
    }

    func printAPIRequest(request: URLRequest?) {
        guard let request else { return }
        debugPrint("*********Request************")
        debugPrint("URL:", request.url?.absoluteURL ?? "")
        if let data = request.httpBody {
            debugPrint("HTTP Body:")
            let httpBody = String(data: data, encoding: .utf8)
            debugPrint(httpBody ?? "")
        }
        debugPrint("Headers:")
        debugPrint(request.allHTTPHeaderFields ?? "")
        debugPrint("*********Request************")
    }

    func parseJSON(from weatherData: Data) -> WeatherAPIResult {
        do {
            let decodedJsonData = try JSONDecoder()
                .decode(WeatherData.self, from: weatherData)
            debugPrint(decodedJsonData)
            let weatherModel = WeatherModel(
                conditionId: decodedJsonData.weather[0].id,
                cityName: decodedJsonData.name,
                temperature: decodedJsonData.main.temp
            )
            return .success(weatherModel)
        } catch {
            return .failure(error)
        }
    }
}
