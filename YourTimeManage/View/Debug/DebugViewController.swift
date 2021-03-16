//
//  DebugViewController.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/03/12.
//

import UIKit

final class DebugViewController: UIViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Properties
    
    private var sectinos: [DebugSection] = DebugSection.allCases
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
}

// MARK: - Configure

extension DebugViewController {
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - TableView dataSource

extension DebugViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectinos.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectinos[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sectinos[indexPath.section].rows[indexPath.row]
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
    }
}
