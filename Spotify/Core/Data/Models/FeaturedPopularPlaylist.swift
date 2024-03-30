//
//  FeaturedPlaylistsResponse.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 07.03.2024.
//

//   let featuredPlaylist = try? JSONDecoder().decode(FeaturedPlaylist.self, from: jsonData)

import Foundation

struct FeaturedPlaylistsResponse: Codable {
	let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable {
	let items: [Playlists]
}

struct Playlists: Codable {
	let id: String?
	let images: [Image]?
	let name: String?
	
	enum CodingKeys: String, CodingKey {
		case id, images, name
	}
}

struct User: Codable {
	let display_name: String?
	let external_urls: [String: String]?
	let id: String?
}

