//
//  PlaylistTableViewCell.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 16.03.2024.
//

import UIKit

final class PlaylistTableViewCell: UITableViewCell {
	
	// MARK: - Consraints
	
	private enum Consraints {
		static let musicImageSize: CGFloat = 48
		static let musicImageCornerRadius: CGFloat = 24
		static let textsStackViewSpacing: CGFloat = 2
		static let rightViewSize: CGFloat = 24
	}
	
	// MARK: - UIView
	
	lazy var numberLabel = LabelFactory.createLabel(
		font: UIFont(name: "Inter-Regular", size: 13),
		textColor: #colorLiteral(red: 0.713041544, green: 0.713041544, blue: 0.713041544, alpha: 1),
		isSkeletonable: true
	)

	private lazy var textsStackView = StackViewFactory.createStackView(
		isSkeletonable: true
	)
	
	private lazy var titleLabel = LabelFactory.createLabel(
		font: UIFont(name: "Inter-Regular", size: 16),
		numberOfLines: 1,
		isSkeletonable: true
	)
	
	private lazy var subtitleLabel = LabelFactory.createLabel(
		font: UIFont(name: "Inter-Regular", size: 13),
		textColor: #colorLiteral(red: 0.713041544, green: 0.713041544, blue: 0.713041544, alpha: 1),
		isSkeletonable: true
	)
	
	private lazy var rightView = ImageFactory.createImage(
		contentMode: .scaleToFill,
		image: UIImage(named: "icon_right")
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
		addTitle(duration: data.durationMS ?? 0)
	}
	
	func configure(data: PlaylistItem) {
		self.titleLabel.text = data.track?.name
		addTitle(duration: data.track?.durationMS ?? 0)
	}
	
	// MARK: - Private
	
	private func addTitle(duration: Int?) {
		let doubleDuration = Double(duration ?? 0)
		let durationConvert = doubleDuration.asString(style: .abbreviated)
		if duration != nil {
			self.subtitleLabel.text = "\(durationConvert)"
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
		
		[numberLabel, textsStackView, rightView].forEach {
			contentView.addSubview($0)
		}
		
		numberLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().inset(12)
			make.centerY.equalToSuperview()
			make.width.equalTo(25)
		}
				
		textsStackView.snp.makeConstraints { make in
			make.left.equalTo(numberLabel.snp.right).offset(8)
			make.centerY.equalToSuperview()
			make.height.greaterThanOrEqualTo(35)
			make.width.greaterThanOrEqualTo(150)
		}
		
		rightView.snp.makeConstraints { make in
			make.left.equalTo(textsStackView.snp.right).offset(4)
			make.right.equalToSuperview().inset(12)
			make.centerY.equalToSuperview()
			make.size.equalTo(Consraints.rightViewSize)
		}
	}
}


