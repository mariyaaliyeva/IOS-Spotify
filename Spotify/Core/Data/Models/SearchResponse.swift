//
//  SearchResponse.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 02.04.2024.
//

import Foundation

struct SearchResponse: Decodable {
	let tracks: SearchTrackResponse
}

struct SearchTrackResponse: Decodable {
	let items: [Track]
}

//struct AudioTrack: Decodable {
//	let album: FeaturedPlaylists?
//	let artists: [Artists]
//	let availableMarkets: [String]
//	let discNumber: Int?
//	let durationMs: Int?
//	let explicit: Bool
//	let externalUrls: [String: String]
//	let id: String?
//	let name: String?
//	let popularity: Int?
//	let previewUrl: String?
//	
//	enum CodingKeys: String, CodingKey {
//		case album
//		case artists
//		case availableMarkets = "available_markets"
//		case discNumber = "disc_number"
//		case durationMs = "duration_ms"
//		case explicit
//		case externalUrls = "external_urls"
//		case id
//		case name
//		case popularity
//		case previewUrl = "preview_url"
//	}
// }
