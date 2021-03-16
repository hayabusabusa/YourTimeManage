//
//  DebugViewController.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/03/12.
//

import UIKit
import Combine

final class DebugViewController: UIViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Properties
    
    private var viewModel: DebugViewModelType!
    private var cancelables = Set<AnyCancellable>()
    
    private var sections: [DebugSection] = []
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindViewModel()
        
        viewModel.inputs.viewDidLoad()
    }
}

// MARK: - Configure

extension DebugViewController {
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
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
                self?.tableView.reloadData()
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

// MARK: - TableView dataSource

extension DebugViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sections[indexPath.section].rows[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuseID")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = row.title
        return cell
    }
}

// MARK: - TableView delegate

extension DebugViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.inputs.didSelectRow(at: sections[indexPath.section].rows[indexPath.row])
    }
}
