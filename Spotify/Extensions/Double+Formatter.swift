//
//  Double+Formatter.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 18.03.2024.
//

import Foundation

extension Double {
	func asString(style: DateComponentsFormatter.UnitsStyle) -> String {

		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
		formatter.unitsStyle = style
		return formatter.string(from: self / 1000) ?? ""
	}
}
