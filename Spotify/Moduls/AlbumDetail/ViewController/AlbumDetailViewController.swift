//
//  AlbumDetailViewController.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 16.03.2024.
//

import UIKit
import SkeletonView

final class AlbumDetailViewController: BaseViewController {
	
	// MARK: - Properties
	
	var viewModel: AlbumDetailViewModel?
	var albumId: String?
	var playlistId: String?
	var isAlbumDetail = false
	var albumImageUrl: URL?
	
	private lazy var albums: [Track] = [] {
		didSet {
			self.tableView.reloadData()
		}
	}
	
	private lazy var playlistItem: [PlaylistItem] = [] {
		didSet {
			self.tableView.reloadData()
		}
	}
	
	// MARK: - UI
	
	private lazy var albumImageView = ImageFactory.createImage(
		clipsToBounds: false,
		isSkeletonable: true,
		skeletonCornerRadius: 8
	)
	
	private lazy var albumNameLabel = LabelFactory.createLabel(
		font: UIFont(name: "HelveticaNeue-Bold", size: 28),
		textColor: .white,
		isSkeletonable: true
	)
	
	private lazy var subTitleLabel = LabelFactory.createLabel(
		text: "The essential tracks, all in one playlist.",
		font: UIFont(name: "HelveticaNeue", size: 13),
		textColor: #colorLiteral(red: 0.7540719509, green: 0.7540718913, blue: 0.7540718913, alpha: 1),
		isSkeletonable: true
	)
	
	private lazy var spotifyImageView = ImageFactory.createImage(
		isSkeletonable: true,
		skeletonCornerRadius: 8,
		image: UIImage(named: "spotify_launch_screen")
	)
	
	private lazy var spotifyLabel = LabelFactory.createLabel(
		text: "Spotify",
		font: UIFont(name: "HelveticaNeue", size: 13),
		textColor: .white,
		isSkeletonable: true
	)
	
	private lazy var timeLabel = LabelFactory.createLabel(
		font: UIFont(name: "HelveticaNeue", size: 13),
		textColor: #colorLiteral(red: 0.7540719509, green: 0.7540718913, blue: 0.7540718913, alpha: 1),
		isSkeletonable: true
	)
	
	private lazy var buttonStackView = StackViewFactory.createStackView(
		spacing: 24,
		axis: .horizontal,
		isSkeletonable: true
	)
	
	private var heartAction: UIButton = {
		let button = UIButton(type: .custom)
		button.setImage(UIImage(named: "heart"), for: .normal)
		button.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
		return button
	}()
	
