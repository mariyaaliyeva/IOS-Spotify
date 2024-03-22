//
//  HomeSectionType.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 06.03.2024.
//

import Foundation

enum HomeSectionType {
	case newRelesedAlbums(title: String, datamodel: [PlaylistDataModel])
	case featuredPlaylists(title: String, datamodel: [Playlists])
	case recommended(title: String, datamodel: [Track])
}

