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
    let image: String
}

//List of most common languages people actually learn
let popularLanguages: [(code: String, name: String, image: String)] = [
    ("en", "English", "us-United-States-of-America"),
    ("es", "Spanish", "es-Spain"),
    ("fr", "French", "fr-France"),
    ("de", "German", "de-Germany"),
    ("it", "Italian", "it-Italy"),
    ("ja", "Japanese", "jp-Japan"),
    ("ko", "Korean", "kr-South-Korea"),
    ("zh", "Mandarin", "cn-China"),
    ("pt", "Portuguese", "pt-Portugal"),
    ("ru", "Russian", "ru-Russia"),
    ("hi", "Hindi", "in-India"),
    ("ar", "Arabic", "sa-Saudi-Arabia"),
    ("nl", "Dutch", "nl-Netherlands"),
    ("sv", "Swedish", "se-Sweden"),
    ("tr", "Turkish", "tr-Turkey"),
    ("pl", "Polish", "pl-Poland"),
    ("he", "Hebrew", "il-Israel"),
    ("el", "Greek", "gr-Greece"),
    ("th", "Thai", "th-Thailand"),
    ("vi", "Vietnamese", "vn-Vietnam"),
    ("id", "Indonesian", "id-Indonesia")
]
