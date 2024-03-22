//
//  UITableViewCell+Reusable.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 04.03.2024.
//

import Foundation
import UIKit

protocol Reusable {}

extension UITableViewCell: Reusable {}

extension Reusable where Self: UITableViewCell {
	
	static var reuseID: String {
		return String(describing: self)
	}
}
