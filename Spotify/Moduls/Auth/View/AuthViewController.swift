//
//  AuthViewController.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 22.02.2024.
//

import UIKit
import WebKit

final class AuthViewController: UIViewController {
	
	// MARK: - Properties
	public var completionHandler: ((Bool) -> Void)?
	private var viewModel: AuthViewModel?
	
	// MARK: - UI
	private let webView: WKWebView = {
		let prefs = WKWebpagePreferences()
		prefs.allowsContentJavaScript = true
		let config = WKWebViewConfiguration()
		config.defaultWebpagePreferences = prefs
		let webView = WKWebView(frame: .zero, configuration: config)
		return webView
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViewModel()
		setupView()
		hundleWebUrl()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		webView.frame = view.bounds
	}
	
	// MARK: - Private methods
	
	private func setupViewModel() {
		viewModel = AuthViewModel()
	}
	
	private func hundleWebUrl() {
		guard let url = AuthManager.shared.signInURL else { return }
		webView.load(URLRequest(url: url))
	}
	
	private func setupView() {
		navigationController?.navigationBar.tintColor = .white
		navigationController?.navigationBar.barTintColor = .white
		navigationItem.title = "Sign In"
		view.backgroundColor = .systemBackground
		webView.navigationDelegate = self
		view.addSubview(webView)
	}
}

extension AuthViewController: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		// exchange the code for access token
		guard let url = webView.url else { return }
		let component = URLComponents(string: url.absoluteString)
		
		guard let code = component?.queryItems?.first(where: { $0.name == "code" })?.value else { return }
		
		webView.isHidden = true
		viewModel?.exchangeCodeForToken(code: code, completion: { [weak self] success in
			DispatchQueue.main.async {
				self?.navigationController?.popViewController(animated: true)
				self?.completionHandler?(success)
			}
		})
	}
}

