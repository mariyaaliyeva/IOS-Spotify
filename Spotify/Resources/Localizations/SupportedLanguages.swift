//
//  SupportedLanguages.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 15.03.2024.
//

import Foundation

enum SupportedLanguages: String {
	case ru
	case en
	
	static var all: [SupportedLanguages] {
		return [.ru, .en]
	}
	
	var localizedTitle: String {
		switch self {
		case .ru:
			return "Русский"
		case .en:
			return "English"
		}
	}
}
