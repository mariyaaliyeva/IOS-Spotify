//
//  SectionHeader.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 07.03.2024.
//

import UIKit

final class SectionHeader: UICollectionReusableView {
	
	// MARK: - UI
	
	private lazy var label = LabelFactory.createLabel(
		font: UIFont(name: "Inter-Regular", size: 15)
	)

	// MARK: - Lifecycle
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Public methods
	
	func configure(text: String) {
		label.text = text
	}
	
	func fontConfigure(font: UIFont) {
		label.font = font
	}
	
	// MARK: - SetupViews
	private func setupViews() {
		addSubview(label)
		label.snp.makeConstraints { make in
			make.left.right.equalToSuperview()
			make.top.bottom.equalToSuperview().inset(2)
		}
	}
}


