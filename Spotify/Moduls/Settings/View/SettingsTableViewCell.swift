//
//  SettingsTableViewCell.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 04.03.2024.
//

import UIKit

final class SettingsTableViewCell: UITableViewCell {
	
	var didTapProfile: (() -> Void)?
	var didTapSignOut: (() -> Void)?
	
	static var reuseId = String(describing: SettingsTableViewCell.self)
	
	// MARK: - UI
	
	private var profile: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("View_Your_Profile".localized, for: .normal)
		button.backgroundColor = #colorLiteral(red: 1, green: 0.8235294118, blue: 0.8431372549, alpha: 1)
		button.setTitleColor(.black, for: .normal)
		button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 15)
		button.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
		return button
	}()
	
	private var signOut: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Sign_Out".localized, for: .normal)
		button.backgroundColor = .white
		button.setTitleColor(.black, for: .normal)
		button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 13)
		button.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
		return button
	}()
	
	// MARK: - Lifecycle
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		profile.layer.cornerRadius = 8
		signOut.layer.cornerRadius = 12
	}
	
	//MARK: - Button action
	
	@objc
	private func profileTapped() {
		didTapProfile?()
	}
	
	@objc
	private func signOutTapped() {
		didTapSignOut?()
	}
	
	// MARK: - Setup Views
	private func setupViews() {
		contentView.backgroundColor = .black
		[profile, signOut].forEach {
			contentView.addSubview($0)
		}
	}
	
	// MARK: - Setup Constraints
	private func setupConstraints() {
		
		profile.snp.makeConstraints { make in
			make.top.equalTo(contentView.snp.top)
			make.leading.trailing.equalToSuperview().inset(30)
			make.height.equalTo(50)
		}
		
		signOut.snp.makeConstraints { make in
			make.top.equalTo(profile.snp.bottom).offset(60)
			make.centerX.equalToSuperview()
			make.height.equalTo(32)
			make.width.equalTo(80)
			make.bottom.equalToSuperview()
		}
	}
}
