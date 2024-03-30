//
//  CustomCollectionViewCell.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 13.02.2024.
//

import UIKit
import Kingfisher
import SkeletonView

final class CustomCollectionViewCell: UICollectionViewCell {
	
	static let reuseId = "CustomCollectionViewCell"
	
	// MARK: - Consraints
	
	private enum Consraints {
		static let musicImageSize: CGFloat = 152
		static let musicImageCornerRadius: CGFloat = 4
		static let topAlbumNameLabel: CGFloat = 8
	}
	
	// MARK: - UI
	
	private lazy var albumImageView = ImageFactory.createImage(
		isSkeletonable: true,
		skeletonCornerRadius: 8
	)

	private lazy var albumNameLabel = LabelFactory.createLabel(
		font: UIFont(name: "HelveticaNeue", size: 16),
		isSkeletonable: true
	)
	
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
		albumImageView.layer.cornerRadius = Consraints.musicImageCornerRadius
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		albumImageView.image = nil
		albumNameLabel.text = nil
		if contentView.sk.isSkeletonActive {
			isSkeletonable = false
			contentView.isSkeletonable = false
			contentView.hideSkeleton()
		}
	}
	
	//MARK: - Public
	func configure(with model: Playlists) {
		albumNameLabel.text = model.name
		let url = URL(string: model.images?.first?.url ?? "")
		self.albumImageView.kf.setImage(with: url)
	}
	
	func configure(with model: PlaylistDataModel) {
		albumNameLabel.text = model.name
		let url = URL(string: model.images?.first?.url ?? "")
		self.albumImageView.kf.setImage(with: url)
	}
	
	// MARK: - Setup Views
	private func setupViews() {
		backgroundColor = .clear
		isSkeletonable = true
		contentView.isSkeletonable = true
		[albumImageView, albumNameLabel].forEach {
			contentView.addSubview($0)
		}
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
			make.height.greaterThanOrEqualTo(35)
			make.width.greaterThanOrEqualTo(150)
		}
	}
}
