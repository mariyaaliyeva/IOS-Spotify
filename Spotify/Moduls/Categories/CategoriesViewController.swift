//
//  CategoriesViewController.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 31.03.2024.
//

import UIKit

final class CategoriesViewController: BaseViewController {

	var titleOfCategory: String?
	var iD: String?
	
	private lazy var categories: [Playlists] = [] {
		didSet {
			self.collectionView.reloadData()
		}
	}
	
	// MARK: - UI
	
	private lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 12
		layout.headerReferenceSize = CGSize(width: view.frame.size.width, height: 60)
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.register(DetailCategoryTableViewCell.self, forCellWithReuseIdentifier: DetailCategoryTableViewCell.reuseId)
		collectionView.backgroundColor = .black
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.showsVerticalScrollIndicator = false
		return collectionView
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		load()
		setupViews()
		setupConstraints()
	}
	
	// MARK: - SetupViews
	
	private func setupViews() {
		title = titleOfCategory
		navigationItem.setBackBarItem()
		self.navigationItem.backBarButtonItem?.tintColor = .white
		view.backgroundColor = .black
		[collectionView].forEach {
			view.addSubview($0)
		}
	}
	
	// MARK: - SetupConstraints
	
	private func setupConstraints() {
		collectionView.snp.makeConstraints { make in
			make.top.bottom.equalTo(view.safeAreaLayoutGuide)
			make.leading.trailing.equalToSuperview()
		}
	}
	
	func load() {
		CategoryManager.shared.getCategoryPlaylist(categoryId: iD ?? "") { [weak self] response in
			switch response {
			case .success(let result):
				self?.categories = result
			case .failure(_):
				break
			}
		}
	}
}

extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return categories.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCategoryTableViewCell.reuseId, for: indexPath) as! DetailCategoryTableViewCell
		cell.configure(with: categories[indexPath.row])
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		CGSize(
				width: (collectionView.frame.size.width / 2) - 6,
				height: 200
		)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let viewController = AlbumDetailViewController()
		viewController.navigationItem.largeTitleDisplayMode = .never
		viewController.hidesBottomBarWhenPushed = true
		viewController.playlistId = categories[indexPath.row].id
		viewController.title =  categories[indexPath.row].name
		self.navigationController?.pushViewController(viewController, animated: true)
	}
}

