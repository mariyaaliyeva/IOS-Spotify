//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 22.02.2024.
//

import UIKit

final class WelcomeViewController: UIViewController {
	
	// MARK: - Properties
	
	private lazy var signInButton: UIButton = {
		let button = UIButton()
		button.backgroundColor = .white
		button.setTitle("Sign In with Spotify", for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
		button.layer.cornerRadius = 16
		return button
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
	}
	
	// MARK: - Private methods
	
	private func setupViews() {
		title = "Spotify"
		view.backgroundColor = .systemGreen
		
		view.addSubview(signInButton)
		signInButton.snp.makeConstraints { make in
			make.height.equalTo(50)
			make.left.right.equalToSuperview().inset(16)
			make.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
		}
	}
	
	@objc
	private func didTapSignIn() {
		let controller = AuthViewController()
		controller.completionHandler = { [weak self] success in
			self?.handleSignIn(success: success)
		}
		controller.navigationItem.largeTitleDisplayMode = .never
		navigationController?.pushViewController(controller, animated: true)
	}
	
	private func handleSignIn(success: Bool) {
		guard success else {
			let alert = UIAlertController(
				title: "OK",
				message: "Something went wrong when signin",
				preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
			return
		}
		
		let tabbarViewController = MainTabBarController()
		tabbarViewController.modalPresentationStyle = .fullScreen
		present(tabbarViewController, animated: true)
	}
}
