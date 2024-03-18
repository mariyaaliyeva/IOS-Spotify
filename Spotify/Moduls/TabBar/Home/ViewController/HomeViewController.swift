//
//  HomeViewController.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 13.02.2024.
//

import UIKit
import SkeletonView

final class HomeViewController: BaseViewController {
	
	// MARK: - Properties
	
	var viewModel: HomeViewModel?

	// MARK: - UI
	private lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewCompositionalLayout { sectionIndex, _ ->
			NSCollectionLayoutSection? in
			self.createCollectionLayout(section: sectionIndex)
		}
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.backgroundColor = .clear
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(
			  SectionHeader.self,
				forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
				withReuseIdentifier: "SectionHeader"
		)
		collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
		collectionView.register(RecomendedCollectionViewCell.self, forCellWithReuseIdentifier: "RecomendedCollectionViewCell")
		collectionView.isSkeletonable = true
		return collectionView
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationBar()
		setupViews()
		setupConstraints()
		setupViewModel()
	}

	// MARK: - Navigation bar
	
	private func setupNavigationBar() {
		
		title = "Home".localized
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.largeTitleDisplayMode = .automatic
		
		navigationItem.setBackBarItem()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "settings_icon"),
			style: .done,
			target: self,
			action: #selector(barButtonTapped))
		navigationController?.navigationBar.tintColor = .white
	}
	
	// MARK: - Button action
	
	@objc func barButtonTapped() {
		let controller = SettingsViewController()
		controller.title = "Settings"
		controller.navigationItem.setBackBarItem()
		controller.navigationItem.largeTitleDisplayMode = .never
		controller.hidesBottomBarWhenPushed = true
		controller.navigationItem.backButtonTitle = " "
		navigationController?.pushViewController(controller, animated: true)
	}
	
	// MARK: - SetupViewModel()
	
	private func setupViewModel() {
		viewModel = HomeViewModel()
		collectionView.showAnimatedGradientSkeleton(
			usingGradient: .init(baseColor: .skeletonDefault),
			animation: nil,
			transition: .crossDissolve(0.25))
		viewModel?.didLoad()
		
		let group = DispatchGroup()
		
		group.enter()
		self.viewModel?.loadNewRealisedAlbums(completion: { [weak self] result in
			group.leave()
		})
		
		group.enter()
		self.viewModel?.loadFeaturedPlaylists(completion: { [weak self] result  in
			group.leave()
		})

		group.enter()
		self.viewModel?.loadRecommended(completion: { [weak self] result in
			group.leave()
		})

		group.notify(queue: .main) {
			DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
				self.collectionView.stopSkeletonAnimation()
				self.collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
				self.collectionView.reloadData()
			}
		}
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
			make.leading.trailing.equalToSuperview()
		}
	}
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return viewModel?.numberOfSections ?? 1
	}
	
	func collectionView(
			_ collectionView: UICollectionView,
			viewForSupplementaryElementOfKind kind: String,
			at indexPath: IndexPath
	) -> UICollectionReusableView {
			let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as!SectionHeader
			
			let type = viewModel?.getSectionViewModel(at: indexPath.section)
			
			switch type {
			case .newRelesedAlbums(let title, _):
					header.configure(text: title)
			case .featuredPlaylists(let title, _):
					header.configure(text: title)
			case .recommended(let title, _):
					header.configure(text: title)
			default:
					break
			}
			
			return header
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let type = viewModel?.getSectionViewModel(at: section)
		switch type {
		case .newRelesedAlbums(_, let dataModel):
			return dataModel.count
		case .featuredPlaylists(_, let dataModel):
			return dataModel.count
		case .recommended(_, let dataModel):
			return dataModel.count
		default:
				return 1
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let type = viewModel?.getSectionViewModel(at: indexPath.section)
		switch type  {
		case .newRelesedAlbums(_, let datamodel):
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
			cell.configure(with: datamodel[indexPath.row])
			return cell
		case .featuredPlaylists(_, let datamodel):
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
			cell.configure(with: datamodel[indexPath.row])
			return cell
			
		case .recommended(_, let datamodel):
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecomendedCollectionViewCell", for: indexPath) as! RecomendedCollectionViewCell
			cell.configure(data: datamodel[indexPath.row])
			return cell
		default:
				return UICollectionViewCell()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let type = viewModel?.getSectionViewModel(at: indexPath.section)
		
		switch type {
		case .newRelesedAlbums(_, let dataModel):
			let album = dataModel[indexPath.row]
			let viewController = AlbumDetailViewController()
			viewController.albumId = album.id
			viewController.isAlbumDetail = true
			self.navigationController?.pushViewController(viewController, animated: true)
		case .featuredPlaylists(_, let dataModel):
			let featuredAlbum = dataModel[indexPath.row]
			let viewController = AlbumDetailViewController()
			viewController.playlistId = featuredAlbum.id
			self.navigationController?.pushViewController(viewController, animated: true)
		case .recommended(_, let dataModel):
			break
		default:
			break
		}
	}
}

// MARK: - SkeletonCollectionViewDataSource

extension HomeViewController: SkeletonCollectionViewDataSource {
	
	func numSections(in collectionSkeletonView: UICollectionView) -> Int {
			return viewModel?.numberOfSections ?? 1
	}
	
	func collectionSkeletonView(
			_ skeletonView: UICollectionView,
			numberOfItemsInSection section: Int
	) -> Int {
			let type = viewModel?.getSectionViewModel(at: section)
			
			switch type {
			case .newRelesedAlbums:
					return 3
			case .featuredPlaylists:
					return 3
			case .recommended:
					return 4
			default:
					return 1
			}
	}
	
	func collectionSkeletonView(
			_ skeletonView: UICollectionView,
			cellIdentifierForItemAt indexPath: IndexPath
	) -> SkeletonView.ReusableCellIdentifier {
			let type = viewModel?.getSectionViewModel(at: indexPath.section)
			
			switch type {
			case .newRelesedAlbums:
					return "CustomCollectionViewCell"
			case .featuredPlaylists:
					return "CustomCollectionViewCell"
			case .recommended:
					return "RecomendedCollectionViewCell"
			default:
					return ""
			}
	}
}

// MARK: - CreateCollectionLayout

extension HomeViewController {
	
	private func createCollectionLayout(section: Int) -> NSCollectionLayoutSection {
		
		switch section {
		case 0:
			// Item
			let itemSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalHeight(1.0))
			
			let item = NSCollectionLayoutItem(layoutSize: itemSize)
			item.contentInsets = .init(top: 2, leading: 4, bottom: 2, trailing: 4)
			// Group
			
			let horizontalGroup = NSCollectionLayoutGroup.horizontal (
				layoutSize: NSCollectionLayoutSize(
					widthDimension: .absolute(168),
					heightDimension: .absolute(220)
				),
				subitem: item,
				count: 1)
			// Section
			
			let section = NSCollectionLayoutSection(group: horizontalGroup)
			section.orthogonalScrollingBehavior = .continuous
			section.contentInsets = .init(top: 8, leading: 16, bottom: 4, trailing: 16)
			section.boundarySupplementaryItems = [
				.init(layoutSize: .init(widthDimension: .fractionalWidth(1),
																heightDimension: .estimated(60)),
							elementKind: UICollectionView.elementKindSectionHeader,
							alignment: .top
				)
			]
			return section
		case 1:
			// Item
			let itemSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalHeight(1.0))
			
			let item = NSCollectionLayoutItem(layoutSize: itemSize)
			item.contentInsets = .init(top: 2, leading: 4, bottom: 2, trailing: 4)
			// Group
			
			let horizontalGroup = NSCollectionLayoutGroup.horizontal (
				layoutSize: NSCollectionLayoutSize(
					widthDimension: .absolute(168),
					heightDimension: .absolute(220)
				),
				subitem: item,
				count: 1)
			// Section
			
			let section = NSCollectionLayoutSection(group: horizontalGroup)
			section.orthogonalScrollingBehavior = .continuous
			section.contentInsets = .init(top: 4, leading: 16, bottom: 4, trailing: 16)
			section.boundarySupplementaryItems = [
				.init(layoutSize: .init(widthDimension: .fractionalWidth(1),
																heightDimension: .estimated(60)),
							elementKind: UICollectionView.elementKindSectionHeader,
							alignment: .top
				)
			]
			return section
		case 2:
			// Item
			let itemSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalHeight(1.0))
			
			let item = NSCollectionLayoutItem(layoutSize: itemSize)
			item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
			// Group
			
			let verticalGroup = NSCollectionLayoutGroup.vertical(
				layoutSize: NSCollectionLayoutSize(
					widthDimension: .fractionalWidth(1.0),
					heightDimension: .absolute(70)
				),
				subitem: item,
				count: 1)
			// Section
			
			let section = NSCollectionLayoutSection(group: verticalGroup)
			section.contentInsets = .init(top: 4, leading: 16, bottom: 4, trailing: 16)
			section.boundarySupplementaryItems = [
					.init(layoutSize: .init(widthDimension: .fractionalWidth(1),
																	heightDimension: .estimated(60)),
								elementKind: UICollectionView.elementKindSectionHeader,
								alignment: .top
					)
			]
			return section
		default:
			// Item
			let itemSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalHeight(1.0))
			
			let item = NSCollectionLayoutItem(layoutSize: itemSize)
			item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
			// Group
			
			let verticalGroup = NSCollectionLayoutGroup.vertical(
				layoutSize: NSCollectionLayoutSize(
					widthDimension: .fractionalWidth(1.0),
					heightDimension: .absolute(70)
				),
				subitem: item,
				count: 1)
			// Section
			
			let section = NSCollectionLayoutSection(group: verticalGroup)
			section.contentInsets = .init(top: 4, leading: 16, bottom: 16, trailing: 16)
			return section
		}
	}
}

//0S4pP8MBY9p7ngFWIZQAJv
