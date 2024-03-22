//
//  UITableViewCell+Register.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 04.03.2024.
//

import Foundation
import UIKit

extension UITableView {
	
	func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
		register(cellClass, forCellReuseIdentifier: cellClass.reuseID)
	}
	
	func dequeueReusableCell<Cell: UITableViewCell>(forIndexPath indexPath: IndexPath) -> Cell {
		
		guard let cell = self.dequeueReusableCell(withIdentifier: Cell.reuseID, for: indexPath)
						as? Cell else {
			fatalError("Fatal error for cell at \(indexPath))")
		}
		return cell
	}
}
