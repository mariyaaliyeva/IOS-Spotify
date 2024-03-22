//
//  RecommendedDataModel.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 06.03.2024.
//

import Foundation

// MARK: - RecommendedDataModel
struct RecommendedDataModel: Codable {
	let tracks: [Track]
}

// MARK: - Track
struct Track: Codable {
	let album: Playlists?
	let artists: [Artist]?
	let availableMarkets: [String]?
	let discNumber, durationMS: Int?
	let href: String?
	let id, name: String?
	let popularity: Int?
	let previewURL: String?
	let trackNumber: Int?
	let isLocal: Bool?
	
	enum CodingKeys: String, CodingKey {
		case artists
		case availableMarkets = "available_markets"
		case discNumber = "disc_number"
		case durationMS = "duration_ms"
		case href, id, name, popularity
		case previewURL = "preview_url"
		case trackNumber = "track_number"
		case isLocal = "is_local"
		case album
	}
}

