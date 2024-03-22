//
//  AuthTarget.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 26.02.2024.
//

import Foundation
import Moya

enum AuthTarget {
	case getAccessToken(code: String)
	case getRefreshToken(token: String)
}

extension AuthTarget: BaseTargetType {
	
	var path: String {
			return "/api/token"
	}
	
	var method: Moya.Method {
		return .post
	}
	
	var task: Moya.Task {
		switch self {
			
		case .getAccessToken(let code):
			return .requestParameters(
				parameters: [
					"grant_type": "authorization_code",
					"code": code,
					"redirect_uri": GlobalConstants.AuthApi.redirectUri
				],
				encoding: URLEncoding.default
			)
		case .getRefreshToken(let refreshToken):
			return .requestParameters(
				parameters: [
					"grant_type": "refresh_token",
					"refresh_token": refreshToken
				],
				encoding: URLEncoding.default
			)
		}
	}
	
	var headers: [String : String]? {
		var headers = [String : String]()
		
		let authString = "\(GlobalConstants.AuthApi.clientId):\(GlobalConstants.AuthApi.clientSecret)"
		guard let authData = authString.data(using: .utf8) else {
			print("Failure to get base64")
			return nil
		}
		let base64AuthString = authData.base64EncodedString()
		
		headers["Authorization"] = "Basic \(base64AuthString)"
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		return headers
	}
}
