//
//  String+Extensions.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 11.03.2024.
//

import Foundation

extension String {
	var localized: String {
		guard let localizedBundle = Bundle.localizedBundle() else { return "" }
		return NSLocalizedString(
			self,
			bundle: localizedBundle,
			comment: "\(self) could not be found in Localizable.strings"
		)
	}
}

