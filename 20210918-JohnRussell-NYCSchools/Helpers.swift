//
//  Helpers.swift
//  WeatherDisplay
//
//  Created by john Russell on 4/22/21.
//

import Foundation



enum UserDefaultsKeys
{
    static let savedData = "SaveData_key"
}

class Helper
{
    static func callNumber(phoneNumber: String) {
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

}


