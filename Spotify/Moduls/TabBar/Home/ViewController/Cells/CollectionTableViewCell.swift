//
//  CollectionTableViewCell.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 13.02.2024.
//

import UIKit

final class CollectionTableViewCell: UITableViewCell {
	
	static var reuseId = String(describing: CollectionTableViewCell.self)
	
	// MARK: - Consraints
	private enum Consraints {
		static let collectionViewHeight: CGFloat = 220
		static let collectionItemWidth: CGFloat = 168
		static let collectionItemTop: CGFloat = 20
	}
	
	// MARK: - Props
	private var models = [CollectionTableCellModel]()
	
	// MARK: - UI
	lazy var albumsCollectionView: UICollectionView = {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.itemSize = CGSize(width: Consraints.collectionItemWidth, height: Consraints.collectionViewHeight)
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.backgroundColor = .black
		collectionView.dataSource = self
		collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.reuseId)
		return collectionView
	}()
	
	// MARK: - Lifecycle
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Public
	public func configure(with models: [CollectionTableCellModel]) {
		self.models = models
		albumsCollectionView.reloadData()
	}
	
	// MARK: - Setup Views
	private func setupViews() {
		contentView.backgroundColor = .black
		contentView.addSubview(albumsCollectionView)
	}
	
	// MARK: - Setup Constraints
	private func setupConstraints() {
		albumsCollectionView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(Consraints.collectionItemTop)
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(Consraints.collectionViewHeight)
		}
	}
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension CollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return models.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let model = models[indexPath.row]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.reuseId, for: indexPath) as! CustomCollectionViewCell
		cell.configure(with: model)
		return cell
	}
}


