//
//  RecomendedCollectionViewCell.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 06.03.2024.
//

import UIKit
import SkeletonView

final class RecomendedCollectionViewCell: UICollectionViewCell {
	
	static let reuseId = "RecomendedCollectionViewCell"
	
	// MARK: - Consraints
	
	private enum Consraints {
		static let musicImageSize: CGFloat = 48
		static let musicImageCornerRadius: CGFloat = 24
		static let textsStackViewSpacing: CGFloat = 2
		static let rightViewSize: CGFloat = 24
	}
	
	// MARK: - UIView
	
	private lazy var musicImage: UIImageView = {
		let image = UIImageView()
		image.layer.cornerRadius = Consraints.musicImageCornerRadius
		image.contentMode = .scaleAspectFill
		image.isSkeletonable = true
		image.skeletonCornerRadius = 24
		return image
	}()
	
	private lazy var textsStackView: UIStackView = {
		let stack = UIStackView()
		stack.spacing = Consraints.textsStackViewSpacing
		stack.distribution = .fillEqually
		stack.alignment = .fill
		stack.axis = .vertical
  	stack.isSkeletonable = true
		stack.skeletonCornerRadius = 2
		return stack
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Inter-Regular", size: 16)
		label.textColor = .white
		label.textAlignment = .left
		label.isSkeletonable = true
		label.linesCornerRadius = 2
		return label
	}()
	
	private lazy var subtitleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Inter-Regular", size: 13)
		label.textAlignment = .left
		label.textColor = #colorLiteral(red: 0.713041544, green: 0.713041544, blue: 0.713041544, alpha: 1)
		label.isSkeletonable = true
		label.linesCornerRadius = 2
		return label
	}()
	
	private lazy var rightView: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleToFill
		image.image = UIImage(named: "icon_right")
		return image
	}()
	
	// MARK: - Lifecycle
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		musicImage.clipsToBounds = true
		musicImage.layer.cornerRadius = Consraints.musicImageCornerRadius
	}
	
	// MARK: - Public
	func configure(data: Track) {
		self.titleLabel.text = data.name
		self.subtitleLabel.text = data.album?.name
		let url = URL(string: data.album?.images?.first?.url ?? "")
		self.musicImage.kf.setImage(with: url)
	}
	
	// MARK: - SetupViews
	
	private func setupViews() {
		isSkeletonable = true
		contentView.backgroundColor = .black
		
		[titleLabel, subtitleLabel].forEach {
			textsStackView.addArrangedSubview($0)
		}
		
		[musicImage, textsStackView, rightView].forEach {
			contentView.addSubview($0)
		}
		
		musicImage.snp.makeConstraints { make in
			make.left.equalToSuperview().inset(12)
			make.top.bottom.equalToSuperview().inset(8)
			make.size.equalTo(Consraints.musicImageSize)
		}
		
		textsStackView.snp.makeConstraints { make in
			make.left.equalTo(musicImage.snp.right).offset(12)
			make.top.bottom.equalTo(musicImage)
			make.height.greaterThanOrEqualTo(35)
			make.width.greaterThanOrEqualTo(150)
		}
		
		rightView.snp.makeConstraints { make in
			make.left.equalTo(textsStackView.snp.right).offset(-4)
			make.right.equalToSuperview().inset(12)
			make.centerY.equalToSuperview()
			make.size.equalTo(Consraints.rightViewSize)
		}
	}
}
