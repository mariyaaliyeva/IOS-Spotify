//
//  GlobalConstants.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 27.02.2024.
//

import Foundation

enum GlobalConstants {
	static let baseURL = "https://accounts.spotify.com"
	static let apiBaseUrl = "https://api.spotify.com"
	
	enum AuthApi {
		static let clientId = "2f840d4f818247b4b5badfa7295856ec"
		static let clientSecret = "d333907cad5441178283782bb89c20c8"
		static let redirectUri = "https://open.spotify.com/"
		static let scopes = Scopes.allScopes.joined(separator: "%20")
	}
	
	enum Scopes {
		static let userReadPlaybackState = "user-read-playback-state"
		static let playlistModifyPublic = "playlist-modify-public"
		static let playlistModifyPrivate = "playlist-modify-private"
		static let userFollowRead = "user-follow-read"
		static let userLibraryModify = "user-library-modify"
		static let userReadEmail = "user-read-email"
		
		static let allScopes = [
			userReadPlaybackState,
			playlistModifyPublic,
			playlistModifyPrivate,
			userFollowRead,
			userLibraryModify,
			userReadEmail
		]
	}
}
