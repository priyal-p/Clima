//
//  Data+Extension.swift
//  Clima
//
//  Created by Priyal PORWAL on 15/01/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
extension Data {
    func prettyPrinted() -> String {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: [])
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            guard let jsonString = String(data: data, encoding: .utf8) else {
                debugPrint("Inavlid data")
                return ""
            }
            return jsonString
        } catch {
            debugPrint("Error: \(error.localizedDescription)")
        }
        return ""
    }
}
