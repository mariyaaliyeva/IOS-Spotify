//
//  AuthRepository.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 16.03.2024.
//

import Foundation
import SwiftKeychainWrapper

class AuthRepository: AuthRepositoryProtocol {
	
	private enum Constants {
		static var accessTokenKey = "accessToken"
		static var refreshTokenKey = "refreshToken"
	}
	
	private var keychainWrapper: KeychainWrapper = .standard
	
	func save(accessToken: String) {
		keychainWrapper.set(accessToken, forKey: Constants.accessTokenKey)
	}
	
	func getAccessToken() -> String? {
		keychainWrapper.string(forKey: Constants.accessTokenKey)
	}
	
	func removeAccessToken() {
		keychainWrapper.removeObject(forKey: Constants.accessTokenKey)
	}
	
	func save(refreshToken: String) {
		keychainWrapper.set(refreshToken, forKey: Constants.refreshTokenKey)
	}
	
	func getRefreshToken() -> String? {
		keychainWrapper.string(forKey: Constants.refreshTokenKey)
	}
	
	func removeRefreshToken() {
		keychainWrapper.removeObject(forKey: Constants.refreshTokenKey)
	}
	
	func removeAllTokens() {
		keychainWrapper.removeObject(forKey: Constants.accessTokenKey)
		keychainWrapper.removeObject(forKey: Constants.refreshTokenKey)
	}
}
