//
//  RecomendedMusicData.swift
//  Spotify
//
//  Created by Aliyeva Mariya on 10.02.2024.
//

import UIKit

enum CellModel {
	case collectionView(models: [CollectionTableCellModel], rows: Int)
	case list(models: [RecomendedMusicData])
}

struct RecomendedMusicData {
	let title: String
	let subtitle: String?
	let image: UIImage
}

struct CollectionTableCellModel {
	let title: String
	let imageName: String
}

enum Category: String, CaseIterable {
	case new = "New Released Albums"
	case feature = "Featured Playlists"
	case recomended = "Recommended"
}
