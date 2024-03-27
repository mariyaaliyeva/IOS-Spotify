//
//  MainViewModel.swift
//  Spotify
//
//  Created by Aliyeva Mariya on 10.02.2024.
//

import UIKit

final class HomeViewModel: NSObject {
	
	private var sections = [HomeSectionType]()
	private var group = DispatchGroup()
	
	var numberOfSections: Int {
		return sections.count
	}
	
	func getSectionViewModel(at section: Int) -> HomeSectionType {
		return sections[section]
	}
	
	func didLoad(completion: @escaping () -> ()) {
		sections.append(.newRelesedAlbums(title: "New_released_albums".localized, datamodel: []))
		sections.append(.featuredPlaylists(title: "Featured_playlists".localized, datamodel: []))
		sections.append(.recommended(title: "Recommended".localized, datamodel: []))
		
		group.enter()
		loadNewRealisedAlbums(completion: { [weak self] in
			self?.group.leave()
		})
		
		group.enter()
		loadFeaturedPlaylists(completion: { [weak self] in
			self?.group.leave()
		})

		group.enter()
		loadRecommended(completion: { [weak self] in
			self?.group.leave()
		})

		group.notify(queue: .main) {
	     completion()
		}
	}
	
	func setupSectionTitles() {
		for index in 0..<sections.count {
			switch sections[index] {
			case .newRelesedAlbums(_, let dataModel):
				sections[index] = .newRelesedAlbums(title: "New_released_albums".localized, datamodel: dataModel)
			case .featuredPlaylists(_ , let datamodel):
				sections[index] = .featuredPlaylists(title: "Featured_playlists".localized, datamodel: datamodel)
			case .recommended(_, let datamodel):
				sections[index] = .recommended(title: "Recommended".localized, datamodel: datamodel)
			}
		}
	}
	
	
	private func loadNewRealisedAlbums(completion: @escaping () -> ()) {
		
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
					completion()
				}
			case .failure(_):
				completion()
			}
		}
	}
	
	private func loadFeaturedPlaylists(completion: @escaping () -> ()) {
		
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
				completion()
			case .failure(_):
				completion()
			}
		}
	}

	private func loadRecommended(completion: @escaping () -> ()) {
		
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
							completion()
						}
					case .failure(_):
						completion()
					}
				}
			case .failure(let error):
				print(error)
			}
		}
	}
}


	
