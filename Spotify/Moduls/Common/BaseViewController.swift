//
//  BaseViewController.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 28.02.2024.
//

import UIKit
import Lottie

class BaseViewController: UIViewController {
	
	// MARK: - UIView
	private let loadingView: LoadingView = {
		let view = LoadingView()
		view.layer.zPosition = 10
		view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
		view.alpha = 0
		view.frame = view.bounds
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		return view
	}()
	
	// MARK: - LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationBar()
		setupLoadingView()
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
		navigationBarAppearance.backgroundColor = .black
		
		navigationController?.navigationBar.standardAppearance = navigationBarAppearance
		navigationController?.navigationBar.compactAppearance = navigationBarAppearance
		navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
	}
	
	// MARK: - Methods
	func showLoader() {
		DispatchQueue.main.async { [weak self] in
			self?.loadingView.startLoading()
		}
	}
	
	func hideLoader() {
		DispatchQueue.main.async { [weak self] in
			self?.loadingView.stopLoading()
		}
	}
	
	// MARK: - Private methods
	private func setupLoadingView() {
		view.addSubview(loadingView)
		
		loadingView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
}
