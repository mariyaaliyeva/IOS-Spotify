//
//  LittlePlayerView.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 27.03.2024.
//

import UIKit

final class LittlePlayerView: UIView {
	
//	private let musicImageView: UIImageView = {
//		let imageView = UIImageView()
//		imageView.image = UIImage(named: "music_little")
//		imageView.layer.cornerRadius = 2
//		return imageView
//	}()
	
	private let musicImageView = ImageFactory.createImage(
		contentMode: .scaleAspectFit,
		image: UIImage(named: "play_button"),
		cornerRadius: 2
	)

	private var musicTextsStackView = StackViewFactory.createStackView(
		spacing: 2,
		distribution: .equalSpacing,
		axis: .vertical
	)
	
	private var musicTitleLabel = LabelFactory.createLabel(
		text: "Yellow",
		font: UIFont(name: "HelveticaNeue-Bold", size: 13)
	)
	
	private var musicSubtitleLabel = LabelFactory.createLabel(
		text: "Coldplay",
		font: UIFont(name: "HelveticaNeue", size: 13)
	)
	
	private let favoriteImageView = ImageFactory.createImage(
		contentMode: .scaleAspectFit,
		image: UIImage(named: "heart")
	)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = #colorLiteral(red: 0.4886336923, green: 0.1407772601, blue: 0.07441025227, alpha: 1)
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupViews() {
		[musicTitleLabel, musicSubtitleLabel].forEach {
			musicTextsStackView.addArrangedSubview($0)
		}
		
		[musicImageView,
		 musicTextsStackView,
		 favoriteImageView].forEach {
			addSubview($0)
		}
		
		musicImageView.snp.makeConstraints { make in
			make.size.equalTo(40)
			make.left.top.bottom.equalToSuperview().inset(8)
		}
		
		musicTextsStackView.snp.makeConstraints { make in
			make.centerY.equalTo(musicImageView)
			make.left.equalTo(musicImageView.snp.right).offset(12)
		}
		
		favoriteImageView.snp.makeConstraints { make in
			make.centerY.equalTo(musicImageView)
			make.right.equalToSuperview().inset(16)
			make.size.equalTo(24)
		}
	}
}
