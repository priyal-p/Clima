//
//  WeatherModel.swift
//  Clima
//
//  Created by Priyal PORWAL on 16/01/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double

    var temperatureString: String {
        return String(format: "%.1f", temperature.round(to: 1))
    }

    var icon: String {
        switch conditionId {
        case 200...232: // Thunderstorm
            return "cloud.bolt"
//            if #available(iOS 13.0, *) {
//                if UITraitCollection.current.userInterfaceStyle == .dark {
//                    return "cloud.moon.bolt"
//                }
//                else {
//                    print("cloud.sun.bolt")
//                }
//            }
        case 300...321: // Drizzle
            return "cloud.drizzle"
        case 500...531: // Rain
            return "cloud.rain"
        case 600...622: // Snow
            return "cloud.snow"
        case 701: // Mist
            return "cloud.fog"
        case 711: // Smoke
            return "smoke.fill"
        case 721: // Haze
            return "sun.haze"
        case 731: // Dust
            return "sun.dust"
        case 741: // Fog
            return "cloud.fog"
        case 751: // Sand
            return "sun.dust"
        case 761: // Dust
            return "sun.dust"
        case 762: // Ash
            return "sun.dust"
        case 771: // Squall
            return "wind.snow"
        case 781: // Tornado
            return "tornado"
        case 800: // CLear
            return "sun.max"
        case 801...804: // Clouds
            return "cloud"
        default:
            return "cloud"
        }
    }
}

extension Double {
    func round(to places: Int) -> Self {
        let precisionNumber = pow(Double(10), Double(places))
        var num = self * precisionNumber
        num.round()
        num = num / precisionNumber
        return num
    }
}
