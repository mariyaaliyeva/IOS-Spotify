//
//  CategoryTarget.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 31.03.2024.
//

import Foundation
import Moya

enum CategoryTarget {
	case getCategories
	case getCategoryPlaylist(categoryId: String)
}

extension CategoryTarget: BaseTargetType {
	var baseURL: URL {
		return URL(string: GlobalConstants.apiBaseUrl)!
	}
	
	var path: String {
		switch self {
		case .getCategoryPlaylist(let categoryId):
			return "/v1/browse/categories/\(categoryId)/playlists"
		case .getCategories:
			return "/v1/browse/categories"
		}
	}
	
	var task: Moya.Task {
		switch self {
		case .getCategoryPlaylist:
			return .requestParameters(
				parameters: [
					"limit": 10
				],
				encoding: URLEncoding.default
			)
		case .getCategories:
			return .requestPlain
		}
	}
	
	var headers: [String : String]? {
		var header = [String : String]()
		AuthManager.shared.withValidToken { token in
			header["Authorization"] = "Bearer \(token)"
		}
		return header
	}
}
