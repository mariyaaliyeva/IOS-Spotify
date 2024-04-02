//
//  SearchManager.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 02.04.2024.
//

import Foundation
import Moya

final class SearchManager {
	
	static let shared = SearchManager()
	
	private let provider = MoyaProvider<SearchTarget>(
		plugins: [
			NetworkLoggerPlugin(configuration: NetworkLoggerPluginConfig.prettyLogging),
			LoggerPlugin()
		]
	)
	
	func search(query: String, completion: @escaping (APIResult<[Track]>) -> ()) {
		provider.request(.search(query: query)) { result in
			switch result {
			case .success(let response):
				guard let dataModel = try? JSONDecoder().decode(SearchResponse.self, from: response.data) else {
					completion(.failure(.incorrectJson))
					return }
				completion(.success(dataModel.tracks.items))
			case .failure(_):
				completion(.failure(.unknown))
			}
		}
	}
}
