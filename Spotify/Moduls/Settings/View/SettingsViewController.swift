//
//  SettingsViewController.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 03.03.2024.
//

import UIKit

final class SettingsViewController: BaseViewController {
	
	private var currentLanguage: SupportedLanguages? {
			didSet {
					guard let currentLanguage else { return }
					didChange(language: currentLanguage)
			}
	}
	
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
		setupNavigationBar()
		setupViews()
	}
	
	override func setupTitles() {
		title = "Settings".localized
		tableView.reloadData()
	}
	
	// MARK: - SetupNavigationBar
	
	private func setupNavigationBar() {
		title = "Settings".localized
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "icon_language"),
			style: .done,
			target: self,
			action: #selector(didTapChangeLanguage)
		)
	}
	
	// MARK: - Button actions
	
	@objc
	private func didTapChangeLanguage() {
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		SupportedLanguages.all.forEach { language in
			alert.addAction(
				.init(
					title: language.localizedTitle,
					style: .default,
					handler: { [weak self] _ in
						self?.currentLanguage = language
					}
				)
			)
		}
		
		alert.addAction(.init(title: "Cancel".localized, style: .cancel))
		self.present(alert, animated: true, completion: nil)
	}
	
	private func didChange(language: SupportedLanguages) {
		Bundle.setLanguage(language: language.rawValue)
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: NSNotification.Name("language"), object: nil)
		}
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
		controller.title = "Profile".localized
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
		
		cell.configure()
		return cell
	}
}


