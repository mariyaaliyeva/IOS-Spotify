//
//  BaseViewController.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 28.02.2024.
//

import UIKit
import Lottie

class BaseViewController: UIViewController {
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavBar()
		addLanguageObserver()
	}
	
	func setupTitles() { }
	
	// MARK: - SetupNavBar
	
	private func setupNavBar() {
		let navigationBarAppearance = UINavigationBarAppearance()
		navigationBarAppearance.configureWithOpaqueBackground()
		navigationBarAppearance.titleTextAttributes = [
			NSAttributedString.Key.foregroundColor: UIColor.white
		]
		navigationBarAppearance.largeTitleTextAttributes = [
			NSAttributedString.Key.foregroundColor: UIColor.white
		]
		navigationBarAppearance.backgroundColor = .black
		
		navigationController?.navigationBar.standardAppearance = navigationBarAppearance
		navigationController?.navigationBar.compactAppearance = navigationBarAppearance
		navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
	}
	
	// MARK: - Observer
	
	private func addLanguageObserver() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(reloadTitles),
			name: NSNotification.Name("language"),
			object: nil
		)
	}
	
	@objc
	private func reloadTitles() {
		setupTitles()
	}
}
