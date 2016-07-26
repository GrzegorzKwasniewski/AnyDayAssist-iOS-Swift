//
//  StringFormatitng.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 26/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import Foundation

public class StringFormatting {

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
}