//
//  MainViewModel.swift
//  Spotify
//
//  Created by Aliyeva Mariya on 10.02.2024.
//

import UIKit
 
final class MainViewModel: NSObject {
	
	var models: [CellModel] = []
	
	var numberOfSection: Int {
		return models.count
	}
	
	func numberOfRows(at section: Int) -> Int {
		switch models[section] {
			
		case .collectionView(models: _, rows: _):
			return 1
		case .list(models: let models):
			return models.count
		}
	}
	
	func getCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch models[indexPath.section] {
			
		case .collectionView(models: let models, rows: _):
			let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.reuseId, for: indexPath) as! CollectionTableViewCell
			cell.configure(with: models)
			return cell
		case .list(models: let models):
			let cell = tableView.dequeueReusableCell(withIdentifier: "RecomendedMusicTableViewCell", for: indexPath) as! RecomendedMusicTableViewCell
			cell.configure(data: models[indexPath.row])
			return cell
		}
	}
	
	func  heightForRowAt(at indexPath: IndexPath) -> CGFloat {
		switch models[indexPath.section] {
			
		case .collectionView(models: _, rows: let rows):
			return 220 * CGFloat(rows)
		case .list(models: _):
			return 64
		}
	}
	
	func fetch(completion: () -> ()) {
		var models: [CellModel] = []
		
		models.append(.collectionView(models: [
			.init(title: "Anand Bakshi: The Lyricist Who Made…", imageName: "album1"),
			.init(title: "E123: Sankar Bora (Co-founder & CO…", imageName: "album2"),
			.init(title: "Anand Bakshi: The Lyricist Who Made…", imageName: "album1"),
			.init(title: "E123: Sankar Bora (Co-founder & CO…", imageName: "album2")
		], rows: 1))
		
		models.append(.collectionView(models: [
			.init(title: "Indie India", imageName: "album3"),
			.init(title: "RADAR India", imageName: "album4"),
			.init(title: "Indie India", imageName: "album3"),
			.init(title: "RADAR India", imageName: "album4")
		], rows: 1))
		
		models.append(.list(models: [
			.init(
				title: "Cozy Coffeehouse",
				subtitle: nil,
				image: UIImage(named: "music1") ?? UIImage()
			),
			.init(
				title: "Cozy",
				subtitle: "Profile",
				image: UIImage(named: "music2") ?? UIImage()
			),
			.init(
				title: "cozy clouds",
				subtitle: nil,
				image: UIImage(named: "music3") ?? UIImage()
			)
		]))
		self.models = models
		completion()
	}
}
	
