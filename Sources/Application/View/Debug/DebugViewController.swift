//
//  DebugViewController.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/07/07.
//

import Combine
import UIKit
import UIComponent
import Shared

public final class DebugViewController: UIViewController {
    
    // MARK: IBOutlet
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { [weak self] (index, _) -> NSCollectionLayoutSection? in
            return self?.sections[index].layoutSection()
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    // MARK: Properties
    
    private let viewModel: DebugViewModelType
    private var cancelables = Set<AnyCancellable>()
    
    private var sections: [DebugSection] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: Lifecycle
    
    public init() {
        self.viewModel = DebugViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureSubViews()
        configureNavigation()
        configureCollectionView()
        bindViewModel()
        viewModel.inputs.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 選択されたセルの解除を徐々に行う.
        guard let selectedIndexPath = collectionView.indexPathsForSelectedItems else {
            return
        }
        selectedIndexPath.forEach { [weak self] indexPath in self?.collectionView.deselectItem(at: indexPath, animated: true) }
    }
}

// MARK: - Configure

extension DebugViewController {
    
    private func configureSubViews() {
        view.backgroundColor = .systemBackground
        collectionView.embed(in: view)
    }
    
    private func configureNavigation() {
        navigationItem.title = "🛠 デバッグメニュー"
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DebugCell.self)
    }
    
    private func bindViewModel() {
        viewModel.outpus.error
            .sink { [unowned self] message in
                let ac = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(ac, animated: true, completion: nil)
            }
            .store(in: &cancelables)
        viewModel.outpus.sections
            .assign(to: \.sections, on: self)
            .store(in: &cancelables)
        viewModel.outpus.message
            .sink { [unowned self] message in
                let ac = UIAlertController(title: "", message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(ac, animated: true, completion: nil)
            }
            .store(in: &cancelables)
        viewModel.outpus.flowContext
            .sink { [unowned self] context in
                context.move(from: self)
            }
            .store(in: &cancelables)
    }
}

// MARK: - CollectionView DataSource

extension DebugViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].numberOfItems
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return sections[indexPath.section].configureCell(collectionView, at: indexPath)
    }
}

// MARK: - CollectionView Delegate

extension DebugViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.inputs.didSelectRow(in: sections[indexPath.section])
    }
}
