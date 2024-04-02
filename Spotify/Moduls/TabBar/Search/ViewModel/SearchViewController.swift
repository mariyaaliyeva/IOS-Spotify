//
//  SearchViewController.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 14.02.2024.
//

import UIKit

final class SearchViewController: BaseViewController {
	
	// MARK: - Props
	
	var timer: Timer?
	private lazy var categories: [Item] = [] {
		didSet {
			self.collectionView.reloadData()
		}
	}
	
	// MARK: - UI
	
	private lazy var searchViewController: UISearchController = {
		let searchVC = UISearchController(searchResultsController: SearchResultsViewController())
		searchVC.searchBar.placeholder = "What do you want to listen to?"
		searchVC.searchBar.searchBarStyle = .minimal
		searchVC.definesPresentationContext = true
		searchVC.searchBar.searchTextField.backgroundColor = .white
		searchVC.searchResultsUpdater = self
		return searchVC
	}()
	
	private lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 12
		layout.headerReferenceSize = CGSize(width: view.frame.size.width, height: 60)
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: CategoriesCollectionViewCell.identifier)
		collectionView.register(
				SectionHeader.self,
				forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
				withReuseIdentifier: "SectionHeader"
		)
		collectionView.backgroundColor = .black
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.showsVerticalScrollIndicator = false
		return collectionView
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationBar()
		setupViews()
		setupConstraints()
		loadCategories()
	}
	
	func loadCategories() {
		CategoryManager.shared.getCategories { response in
			switch response {
			case .success(let result):
				self.categories = result.categories?.items ?? []
			case .failure(_):
				break
			}
		}
	}
	// MARK: - SetupNavigationBar
	
	private func setupNavigationBar() {
		title = "Search".localized
		navigationItem.searchController = searchViewController
		navigationItem.setBackBarItem()
		self.navigationItem.backBarButtonItem?.tintColor = .white
	}
	
	// MARK: - SetupViews
	private func setupViews() {
		view.backgroundColor = .black
		view.addSubview(collectionView)
	}
	
	// MARK: - SetupConstraints
	
	private func setupConstraints() {
		collectionView.snp.makeConstraints { make in
			make.top.bottom.equalTo(view.safeAreaLayoutGuide)
			make.leading.trailing.equalToSuperview().inset(16)
		}
	}
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
	
	func updateSearchResults(for searchController: UISearchController) {
		guard
			let resultsViewController = searchViewController.searchResultsController as?
				SearchResultsViewController,
			let text = searchController.searchBar.text,
			!text.trimmingCharacters(in: .whitespaces).isEmpty
		else {
			return
		}
		
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { _ in
			SearchManager.shared.search(query: text) { result in
					switch result {
					case .success(let tracks):
							resultsViewController.update(with: tracks)
					case .failure(_):
							break
					}
			}
		})
	}
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return categories.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as! CategoriesCollectionViewCell
		cell.configure(data: categories[indexPath.row])
		return cell
	}
	
	func collectionView(
			_ collectionView: UICollectionView,
			viewForSupplementaryElementOfKind kind: String,
			at indexPath: IndexPath
	) -> UICollectionReusableView {
			let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as!SectionHeader
		header.configure(text: "Browse all")
		header.fontConfigure(font: UIFont(name: "HelveticaNeue-Bold", size: 16) ?? .systemFont(ofSize: 16))
			return header
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		CGSize(
				width: (collectionView.frame.size.width / 2) - 6,
				height: 90
		)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let categoryViewController = CategoriesViewController()
		categoryViewController.hidesBottomBarWhenPushed = true
		categoryViewController.navigationItem.largeTitleDisplayMode = .never
		categoryViewController.titleOfCategory = categories[indexPath.row].name
		categoryViewController.iD = categories[indexPath.row].id
		navigationController?.pushViewController(categoryViewController, animated: true)
	}
}
