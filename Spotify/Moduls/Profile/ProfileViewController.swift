//
//  ProfileViewController.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 04.03.2024.
//

import UIKit
import Kingfisher
import SkeletonView

final class ProfileViewController: UIViewController {
	
	// MARK: - UI
	private lazy var iconImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.backgroundColor = #colorLiteral(red: 0.8797428012, green: 0.8797428012, blue: 0.8797428012, alpha: 1)
		imageView.isSkeletonable = true
		imageView.skeletonCornerRadius = 60
		return imageView
	}()
	
	private lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.textAlignment = .left
		label.font = UIFont(name: "HelveticaNeue", size: 16)
		return label
	}()
	
	private lazy var emailLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.textAlignment = .left
		label.font = UIFont(name: "HelveticaNeue", size: 16)
		return label
	}()
	
	private lazy var userIDLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.textAlignment = .left
		label.font = UIFont(name: "HelveticaNeue", size: 16)
		return label
	}()
	
	private lazy var planLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.textAlignment = .left
		label.font = UIFont(name: "HelveticaNeue", size: 16)
		return label
	}()
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupConstraints()
		loadUserProfile()
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
				self?.nameLabel.text = "Full Name: \(result.displayName ?? "")"
				self?.emailLabel.text = "Email Address: \(result.email ?? "")"
				self?.userIDLabel.text = "User ID: \(result.id)"
				self?.planLabel.text = "Plan: \(result.product) "
				self?.iconImageView.hideSkeleton()
			case .failure(let error):
				print(error)
			}
		}
	}
	
	// MARK: - SetupViews
	private func setupViews() {
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
