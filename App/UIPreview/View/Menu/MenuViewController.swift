//
//  MenuViewController.swift
//  App
//
//  Created by Shunya Yamada on 2022/03/31.
//

import UIKit

final class MenuViewController: UIViewController {
    
    // MARK: Subview
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = configureCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: String(describing: MenuCell.self))
        return collectionView
    }()
    
    // MARK: Property
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> = {
        return UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MenuCell.self), for: indexPath) as! MenuCell
            cell.configure(with: item.title, iconImage: item.iconImage)
            return cell
        })
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureSubviews()
        configureDataSource()
    }
}

// MARK: - Configuration

private extension MenuViewController {
    
    func configureNavigation() {
        navigationItem.title = "UI Preview"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureSubviews() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    func configureDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.all])
        snapshot.appendItems(Item.allCases, toSection: .all)
        dataSource.apply(snapshot)
    }
    
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
}

// MARK: - CollectionView Delegate

extension MenuViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        navigationController?.pushViewController(item.destination, animated: true)
    }
}
