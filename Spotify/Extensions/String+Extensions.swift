//
//  String+Extensions.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 11.03.2024.
//

import Foundation

extension String {
		var localized: String {
				NSLocalizedString(
						self,
						comment: "\(self) could not be found in Localizable.strings"
				)
		}
}
