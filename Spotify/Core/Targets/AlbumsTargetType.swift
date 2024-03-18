//
//  AlbumsTargetType.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 07.03.2024.
//

import Foundation
import Moya

enum AlbumsTargetType {
	case getNewReasedPlaylists
	case getFeaturedPlaylists
	case getRecommendations(genres: String)
	case getRecommendedGenres
	case getAlbumDetail(albumID: String)
	case getPlaylists(playlistID: String)
}

extension AlbumsTargetType: BaseTargetType {
	var baseURL: URL {
		return URL(string: GlobalConstants.apiBaseUrl)!
	}
	
	var path: String {
		switch self {
		case .getNewReasedPlaylists:
			return "/v1/browse/new-releases"
		case .getFeaturedPlaylists:
			return "/v1/browse/featured-playlists"
		case .getRecommendations:
			return "/v1/recommendations"
		case .getRecommendedGenres:
			return "/v1/recommendations/available-genre-seeds"
		case .getAlbumDetail(let albumID):
			return "v1/albums/\(albumID)"
		case .getPlaylists(let playlistID):
			return "/v1/playlists/\(playlistID)"
		}
	}
	
	var task: Moya.Task {
		switch self {
		case .getNewReasedPlaylists:
			return .requestParameters(parameters: [
				"offset": 0,
				"limit": 50
			], encoding: URLEncoding.default)
		case .getFeaturedPlaylists:
			return .requestPlain
		case .getRecommendations(let genres):
			return .requestParameters(
				parameters: ["seed_genres": genres],
				encoding: URLEncoding.default
			)
		case .getRecommendedGenres:
			return .requestPlain
		case .getAlbumDetail:
			return .requestPlain
		case .getPlaylists:
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
