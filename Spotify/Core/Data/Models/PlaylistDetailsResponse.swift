//
//  PlaylistDetailsResponse.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 18.03.2024.
//

import Foundation

struct PlaylistDetailsResponse: Codable {
	let description: String?
	let id: String
	let images: [Image]?
	let name: String?
	let tracks: PlaylistTracksResponse
}

struct PlaylistTracksResponse: Codable {
	let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
	let track: Track?
}
