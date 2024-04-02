//
//  MainTabBarController.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 14.02.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {
	
	private let titles: [String] = ["Home".localized, "Search".localized, "Your_Library".localized]
	
	private let icons: [UIImage?] = [
		UIImage(named: "home_icon"),
		UIImage(named: "search_icon"),
		UIImage(named: "library_icon")
	]
	
	private var allViewController = [
		UINavigationController(rootViewController: HomeViewController()),
		UINavigationController(rootViewController: SearchViewController()),
		UINavigationController(rootViewController: LibraryViewController())
	]

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .black
		makeTabBarViews()
	}
	
	// MARK: - Private methods
	
	private func makeTabBarViews() {
		tabBar.tintColor = .white
		tabBar.barTintColor = .white //
		tabBar.backgroundColor = .black
	//	UITabBar.appearance().barTintColor = .black
		setViewControllers(allViewController, animated: false)
		
		allViewController.forEach {
			$0.navigationBar.prefersLargeTitles = true
		}
		
		guard let items = self.tabBar.items else {return}
		
		for i in 0..<items.count {
			items[i].title = titles[i]
			items[i].image = icons[i]
		}
		
		let tabbarAppearance = UITabBarAppearance()
		tabbarAppearance.configureWithOpaqueBackground()
		tabbarAppearance.backgroundColor = .black
		tabBar.standardAppearance = tabbarAppearance
		tabBar.scrollEdgeAppearance = tabbarAppearance
	}
}

//tabBar.tintColor = .white
//tabBar.barTintColor = .white
//tabBar.backgroundColor = .black
//
//let tabbarAppearance = UITabBarAppearance()
//tabbarAppearance.configureWithOpaqueBackground()
//tabbarAppearance.backgroundColor = .black
//tabBar.standardAppearance = tabbarAppearance
//tabBar.scrollEdgeAppearance = tabbarAppearance
