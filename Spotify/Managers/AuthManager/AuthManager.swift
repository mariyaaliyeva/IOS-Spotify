//
//  AuthManager.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 22.02.2024.
//

import Foundation
import SwiftKeychainWrapper
import Moya

final class AuthManager {
	
	static let shared = AuthManager()
	private let provider = MoyaProvider<AuthTarget>()
	
	struct Constants {
		static let clientId = "2f840d4f818247b4b5badfa7295856ec"
		static let clientSecret = "d333907cad5441178283782bb89c20c8"
		static let scopes = "user-read-private"
		static let redirectUri = "https://open.spotify.com/"
	}
	
	public var signInURL: URL? {
		let baseURL = "https://accounts.spotify.com/authorize"
		
		var components = URLComponents(string: baseURL)
		
		components?.queryItems = [
			URLQueryItem(name: "response_type", value: "code"),
			URLQueryItem(name: "client_id", value: Constants.clientId),
			URLQueryItem(name: "scope", value: Constants.scopes),
			URLQueryItem(name: "redirect_uri", value: Constants.redirectUri),
			URLQueryItem(name: "show_dialog", value: "TRUE")
		]
		return components?.url
	}
	
	var isSignedIn: Bool {
		return accessToken != nil
	}
	
	private init() {}
	
	private var accessToken: String? {
		return KeychainWrapper.standard.string(forKey: "accessToken")
	}
	
	private var refreshToken: String? {
		return KeychainWrapper.standard.string(forKey: "refreshToken")
	}
	
	private var tokenExpirationDate: Date? {
		return UserDefaults.standard.object(forKey: "expirationDate") as? Date
	}
	
	private var shouldRefreshToken: Bool {
		guard let tokenExpirationDate else {return false}
		let currentDate = Date()
		let fiveMinutes: TimeInterval = 300
		return currentDate.addingTimeInterval(fiveMinutes) >= tokenExpirationDate
	}
	
	func exchangeCodeForToken(
		code: String,
		completion: @escaping ((Bool) -> Void)
	){
		
		provider.request(.getAccessToken(code: code)) { [weak self] result in
			switch result {
			case .success(let response):
				guard let result = try? response.map(AuthResponse.self) else {
					completion(false)
					return
				}
				self?.cacheToken(result: result)
				completion(true)
			case .failure(let error):
				completion(false)
			}
		}
	}
	
	private func refreshIfNeeded(
		code: String,
		completion: @escaping ((Bool) -> Void)
	) {
		provider.request( .getRefreshToken(code: code)) { [weak self] result in
			switch result {
			case .success(let response):
				guard let result = try? response.map(AuthResponse.self) else {
					completion(false)
					return
				}
				self?.cacheToken(result: result)
				completion(true)
			case .failure(_):
				completion(false)
			}
		}
	}
		
	private func cacheToken(result: AuthResponse) {
		KeychainWrapper.standard.set(result.accessToken, forKey: "accessToken")
		
		if let refreshToken = result.refreshToken {
			KeychainWrapper.standard.set(refreshToken, forKey: "refreshToken")
		}
		
		UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(result.expiresIn)), forKey: "expirationDate")
	}
}
