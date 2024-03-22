//
//  Playlist.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 06.03.2024.
//

import Foundation

// MARK: - Playlist
struct Playlist: Codable {
	let albums: Albums
}

// MARK: - Albums
struct Albums: Codable {
	let items: [PlaylistDataModel]
}

// MARK: - Item
struct PlaylistDataModel: Codable {
	let albumType: String?
	let totalTracks: Int?
	let availableMarkets: [String]
	let id: String?
	let images: [Image]?
	let name, releaseDate: String?
	let type: String?
	let artists: [Artist]
	
	enum CodingKeys: String, CodingKey {
		case albumType = "album_type"
		case totalTracks = "total_tracks"
		case availableMarkets = "available_markets"
		case id, images, name
		case releaseDate = "release_date"
		case type, artists
	}
}

// MARK: - Artist
struct Artist: Codable {
	let externalUrls: ExternalUrls
	let href, id, name, type: String
	let uri: String
	
	enum CodingKeys: String, CodingKey {
		case externalUrls = "external_urls"
		case href, id, name, type, uri
	}
}

// MARK: - ExternalUrls
struct ExternalUrls: Codable {
	let spotify: String
}

// MARK: - Restrictions
struct Restrictions: Codable {
	let reason: String
}
