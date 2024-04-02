//
//  GenreCollectionViewCell.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 30.03.2024.
//

import UIKit

final class CategoriesCollectionViewCell: UICollectionViewCell {
	
	static let identifier = "CategoriesCollectionViewCell"
	
	// MARK: - UI
	
	private let categoryTitle: UILabel = {
		var label = UILabel()
		label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
		return label
	}()
	
	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Public func
	
	func configure(data: Item) {
		categoryTitle.text = data.name
	}
	
	// MARK: - SetupViews
	
	private func setupViews() {
		contentView.backgroundColor = randomColor()
		contentView.clipsToBounds = true
		contentView.layer.cornerRadius = 8
		contentView.addSubview(categoryTitle)
	}
	
	// MARK: - SetupConstraints
	
	private func setupConstraints() {
		categoryTitle.snp.makeConstraints { make in
			make.top.leading.equalTo(contentView).offset(8)
			make.trailing.equalToSuperview().inset(16)
		}
	}

	// MARK: - Private func
	
	private func randomColor() -> UIColor {
		let r = CGFloat(arc4random()) / CGFloat(UInt32.max)
		let g = CGFloat(arc4random()) / CGFloat(UInt32.max)
		let b = CGFloat(arc4random()) / CGFloat(UInt32.max)
		
		return UIColor(red: r, green: g, blue: b, alpha: 1.0)
	}
}
