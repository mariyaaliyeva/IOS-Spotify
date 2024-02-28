//
//  RecomendedMusicTableViewCell.swift
//  Spotify
//
//  Created by Aliyeva Mariya on 10.02.2024.
//

import UIKit

final class RecomendedMusicTableViewCell: UITableViewCell {
	
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
		return image
	}()
	
	private lazy var textsStackView: UIStackView = {
		let stack = UIStackView()
		stack.spacing = Consraints.textsStackViewSpacing
		stack.distribution = .fillEqually
		stack.alignment = .fill
		stack.axis = .vertical
		return stack
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Inter-Regular", size: 16)
		label.textColor = .white
		label.textAlignment = .left
		return label
	}()
	
	private lazy var subtitleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Inter-Regular", size: 13)
		label.textAlignment = .left
		label.textColor = #colorLiteral(red: 0.713041544, green: 0.713041544, blue: 0.713041544, alpha: 1)
		return label
	}()
	
	private lazy var rightView: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleToFill
		image.image = UIImage(named: "icon_right")
		return image
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Public
	func configure(data: RecomendedMusicData?) {
		guard let data else { return }
		self.musicImage.image = data.image
		self.titleLabel.text = data.title
		if let subtitle = data.subtitle {
			self.subtitleLabel.text = subtitle
		} else {
			subtitleLabel.isHidden = true
		}
	}
	
	// MARK: - SetupViews
	
	private func setupViews() {
		contentView.backgroundColor = .black
		selectionStyle = .none
		
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
		}
		
		rightView.snp.makeConstraints { make in
			make.right.equalToSuperview().inset(12)
			make.centerY.equalToSuperview()
			make.size.equalTo(Consraints.rightViewSize)
		}
	}
}
