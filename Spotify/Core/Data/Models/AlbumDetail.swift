//
//  AlbumDetail.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 17.03.2024.
//
//   let albumDetail = try? JSONDecoder().decode(AlbumDetail.self, from: jsonData)

import Foundation

// MARK: - AlbumDetail

struct AlbumDetail: Codable {
		let album_type: String
		let artists: [Artist]
		let available_markets: [String]
		let external_urls: [String: String]
		let id: String
		let images: [Image]
		let label: String
		let name: String
		let tracks: TracksResponse
	  let popularity: Int?
}

struct TracksResponse: Codable {
		let items: [Track]
}

