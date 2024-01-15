//
//  WeatherManager.swift
//  Clima
//
//  Created by Priyal PORWAL on 15/01/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric"
    // q=London&

    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(urlString: urlString)
    }

    func performRequest(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)

        let task = session.dataTask(with: url) { data, response, error in
            if let error {
                printAPIResponse(data: nil, error: error)
                return
            }
            if let safeData = data {
                printAPIResponse(data: safeData, error: nil)
            }
        }

        task.resume()
    }

    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if let error {
            printAPIResponse(data: nil, error: error)
            return
        }
        if let safeData = data {
            printAPIResponse(data: safeData, error: nil)
        }
    }

    func printAPIResponse(data: Data?, error: Error?) {
        debugPrint("*********Response************")
        if let data {
            debugPrint("Response Data:")
            let responseData = String(data: data, encoding: .utf8)
            debugPrint(responseData)
        } else if let error {
            debugPrint("Response Error:")
            debugPrint(error)
        }
        debugPrint("*********Response************")
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
}
