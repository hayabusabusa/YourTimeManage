//
//  DebugViewController.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/03/12.
//

import UIKit
import Model

final class DebugViewController: UIViewController {
    
    // MARK: IBOutlet
    
    // MARK: Properties
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        migrate()
    }
}

extension DebugViewController {
    
    private func migrate() {
        Migrator.execute(of: .v200) { result in
            switch result {
            case .success:
                print("Migration successed")
            case .failure(let error):
                print(error)
            }
        }
    }
}
