//
//  SettingsViewController.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 03.03.2024.
//

import UIKit

final class SettingsViewController: UIViewController {
	
	// MARK: - UI
	private lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.backgroundColor = .black
		tableView.dataSource = self
		tableView.delegate = self
		tableView.separatorStyle = .none
		tableView.registerCell(SettingsTableViewCell.self)
		return tableView
	}()
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
	}
	
	// MARK: - SetupViews
	
	private func setupViews() {
		view.backgroundColor = .black
		
		view.addSubview(tableView)
		tableView.snp.makeConstraints { make in
			make.top.bottom.equalTo(view.safeAreaLayoutGuide)
			make.left.right.equalToSuperview()
		}
	}
	// MARK: - Private
	
	private func showProfilePage() {
		let controller = ProfileViewController()
		controller.title = "Profile"
		navigationController?.pushViewController(controller, animated: true)
	}
	
	private func didTapSignOut() {
		signOutTapped()
	}
	
	private func signOutTapped() {
		let alert = UIAlertController(title: "Sign Out",
																	message: "Are you sure?",
																	preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
			AuthManager.shared.signOut { [weak self] signedOut in
				if signedOut {
					DispatchQueue.main.async {
						let navVC = UINavigationController(rootViewController: WelcomeViewController())
						navVC.navigationBar.prefersLargeTitles = true
						navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
						navVC.modalPresentationStyle = .fullScreen
						self?.present(navVC, animated: true, completion: {
							self?.navigationController?.popToRootViewController(animated: false)
						})
					}
				}
			}
		}))
		present(alert, animated: true)
	}
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SettingsTableViewCell
		
		cell.didTapProfile = { [weak self] in
			self?.showProfilePage()
		}
		
		cell.didTapSignOut = { [weak self] in
			self?.didTapSignOut()
		}
		return cell
	}
}


