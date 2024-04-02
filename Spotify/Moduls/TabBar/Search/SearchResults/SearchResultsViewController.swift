//
//  SearchResultsViewController.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 30.03.2024.
//

import UIKit

final class SearchResultsViewController: UIViewController {
	
	// MARK: - Props
	
	private var tracks = [Track]()
	
	// MARK: - UI
	
	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: "SearchResultsTableViewCell")
		return tableView
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .clear
		
		view.addSubview(tableView)
		tableView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
	
	func update(with tracks: [Track]) {
		self.tracks = tracks
		tableView.reloadData()
	}
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		tracks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SearchResultsTableViewCell
		let track = tracks[indexPath.row]
		cell.configure(data: track)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let albums = tracks[indexPath.row]
		let playerViewController = PlayerViewController()
		playerViewController.track = albums
		playerViewController.albumImageUrl =  URL(string: albums.album?.images?.first?.url ?? "")
		playerViewController.modalPresentationStyle = .overFullScreen
		present(playerViewController, animated: true)
	}
}
