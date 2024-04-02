//
//  SearchTarget.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 02.04.2024.
//

import Foundation
import Moya

enum SearchTarget {
	case search(query: String)
}

extension SearchTarget: BaseTargetType {
	var baseURL: URL {
		return URL(string: GlobalConstants.apiBaseUrl)!
	}
	
	var path: String {
		switch self {
		case .search:
			return "/v1/search"
		}
	}
	
	var task: Moya.Task {
		switch self {
		case .search(let query):
			return .requestParameters(
				parameters: [
					"q": query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
					"type": "track"
				],
				encoding: URLEncoding.default
			)
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
