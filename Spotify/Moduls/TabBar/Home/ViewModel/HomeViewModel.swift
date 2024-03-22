//
//  MainViewModel.swift
//  Spotify
//
//  Created by Aliyeva Mariya on 10.02.2024.
//

import UIKit

final class HomeViewModel: NSObject {
	
	private var sections = [HomeSectionType]()
	
	var numberOfSections: Int {
		return sections.count
	}
	
	func getSectionViewModel(at section: Int) -> HomeSectionType {
		return sections[section]
	}
	
	func didLoad() {
		sections.append(.newRelesedAlbums(title: "New_released_albums".localized, datamodel: []))
		sections.append(.featuredPlaylists(title: "Featured_playlists".localized, datamodel: []))
		sections.append(.recommended(title: "Recommended".localized, datamodel: []))
	}
	
	func loadNewRealisedAlbums(completion: @escaping ([PlaylistDataModel]) -> ()) {
		
		AlbumsManager.shared.getNewRelesedPlaylists { [weak self] response in
			switch response {
			case .success(let result):
				if let index = self?.sections.firstIndex(where: {
					
					if case .newRelesedAlbums = $0 {
						return true
					} else {
						return false
					}
				}) {
					self?.sections[index] = .newRelesedAlbums(title: "New_released_albums".localized, datamodel: result)
					completion(result)
				}
			case .failure(_):
				completion([])
			}
		}
	}
	
	func loadFeaturedPlaylists(completion: @escaping ([Playlists]) -> ()) {
		
		AlbumsManager.shared.getFeaturedPlaylists { [weak self] response in
			switch response {
			case .success(let result):
				
				if let index = self?.sections.firstIndex(where: {
					if case .featuredPlaylists = $0 {
						return true
					} else {
						return false
					}
				}) {
					self?.sections[index] = .featuredPlaylists(title: "Featured_playlists".localized, datamodel: result)
				}
				completion(result)
			case .failure(_):
				completion([])
			}
		}
	}
	
	func loadRecommended(completion: @escaping ([Track]) -> ()) {
		
		AlbumsManager.shared.getRecommendedGenres { [weak self] response in
			switch response {
			case .success(let genres):
				var seeds = Set<String>()
				while seeds.count < 5 {
					if let random = genres.randomElement() {
						seeds.insert(random)
					}
				}
				let seedsGenres = seeds.joined(separator: ",")
				
				AlbumsManager.shared.getRecommendations(genres: seedsGenres) { [weak self] response in
					
					switch response {
					case .success(let result):
						if let index = self?.sections.firstIndex(where: {
							if case .recommended = $0 {
								return true
							} else {
								return false
							}
						}) {
							self?.sections[index] = .recommended(title: "Recommended".localized, datamodel: result)
							completion(result)
						}
					case .failure(_):
						completion([])
					}
				}
			case .failure(let error):
				print(error)
			}
		}
	}
}


	
