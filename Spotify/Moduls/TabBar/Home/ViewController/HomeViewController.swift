//
//  HomeViewController.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 13.02.2024.
//

import UIKit

final class HomeViewController: UIViewController {
	
	var viewModel: MainViewModel?
	
	private var models = [CellModel]()
	private var category = Category.allCases
	
	// MARK: - UI
	
	private lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.separatorStyle = .none
		tableView.backgroundColor = .black
		tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: "CollectionTableViewCell")
		tableView.register(
			RecomendedMusicTableViewCell.self,
			forCellReuseIdentifier: "RecomendedMusicTableViewCell"
		)
		return tableView
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
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "settings_icon"),
			style: .done,
			target: self,
			action: #selector(barButtonTapped))
		navigationController?.navigationBar.tintColor = .white
		
		let backButton = UIBarButtonItem(title: "HOME", style: .plain, target: self, action: nil)
		backButton.setTitleTextAttributes([.font: UIFont(name: "Inter-Bold", size: 30)!], for: .normal)
		navigationItem.leftBarButtonItem = backButton
		navigationController?.navigationBar.tintColor = .white
		
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
	}

	// MARK: - Button action
	@objc func barButtonTapped() {
		print("Settings")
	}

	// MARK: - Private
	
	private func setupViewModel() {
		viewModel = MainViewModel()
		viewModel?.fetch(completion: {
			self.tableView.reloadData()
		})
	}
	
	// MARK: - SetupViews
	private func setupViews() {
		view.backgroundColor = .black
		view.addSubview(tableView)
	}
	
	// MARK: - SetupConstraints
	private func setupConstraints() {
		tableView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.leading.trailing.bottom.equalToSuperview()
		}
	}
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return category[section].rawValue
	}
	
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		guard let headerView = view as? UITableViewHeaderFooterView else { return }
		headerView.textLabel?.textColor = .white
		headerView.textLabel?.font = UIFont(name: "Inter-Regular", size: 15)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel?.numberOfSection ?? 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel?.numberOfRows(at: section) ?? 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		return viewModel?.getCell(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		print("Did select normal list items")
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return viewModel?.heightForRowAt(at: indexPath) ?? 1
	}
}

