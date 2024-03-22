//
//  AuthViewModel.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 24.02.2024.
//

import Foundation

final class AuthViewModel {
	
	func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void) {
		
		AuthManager.shared.exchangeCodeForToken(code: code) { result in
			switch result {
			case .success():
				completion(true)
			case .failure(_):
				completion(false)
			}
		}
	}
}
