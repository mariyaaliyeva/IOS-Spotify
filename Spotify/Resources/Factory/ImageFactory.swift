//
//  ImageFactory.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 15.03.2024.
//

import UIKit

final class ImageFactory {
	
	static func createImage(
	contentMode: UIView.ContentMode = .scaleAspectFill,
	clipsToBounds: Bool = true,
	backgroundColor: UIColor = .clear,
	isSkeletonable: Bool = false,
	skeletonCornerRadius: Float = 4,
	image: UIImage? = nil,
	cornerRadius: CGFloat = 0
	)
	-> UIImageView {
		let imageView = UIImageView()
		imageView.contentMode = contentMode
		imageView.clipsToBounds = clipsToBounds
		imageView.backgroundColor = backgroundColor
		imageView.isSkeletonable = isSkeletonable
		imageView.skeletonCornerRadius = skeletonCornerRadius
		imageView.image = image
		imageView.layer.cornerRadius = 0
		return imageView
	}
}