	private var shareButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setImage(UIImage(named: "share"), for: .normal)
		button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
		return button
	}()
	
	private var detailButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setImage(UIImage(named: "dots"), for: .normal)
		button.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
		return button
	}()
	
	private var playButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setImage(UIImage(named: "play_button"), for: .normal)
		button.clipsToBounds = true
		button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
		button.isSkeletonable = true
		return button
	}()
	
	private lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.separatorStyle = .none
		tableView.backgroundColor = .clear
		tableView.register(PlaylistTableViewCell.self, forCellReuseIdentifier: "PlaylistTableViewCell")
		tableView.isSkeletonable = true
		return tableView
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if isAlbumDetail == true {
			loadDetailAlbum()
		} else {
			loadDetailPlaylist()
		}
		setupNavigationBar()
		setupViews()
		setupConstraints()
	}

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		spotifyImageView.layer.cornerRadius = 12
		playButton.layer.cornerRadius = 28
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		view.isSkeletonable = true
		let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
		view.showAnimatedGradientSkeleton(
			usingGradient: .init(baseColor: .skeletonDefault),
			animation: animation)
		tableView.showAnimatedGradientSkeleton(
			usingGradient: .init(baseColor: .skeletonDefault),
			animation: nil,
			transition: .crossDissolve(0.25))
		setupGradient()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
			self.view.stopSkeletonAnimation()
			self.view.hideSkeleton()
			self.tableView.stopSkeletonAnimation()
			self.tableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
			super.viewWillDisappear(animated)
			setupNavBar()
	}
	// MARK: - Navigation bar
	
	private func setupNavigationBar() {
		let navigationBarAppearance = UINavigationBarAppearance()
		navigationBarAppearance.configureWithOpaqueBackground()
		navigationBarAppearance.titleTextAttributes = [
				NSAttributedString.Key.foregroundColor: UIColor.white
		]
		navigationBarAppearance.largeTitleTextAttributes = [
				NSAttributedString.Key.foregroundColor: UIColor.white
		]
		navigationBarAppearance.backgroundColor = UIColor(
				red: 0.0/255.0,
				green: 128.0/255.0,
				blue: 174.0/255.0,
				alpha: 1
		)
		
		navigationController?.navigationBar.standardAppearance = navigationBarAppearance
		navigationController?.navigationBar.compactAppearance = navigationBarAppearance
		navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
	}
	
	// MARK: -  Buttons action
	
	@objc func playButtonTapped() {
		print("Play")
	}
	
	@objc func heartButtonTapped() {
		print("Like!")
	}
	
	@objc func shareButtonTapped() {
		print("Share!")
	}
	
	@objc func detailButtonTapped() {
		print("Detail!")
	}
	
	// MARK: - FetchData
	
	private func loadDetailAlbum() {
		viewModel = AlbumDetailViewModel()
		viewModel?.getAlbumDetail(albumsID: albumId!, completion: { [weak self] response in
			switch response {
			case .success(let result):
				let url = URL(string: result.images.first?.url ?? "")
				self?.albumImageUrl = url
				self?.albumImageView.kf.setImage(with: url)
				self?.albumNameLabel.text = result.name
				self?.albums = result.tracks.items
				var sum = 0
				for i in result.tracks.items {
					sum += i.durationMS ?? 0
				}
				let convertDuration = Double(sum).asString(style: .abbreviated)
				self?.timeLabel.text = "\(result.popularity ?? 0) likes • \(convertDuration)"
			case .failure(_):
				break
			}
		})
	}
	
	private func loadDetailPlaylist() {
		viewModel = AlbumDetailViewModel()
		viewModel?.getPlaylists(playlistID: playlistId ?? "", completion: { [weak self] response in
			switch response {
				
			case .success(let result):
				let url = URL(string: result.images?.first?.url ?? "")
				self?.albumImageView.kf.setImage(with: url)
				self?.albumNameLabel.text = result.name
				self?.playlistItem = result.tracks.items
				var sum = 0
				for i in result.tracks.items {
					sum += i.track?.durationMS ?? 0
				}
				let convertDuration = Double(sum).asString(style: .abbreviated)
				self?.timeLabel.text = "\(result.tracks.items.first?.track?.popularity ?? 0) likes • \(convertDuration)"
			case .failure(_):
				break
			}
		})
	}
	
	// MARK: - SetupViews
	
	private func setupViews() {
		[albumImageView, albumNameLabel, subTitleLabel, spotifyImageView, spotifyLabel, timeLabel, buttonStackView, playButton, tableView].forEach {
			view.addSubview($0)
		}
		
		[heartAction, shareButton, detailButton].forEach {
			buttonStackView.addArrangedSubview($0)
		}
	}
	
	// MARK: - SetupConstraints
	
	private func setupConstraints() {
		albumImageView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
			make.centerX.equalToSuperview()
			make.size.equalTo(150)
		}
		
		albumNameLabel.snp.makeConstraints { make in
			make.top.equalTo(albumImageView.snp.bottom).offset(16)
			make.leading.trailing.equalToSuperview().inset(16)
		}
		
		subTitleLabel.snp.makeConstraints { make in
			make.top.equalTo(albumNameLabel.snp.bottom).offset(12)
			make.leading.trailing.equalToSuperview().inset(16)
		}
		
		spotifyImageView.snp.makeConstraints { make in
			make.top.equalTo(subTitleLabel.snp.bottom).offset(8)
			make.leading.equalToSuperview().inset(16)
			make.size.equalTo(24)
		}
		
		spotifyLabel.snp.makeConstraints { make in
			make.top.equalTo(subTitleLabel.snp.bottom).offset(12)
			make.leading.equalTo(spotifyImageView.snp.trailing).offset(8)
			make.trailing.equalToSuperview().offset(-16)
		}
		
		timeLabel.snp.makeConstraints { make in
			make.top.equalTo(spotifyImageView.snp.bottom).offset(8)
			make.leading.trailing.equalToSuperview().inset(16)
		}
		
		buttonStackView.snp.makeConstraints { make in
			make.top.equalTo(timeLabel.snp.bottom).offset(28)
			make.leading.equalToSuperview().inset(16)
			make.width.equalTo(120)
			make.height.equalTo(24)
		}
		
		playButton.snp.makeConstraints { make in
			make.trailing.equalToSuperview().offset(-16)
			make.size.equalTo(56)
			make.top.equalTo(timeLabel.snp.bottom).offset(12)
		}
		tableView.snp.makeConstraints { make in
			make.top.equalTo(playButton.snp.bottom).offset(8)
			make.leading.trailing.bottom.equalToSuperview()
		}
	}
	
	private func setupGradient() {
		let firstColor = UIColor(
			red: 0.0/255.0,
			green: 128.0/255.0,
			blue: 174.0/255.0,
			alpha: 1
		).cgColor
		let secondColor = UIColor.black.cgColor
		
		let gradient = CAGradientLayer()
		gradient.colors = [firstColor, secondColor]
		gradient.locations = [0.0, 0.6]
		gradient.type = .axial
		gradient.frame = self.view.bounds
		
		self.view.layer.insertSublayer(gradient, at: 0)
	}
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension AlbumDetailViewController: UITableViewDelegate, UITableViewDataSource, SkeletonTableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isAlbumDetail == true {
			return albums.count
		} else {
			return playlistItem.count
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PlaylistTableViewCell
		if isAlbumDetail == true {
			let albums = albums[indexPath.row]
			cell.configure(data: albums)
		} else {
			let playlist = playlistItem[indexPath.row]
			cell.configure(data: playlist)
		}
		cell.numberLabel.text = "\(indexPath.row + 1)"
		return cell
	}
	
	func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isAlbumDetail == true {
			return albums.count
		} else {
			return playlistItem.count
		}
	}

	func collectionSkeletonView(
		_ skeletonView: UITableView,
		cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
			return PlaylistTableViewCell.reuseID
	}

	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 64
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if isAlbumDetail == true {
			let albums = albums[indexPath.row]
			let playerViewController = PlayerViewController()
			playerViewController.track = albums
			playerViewController.transferFromDetail = true
			playerViewController.albumImageUrl = albumImageUrl
			playerViewController.modalPresentationStyle = .overFullScreen
			present(playerViewController, animated: true)
		} else {
			let playlist = playlistItem[indexPath.row]
			let playerViewController = PlayerViewController()
			playerViewController.transferFromDetailPlaylisrs = true
			playerViewController.playlistItem = playlist
			playerViewController.modalPresentationStyle = .overFullScreen
			present(playerViewController, animated: true)
		}
	}
}

