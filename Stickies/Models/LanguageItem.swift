//
//  Language.swift
//  Stickies
//
//  Created by Chris W on 10/28/25.
//

import Foundation

//For displaying in the AddLanguageView
struct LanguageItem: Identifiable {
    let id = UUID()
    let code: String
    let name: String
    let flag: String
}

//List of most common languages people actually learn
let popularLanguages: [(code: String, name: String, flag: String)] = [
    ("en", "English", "🇺🇸"),
    ("es", "Spanish", "🇪🇸"),
    ("fr", "French", "🇫🇷"),
    ("de", "German", "🇩🇪"),
    ("it", "Italian", "🇮🇹"),
    ("ja", "Japanese", "🇯🇵"),
    ("ko", "Korean", "🇰🇷"),
    ("zh", "Chinese", "🇨🇳"),
    ("pt", "Portuguese", "🇵🇹"),
    ("ru", "Russian", "🇷🇺"),
    ("hi", "Hindi", "🇮🇳"),
    ("ar", "Arabic", "🇸🇦"),
    ("nl", "Dutch", "🇳🇱"),
    ("sv", "Swedish", "🇸🇪"),
    ("tr", "Turkish", "🇹🇷"),
    ("pl", "Polish", "🇵🇱"),
    ("he", "Hebrew", "🇮🇱"),
    ("el", "Greek", "🇬🇷"),
    ("th", "Thai", "🇹🇭"),
    ("vi", "Vietnamese", "🇻🇳")
]
