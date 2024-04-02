//
//  SearchResultsTableViewCell.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 02.04.2024.
//

import UIKit

final class SearchResultsTableViewCell: UITableViewCell {
	
	// MARK: - Consraints
	
	private enum Consraints {
		static let musicImageSize: CGFloat = 48
		static let musicImageCornerRadius: CGFloat = 24
		static let textsStackViewSpacing: CGFloat = 2
		static let rightViewSize: CGFloat = 24
	}
	
	// MARK: - UIView
	
	private lazy var musicImage = ImageFactory.createImage(
		isSkeletonable: true,
		skeletonCornerRadius: 24
	)
	
	private lazy var titleLabel = LabelFactory.createLabel(
		font: UIFont(name: "Inter-Regular", size: 16),
		isSkeletonable: true
	)
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		isSkeletonable = true
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Public
	func configure(data: Track) {
		self.titleLabel.text = data.name
		let url = URL(string: data.album?.images?.first?.url ?? "")
		self.musicImage.kf.setImage(with: url)
	}
	
	// MARK: - SetupViews
	
	private func setupViews() {
		contentView.backgroundColor = .black
		selectionStyle = .none
		
		[musicImage, titleLabel].forEach {
			contentView.addSubview($0)
		}
		
		musicImage.snp.makeConstraints { make in
			make.left.equalToSuperview().inset(12)
			make.top.bottom.equalToSuperview().inset(8)
			make.size.equalTo(Consraints.musicImageSize)
		}
		
		titleLabel.snp.makeConstraints { make in
			make.left.equalTo(musicImage.snp.right).offset(12)
			make.right.equalToSuperview().inset(12)
			make.top.bottom.equalTo(musicImage)
			make.height.greaterThanOrEqualTo(35)
		}
	}
}
