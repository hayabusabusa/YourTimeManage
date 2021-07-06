//
//  DebugViewController.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/07/07.
//

import Combine
import UIKit
import Shared

final class DebugViewController: UIViewController {
    
    // MARK: IBOutlet
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { [weak self] (index, _) -> NSCollectionLayoutSection? in
            return self?.sections[index].layoutSection()
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    // MARK: Properties
    
    private var viewModel: DebugViewModelType!
    private var cancelables = Set<AnyCancellable>()
    
    private var sections: [DebugSection] = []
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubViews()
        configureCollectionView()
        bindViewModel()
        viewModel.inputs.viewDidLoad()
    }
}

// MARK: - Configure

extension DebugViewController {
    
    private func configureSubViews() {
        view.backgroundColor = .systemBackground
        collectionView.embed(in: view)
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.register(DebugCell.self)
    }
    
    private func bindViewModel() {
        viewModel = DebugViewModel()
        
        viewModel.outpus.error
            .sink { [weak self] message in
                let ac = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(ac, animated: true, completion: nil)
            }
            .store(in: &cancelables)
        viewModel.outpus.sections
            .sink { [weak self] sections in
                self?.sections = sections
                self?.collectionView.reloadData()
            }
            .store(in: &cancelables)
        viewModel.outpus.isMigrationCompleted
            .sink { [weak self] _ in
                let ac = UIAlertController(title: "", message: "マイグレーションが完了", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(ac, animated: true, completion: nil)
            }
            .store(in: &cancelables)
    }
}

// MARK: - CollectionView DataSource

extension DebugViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return sections[indexPath.section].configureCell(collectionView, at: indexPath)
    }
}
