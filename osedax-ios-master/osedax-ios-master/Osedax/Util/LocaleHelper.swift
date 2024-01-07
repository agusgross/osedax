//
//  LocaleHelper.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/15/21.
//

import Foundation

struct LocaleHelper {
    
    static func getLocale() -> String {
        
        
//        let locale = Locale.preferredLanguages.first ?? "en"
//
//        if locale.count < 2 {
//            return "en"
//        }
//
//        if locale[locale.startIndex...locale.index(locale.startIndex, offsetBy: 2)] == "es" && (locale.count < 5 || locale[locale.index(locale.startIndex, offsetBy: 3)...locale.index(locale.startIndex, offsetBy: 5)] != "AR") {
//            return "es"
//        }
//
//        if locale != "en" && locale != "es-AR" {
//            return "en"
//        }
//
//        return locale
        
        return Locale.current.languageCode ?? "en"
        
    }
    
}
