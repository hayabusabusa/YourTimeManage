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
    
    @IBAction func clashButtonTapped(_ sender: UIButton) {
        fatalError("[DEBUG] Send clash report to Firebase Clashlytics.")
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
