//
//  AlbumsManager.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 07.03.2024.
//

import Foundation
import Moya

final class AlbumsManager {
	
	static let shared = AlbumsManager()
	
	private let provider = MoyaProvider<AlbumsTargetType>(
		plugins: [
			NetworkLoggerPlugin(configuration: NetworkLoggerPluginConfig.prettyLogging),
			LoggerPlugin()
		]
	)
	
	func getNewRelesedPlaylists(completion: @escaping (APIResult<[PlaylistDataModel]>) -> ()) {
		provider.request(.getNewReasedPlaylists) { result in
			switch result {
			case .success(let response):
				guard let playlist = try? JSONDecoder().decode(Playlist.self, from: response.data) else {	completion(.failure(.incorrectJson))
					return }
				completion(.success(playlist.albums.items))
			case .failure(_):
				completion(.failure(.unknown))
			}
		}
	}
	
	func getFeaturedPlaylists(completion: @escaping (APIResult<[Playlists]>) -> ()) {
		provider.request(.getFeaturedPlaylists) { result in
			switch result {
			case .success(let response):
				guard let playlist = try? JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: response.data) else {	completion(.failure(.incorrectJson))
					return }
				completion(.success((playlist.playlists.items)))
			case .failure(_):
				completion(.failure(.unknown))
			}
		}
	}
	
	func getRecommendations(genres: String, completion: @escaping (APIResult<[Track]>) -> ()) {
		provider.request(.getRecommendations(genres: genres)) { result in
			switch result {
			case .success(let response):
				guard let recomended = try? JSONDecoder().decode(RecommendedDataModel.self, from: response.data) else {	completion(.failure(.incorrectJson))
					return }
				completion(.success(recomended.tracks))
			case .failure(_):
				completion(.failure(.unknown))
			}
		}
	}
	
	func getRecommendedGenres(completion: @escaping (APIResult<[String]>) -> ()) {
		provider.request(.getRecommendedGenres) { result in
			switch result {
			case .success(let response):
				guard	let genres = try? JSONDecoder().decode(RecommendedGenresResponse.self, from: response.data) else {	completion(.failure(.incorrectJson))
					return }
				completion(.success(genres.genres))
			case .failure(_):
				completion(.failure(.unknown))
			}
		}
	}
	
	func getAlbumDetail(albumsID: String, completion: @escaping (APIResult<AlbumDetail>) -> ()) {
		provider.request(.getAlbumDetail(albumID: albumsID)) { result in
			switch result {
			case .success(let response):
				guard let albums = try? JSONDecoder().decode(AlbumDetail.self, from: response.data) else {	completion(.failure(.incorrectJson))
					return }
				completion(.success(albums))
			case .failure(_):
				completion(.failure(.unknown))
			}
		}
	}
	
	func getPlaylists(playlistID: String, completion: @escaping (APIResult<PlaylistDetailsResponse>) -> ()) {
		provider.request(.getPlaylists(playlistID: playlistID)) { result in
			switch result {
			case .success(let response):
				guard let playlists = try? JSONDecoder().decode(PlaylistDetailsResponse.self, from: response.data) else {	completion(.failure(.incorrectJson))
					return }
				completion(.success(playlists))
			case .failure(_):
				completion(.failure(.unknown))
			}
		}
	}
}

