//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 26.03.2024.
//

import UIKit
import AVFoundation

final class PlayerViewController: UIViewController {
	
	// MARK: - Properties
	var track: Track?
	var transferFromDetail: Bool?
	var albumImageUrl: URL?
	var transferFromDetailPlaylisrs: Bool?
	var playlistItem: PlaylistItem?
	private var isPlay = false
	private var player: AVPlayer?
	
	// MARK: - UI
	
	private lazy var closeButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(named: "down_icon"), for: .normal)
		button.tintColor = .white
		button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
		return button
	}()
	
	private var titleLabel = LabelFactory.createLabel(
		font: UIFont(name: "HelveticaNeue-Bold", size: 13),
		textAlignment: .center
	)

	private let musicImageView = ImageFactory.createImage(
		contentMode: .scaleAspectFit,
		image: UIImage(named: "play_button")
	)
		
	private var musicTextsStackView = StackViewFactory.createStackView(
		spacing: 2,
		distribution: .equalSpacing,
		axis: .vertical
	)
	
	private var musicTitleLabel = LabelFactory.createLabel(
		font: UIFont(name: "HelveticaNeue-Bold", size: 21)
	)
	
	private var musicSubtitleLabel = LabelFactory.createLabel(
		text: "Coldplay",
		font: UIFont(name: "HelveticaNeue", size: 16)
	)
	
	private let favoriteImageView = ImageFactory.createImage(
		contentMode: .scaleAspectFit,
		image: UIImage(named: "heart")
	)
	
	private let musicSlider: UISlider = {
			let slider = UISlider()
			slider.value = 0.0
			slider.tintColor = .white
			return slider
	}()
	
	private let buttonsStackView = StackViewFactory.createStackView(
		distribution: .equalSpacing,
		axis: .horizontal
	)
	
	private let backButton: UIButton = {
		let button = UIButton(type: .system)
		let config = UIImage.SymbolConfiguration(pointSize: 20)
		let image = UIImage(systemName: "backward.end.fill", withConfiguration: config)
		
		button.configuration = UIButton.Configuration.filled()
		button.configuration?.baseBackgroundColor = .clear
		button.configuration?.cornerStyle = .medium
		button.configuration?.image = image
		button.tintColor = .white
		return button
	}()
	
	private let forwardButton: UIButton = {
		let button = UIButton(type: .system)
		let config = UIImage.SymbolConfiguration(pointSize: 20)
		let image = UIImage(systemName: "forward.end.fill", withConfiguration: config)
		
		button.configuration = UIButton.Configuration.filled()
		button.configuration?.baseBackgroundColor = .clear
		button.configuration?.cornerStyle = .medium
		button.configuration?.image = image
		button.tintColor = .white
		return button
	}()

	private let playPauseButton: UIButton = {
		let button = UIButton(type: .system)
		let config = UIImage.SymbolConfiguration(pointSize: 45)
		let image = UIImage(systemName: "pause.circle.fill", withConfiguration: config)

		button.configuration = UIButton.Configuration.filled()
		button.configuration?.baseBackgroundColor = .clear
		button.configuration?.cornerStyle = .medium
		button.configuration?.image = image
		button.tintColor = .white
		button.addTarget(self, action: #selector(pauseButton), for: .touchUpInside)
		return button
	}()
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupConstraints()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupGradient()
		loadData()
		if transferFromDetailPlaylisrs == true {
			guard let musicUrl = URL(string: playlistItem?.track?.previewURL ?? "") else { return }
			player = AVPlayer(url: musicUrl)
			player?.volume = 0.5
			player?.play()
		}
		guard let musicUrl = URL(string: track?.previewURL ?? "") else { return }
		player = AVPlayer(url: musicUrl)
		player?.volume = 0.5
		player?.play()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		player?.pause()
	}
	
	// MARK: - Button actions
	
	@objc
	private func didTapCloseButton() {
		dismiss(animated: true)
	}
	
	@objc
	private func pauseButton() {
		isPlay.toggle()
		isPlayOrPauseMusic()
	}
	
	private func isPlayOrPauseMusic() {
		if isPlay == true {
			player?.pause()
			let config = UIImage.SymbolConfiguration(pointSize: 45)
			playPauseButton.configuration?.image = UIImage(systemName: "play.circle.fill", withConfiguration: config)
		} else {
			let config = UIImage.SymbolConfiguration(pointSize: 45)
			playPauseButton.configuration?.image = UIImage(systemName: "pause.circle.fill", withConfiguration: config)
			player?.play()
		}
	}
	
	private func setupGradient() {

		let firstColor = UIColor(
			red: 104.0/255.0,
			green: 24.0/255.0,
			blue: 16.0/255.0,
			alpha: 1
		).cgColor
		let secondColor = UIColor.black.cgColor
		
		let gradient = CAGradientLayer()
		gradient.colors = [firstColor, secondColor]
		gradient.locations = [0.0, 0.8]
		gradient.type = .axial
		gradient.frame = self.view.bounds
		
		self.view.layer.insertSublayer(gradient, at: 0)
	}
	
	private func loadData() {
		titleLabel.text = track?.name
		musicTitleLabel.text = track?.name
		musicSubtitleLabel.text = track?.artists?.first?.name
		if transferFromDetail == true {
			musicImageView.kf.setImage(with: albumImageUrl)
		} else if transferFromDetailPlaylisrs == true {
			titleLabel.text = playlistItem?.track?.name
			musicTitleLabel.text = playlistItem?.track?.name
			musicSubtitleLabel.text = playlistItem?.track?.artists?.first?.name
			let url = URL(string: playlistItem?.track?.album?.images?.first?.url ?? "")
			musicImageView.kf.setImage(with: url)
		} else {
			let url = URL(string: track?.album?.images?.first?.url ?? "")
			musicImageView.kf.setImage(with: url)
		}
	}
	
	// MARK: - SetupViews
	
	private func setupViews() {
		
		[musicTitleLabel, musicSubtitleLabel].forEach {
			musicTextsStackView.addArrangedSubview($0)
		}
		
		[backButton,
		 playPauseButton,
		 forwardButton].forEach {
			buttonsStackView.addArrangedSubview($0)
		}
		[closeButton,
		 titleLabel,
		 musicImageView,
		 musicTextsStackView,
		 favoriteImageView,
		 musicSlider,
		 buttonsStackView
		].forEach {
			view.addSubview($0)
		}
	}
	
	// MARK: - SetupConstraints
	
	private func setupConstraints() {
		
		closeButton.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).inset(12)
			make.left.equalToSuperview().inset(24)
			make.size.equalTo(24)
		}
		
		titleLabel.snp.makeConstraints { make in
			make.centerY.equalTo(closeButton)
			make.left.equalTo(closeButton.snp.right).offset(12)
			make.right.equalToSuperview().inset(60)
		}
		
		musicImageView.snp.makeConstraints { make in
			make.height.equalTo(300)
			make.left.right.equalToSuperview().inset(36)
			make.bottom.equalTo(musicTextsStackView.snp.top).offset(-100)
		}
		
		musicTextsStackView.snp.makeConstraints { make in
			make.left.equalToSuperview().inset(24)
			make.right.equalTo(favoriteImageView.snp.left).offset(-12)
			make.bottom.equalTo(musicSlider.snp.top).offset(-36)
		}
		
		favoriteImageView.snp.makeConstraints { make in
			make.right.equalToSuperview().inset(24)
			make.size.equalTo(24)
			make.centerY.equalTo(musicTextsStackView)
		}
		
		musicSlider.snp.makeConstraints { make in
			make.left.right.equalToSuperview().inset(24)
			make.height.equalTo(4)
			make.bottom.equalTo(buttonsStackView.snp.top).offset(-36)
		}
		
		buttonsStackView.snp.makeConstraints { make in
			make.left.right.equalToSuperview().inset(12)
			make.bottom.equalToSuperview().inset(70)
		}
	}
}
