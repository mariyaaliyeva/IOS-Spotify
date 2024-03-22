//
//  ProfileManager.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 04.03.2024.
//

import Foundation
import Moya

final class ProfileManager {
	static let shared = ProfileManager()
	
	private let provider = MoyaProvider<ProfileTargetType>(
		plugins: [
			NetworkLoggerPlugin(configuration: NetworkLoggerPluginConfig.prettyLogging),
			LoggerPlugin()
		]
	)
	
	func getCurrentUserProfile(completion: @escaping (APIResult<ProfileResponse>) -> Void) {
		provider.request(.getProfileInfo) { result in
			switch result {
			case .success(let response):
				do {
					let result = try JSONDecoder().decode(ProfileResponse.self, from: response.data)
					completion(.success(result))
				} catch let error {
					print(error.localizedDescription)
					completion(.failure(.unknown))
				}
			case .failure(_):
				completion(.failure(.networkFail))
			}
		}
	}
}

