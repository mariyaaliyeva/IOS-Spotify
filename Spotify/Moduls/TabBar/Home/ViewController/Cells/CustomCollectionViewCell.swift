//
//  CustomCollectionViewCell.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 13.02.2024.
//

import UIKit

final class CustomCollectionViewCell: UICollectionViewCell {
	
	static let reuseId = "CustomCollectionViewCell"
	
	// MARK: - Consraints
	
	private enum Consraints {
		static let musicImageSize: CGFloat = 152
		static let musicImageCornerRadius: CGFloat = 4
		static let topAlbumNameLabel: CGFloat = 8
	}
	
	// MARK: - UI
	
	private lazy var albumImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private lazy var albumNameLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = .white
		label.font = UIFont(name: "HelveticaNeue", size: 16)
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.sizeToFit()
		return label
	}()
	
	// MARK: - Lifecycle
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
		setupViews()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		albumImageView.clipsToBounds = true
		albumImageView.layer.cornerRadius = Consraints.musicImageCornerRadius
	}
	
	//MARK: - Public
	func configure(with model: CollectionTableCellModel?) {
		albumNameLabel.text = model?.title
		albumImageView.image = UIImage(named: model?.imageName ?? "")
	}
	
	// MARK: - Setup Views
	private func setupViews() {
		backgroundColor = .clear
		contentView.addSubview(albumImageView)
		contentView.addSubview(albumNameLabel)
	}
	
	// MARK: - Setup Constraints
	private func setupConstraints() {
		
		albumImageView.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
			make.size.equalTo(Consraints.musicImageSize)
		}
		
		albumNameLabel.snp.makeConstraints { make in
			make.top.equalTo(albumImageView.snp.bottom).offset(Consraints.topAlbumNameLabel)
			make.leading.trailing.equalToSuperview()
		}
	}
}
