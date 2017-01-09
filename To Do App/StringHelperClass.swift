//
//  StringFormatitng.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 26/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

public class StringHelperClass {

    class func removeSpecialCharsFromString (text: String) -> String {
        let acceptableChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ".characters)
        
        let stringWithRemovedSpaces = text.stringByReplacingOccurrencesOfString(" ", withString: "-")
        
        let stringWithoutLocalizedSigns = stringWithRemovedSpaces.stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale())
        
        let stringWithoutSpecialSigns = String(stringWithoutLocalizedSigns.characters.filter {acceptableChars.contains($0)})
        
        if !(stringWithoutSpecialSigns.isEmpty) {
            return stringWithoutSpecialSigns
        }
        // when returned sign is #, app will tell return "There's no data for such City" alert
        return "#"        
    }
    
    class func validateCityNameFromUser(withTextField textField: UITextField) -> StringValidation {
        
        if let city = textField.text {
            if !city.isEmpty {
                if city.characters.count <= 15 {
                    let formatedCityName = removeSpecialCharsFromString(city)
                    userCityName = formatedCityName
                    return .isValid
                } else {
                    return .isToLong
                }
            } else {
                return .isEmpty
            }
        } else {
            return .isEmpty
        }
    }
}