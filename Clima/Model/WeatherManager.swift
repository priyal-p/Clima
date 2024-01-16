//
//  WeatherManager.swift
//  Clima
//
//  Created by Priyal PORWAL on 15/01/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

class WeatherManager {
    typealias WeatherAPIResult = Result<WeatherModel, Error>
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric"
    // q=London&

    func fetchWeather(cityName: String,
                      completion: @escaping ( WeatherAPIResult) -> Void) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(urlString: urlString, 
                       completion: completion)
    }

    func performRequest(urlString: String,
                        completion: @escaping ( WeatherAPIResult) -> Void) {
        guard let url = URL(string: urlString) else { return }

        let session = URLSession(configuration: .default)

        let task = session.dataTask(with: url) {[weak self] data, response, error in
            guard let self else { return }
            if let error {
                printAPIResponse(data: nil, error: error, completion: completion)
                return
            }
            if let safeData = data {
                printAPIResponse(data: safeData, error: nil, completion: completion)
            }
        }

        task.resume()
    }

    func printAPIResponse(
        data: Data?,
        error: Error?,
        completion: ((
            WeatherAPIResult
        ) -> Void)?) {
            if let data {
                debugPrint("*********Response************")
                debugPrint("Response Data:")
                debugPrint(data.prettyPrinted())
                debugPrint("*********Response************")
                completion?(parseJSON(weatherData: data))
            } else if let error {
                debugPrint("*********Error************")
                debugPrint("Response Error:")
                debugPrint(error)
                debugPrint("*********Error************")
                completion?(.failure(error))
            }
        }

    func printAPIRequest(request: URLRequest?) {
        guard let request else { return }
        debugPrint("*********Request************")
        debugPrint("URL:", request.url?.absoluteURL)
        if let data = request.httpBody {
            debugPrint("HTTP Body:")
            let httpBody = String(data: data, encoding: .utf8)
            debugPrint(httpBody)
        }
        debugPrint("Headers:")
        debugPrint(request.allHTTPHeaderFields)
        debugPrint("*********Request************")
    }

    func parseJSON(weatherData: Data) -> WeatherAPIResult {
        do {
            let decodedJsonData = try JSONDecoder().decode(WeatherData.self, from: weatherData)
            print(decodedJsonData)
            let weatherModel = WeatherModel(
                conditionId: decodedJsonData.weather[0].id,
                cityName: decodedJsonData.name,
                temperature: decodedJsonData.main.temp
            )
            return .success(weatherModel)
        } catch {
            print(error)
            return .failure(error)
        }
    }
}
