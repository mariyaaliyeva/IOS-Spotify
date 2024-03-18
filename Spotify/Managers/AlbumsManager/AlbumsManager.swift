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
	
	func getNewRelesedPlaylists(completion: @escaping (APIResult<[PlaylistDataModel]>) -> Void) {
		provider.request(.getNewReasedPlaylists) { result in
			switch result {
			case .success(let response):
				do {
					let playlist = try JSONDecoder().decode(Playlist.self, from: response.data)
					completion(.success(playlist.albums.items))
				} catch {
					completion(.failure(.unknown))
				}
			case .failure(_):
				completion(.failure(.networkFail))
			}
		}
	}
	
	func getFeaturedPlaylists(completion: @escaping (APIResult<[Playlists]>) -> Void) {
		provider.request(.getFeaturedPlaylists) { result in
			switch result {
			case .success(let response):
				do {
					let playlist = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: response.data)
					completion(.success((playlist.playlists?.items)!))
				} catch {
					completion(.failure(.unknown))
				}
			case .failure(_):
				completion(.failure(.networkFail))
			}
		}
	}
	
	func getRecommendations(genres: String, completion: @escaping (APIResult<[Track]>) -> ()) {
		provider.request(.getRecommendations(genres: genres)) { result in
			switch result {
			case .success(let response):
				do {
					let recomended = try JSONDecoder().decode(RecommendedDataModel.self, from: response.data)
					completion(.success(recomended.tracks))
				} catch {
					completion(.failure(.incorrectJson))
				}
			case .failure(_):
				completion(.failure(.unknown))
			}
		}
	}
	
	func getRecommendedGenres(completion: @escaping (APIResult<[String]>) -> ()) {
		provider.request(.getRecommendedGenres) { result in
			switch result {
			case .success(let response):
				do {
					let genres = try JSONDecoder().decode(RecommendedGenresResponse.self, from: response.data)
					completion(.success(genres.genres))
				} catch {
					completion(.failure(.incorrectJson))
				}
			case .failure(_):
				completion(.failure(.unknown))
			}
		}
	}
	
	func getAlbumDetail(albumsID: String, completion: @escaping (APIResult<AlbumDetail>) -> Void) {
		provider.request(.getAlbumDetail(albumID: albumsID)) { result in
			switch result {
			case .success(let response):
				do {
					let albums = try JSONDecoder().decode(AlbumDetail.self, from: response.data)
					completion(.success(albums))
				} catch {
					completion(.failure(.unknown))
				}
			case .failure(_):
				completion(.failure(.networkFail))
			}
		}
	}
	
	func getPlaylists(playlistID: String, completion: @escaping (APIResult<PlaylistDetailsResponse>) -> Void) {
		provider.request(.getPlaylists(playlistID: playlistID)) { result in
			switch result {
			case .success(let response):
				do {
					let playlists = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: response.data)
					completion(.success(playlists))
				} catch {
					completion(.failure(.unknown))
				}
			case .failure(_):
				completion(.failure(.networkFail))
			}
		}
	}
}

