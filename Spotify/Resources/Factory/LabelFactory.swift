//
//  LabelFactory.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 15.03.2024.
//

import UIKit

final class LabelFactory {
	static func createLabel(
		text: String? = nil,
		font: UIFont?,
		textColor: UIColor? = .white,
		textAlignment: NSTextAlignment = .left,
		numberOfLines: Int = 0,
		isSkeletonable: Bool = false,
		linesCornerRadius: Int = 2,
		skeletonCornerRadius: Float = 2
	) -> UILabel {
		let label = UILabel()
		label.text = text
		label.font = font
		label.textColor = textColor
		label.textAlignment = textAlignment
		label.numberOfLines = numberOfLines
		label.isSkeletonable = isSkeletonable
		label.linesCornerRadius = linesCornerRadius
		label.skeletonCornerRadius = skeletonCornerRadius
		return label
	}
}
