//
//  ProfileViewController.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 04.03.2024.
//

import UIKit
import Kingfisher
import SkeletonView

final class ProfileViewController: BaseViewController {
	
	// MARK: - UI
	
	private lazy var iconImageView = ImageFactory.createImage(
		backgroundColor: #colorLiteral(red: 0.8797428012, green: 0.8797428012, blue: 0.8797428012, alpha: 1),
		isSkeletonable: true,
		skeletonCornerRadius: 60
	)
	
	private lazy var nameLabel = LabelFactory.createLabel(
		font: UIFont(name: "HelveticaNeue", size: 16)
	)
	
	private lazy var emailLabel = LabelFactory.createLabel(
		font: UIFont(name: "HelveticaNeue", size: 16)
	)
	
	private lazy var userIDLabel = LabelFactory.createLabel(
		font: UIFont(name: "HelveticaNeue", size: 16)
	)
	
	private lazy var planLabel = LabelFactory.createLabel(
		font: UIFont(name: "HelveticaNeue", size: 16)
	)
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupConstraints()
		loadUserProfile()
	}
	
	override func setupTitles() {
		title = "Profile".localized
	}
	
	// MARK: - ViewDidLayoutSubviews
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		iconImageView.layer.cornerRadius = 60
	}
	
	// MARK: - Private
	private func loadUserProfile() {
		iconImageView.showAnimatedGradientSkeleton()
		ProfileManager.shared.getCurrentUserProfile { [weak self] response in
			switch response {
			case .success(let result):
				let url = URL(string: result.images?.first?.url ?? "")
				self?.iconImageView.kf.setImage(with: url)
				self?.nameLabel.text = NSLocalizedString("Full_Name", comment: " ") + ": " + (result.displayName ?? "")
				self?.emailLabel.text = NSLocalizedString("Email_Address", comment: " ") + ": " + (result.email ?? "")
				self?.userIDLabel.text = NSLocalizedString("User_ID", comment: " ") + ": " + (result.id)
				self?.planLabel.text = NSLocalizedString("Plan", comment: " ") + ": " + (result.product)
				self?.iconImageView.hideSkeleton()
			case .failure(let error):
				print(error)
			}
		}
	}
	
	// MARK: - SetupViews
	private func setupViews() {
		title = "Profile".localized
		view.backgroundColor = .black
		
		[iconImageView, nameLabel, emailLabel, userIDLabel, planLabel].forEach {
			view.addSubview($0)
		}
	}
	
	// MARK: - SetupConstraints
	private func setupConstraints() {
		
		iconImageView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
			make.size.equalTo(120)
			make.centerX.equalToSuperview()
		}
		
		nameLabel.snp.makeConstraints { make in
			make.top.equalTo(iconImageView.snp.bottom).offset(60)
			make.leading.trailing.equalToSuperview().inset(16)
		}
		
		emailLabel.snp.makeConstraints { make in
			make.top.equalTo(nameLabel.snp.bottom).offset(16)
			make.leading.trailing.equalToSuperview().inset(16)
		}
		userIDLabel.snp.makeConstraints { make in
			make.top.equalTo(emailLabel.snp.bottom).offset(16)
			make.leading.trailing.equalToSuperview().inset(16)
		}
		planLabel.snp.makeConstraints { make in
			make.top.equalTo(userIDLabel.snp.bottom).offset(16)
			make.leading.trailing.equalToSuperview().inset(16)
		}
	}
}
