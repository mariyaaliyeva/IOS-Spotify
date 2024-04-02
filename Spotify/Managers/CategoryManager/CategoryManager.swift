//
//  CategoryManager.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 31.03.2024.
//

import Foundation
import Moya

final class CategoryManager {
	static let shared = CategoryManager()
	
	private let provider = MoyaProvider<CategoryTarget>(
		plugins: [
			NetworkLoggerPlugin(configuration: NetworkLoggerPluginConfig.prettyLogging),
			LoggerPlugin()
		]
	)
	
	func getCategories(completion: @escaping (APIResult<Categories>) -> ()) {
		provider.request(.getCategories) { result in
			switch result {
			case .success(let response):
				guard let categories = try? JSONDecoder().decode(Categories.self, from: response.data) else {	completion(.failure(.incorrectJson))
					return }
				completion(.success(categories))
			case .failure(_):
				completion(.failure(.unknown))
			}
		}
	}
	
	func getCategoryPlaylist(categoryId: String, completion: @escaping (APIResult<[Playlists]>) -> ()) {
		provider.request(.getCategoryPlaylist(categoryId: categoryId)) { result in
			switch result {
			case .success(let response):
				guard let dataModel = try? JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: response.data) else {	completion(.failure(.incorrectJson))
					return }
				completion(.success(dataModel.playlists.items))
			case .failure(_):
				completion(.failure(.unknown))
			}
		}
	}
}
