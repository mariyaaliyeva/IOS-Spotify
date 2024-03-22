//
//  ProfileTargetType.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 04.03.2024.
//

import Foundation

enum ProfileTargetType {
	case getProfileInfo
}

extension ProfileTargetType: BaseTargetType {
	var baseURL: URL {
		return URL(string: GlobalConstants.apiBaseUrl)!
	}
	
	var path: String {
		return "/v1/me"
	}
	
	var headers: [String : String]? {
		var header = [String : String]()
		AuthManager.shared.withValidToken { token in
			header["Authorization"] = "Bearer \(token)"
		}
		return header
	}
}
