//
//  AlbumDetailViewModel.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 17.03.2024.
//

import Foundation

final class AlbumDetailViewModel: NSObject {
	
	func getAlbumDetail(albumsID: String, completion: @escaping (APIResult<AlbumDetail>) -> Void) {
		
		AlbumsManager.shared.getAlbumDetail(albumsID: albumsID) { [weak self] response in
			
			switch response {
			case .success(let result):
				completion(.success(result))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	func getPlaylists(playlistID: String, completion: @escaping (APIResult<PlaylistDetailsResponse>) -> Void) {
		
		AlbumsManager.shared.getPlaylists(playlistID: playlistID) { [weak self] response in
			switch response {
			case .success(let result):
				completion(.success(result))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
