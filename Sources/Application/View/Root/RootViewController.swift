//
//  RootViewController.swift
//  
//
//  Created by Shunya Yamada on 2021/07/31.
//

import Combine
import UIKit

public final class RootViewController: UIViewController {
    
    // MARK: SubViews
    
    // MARK: Properties
    
    private let viewModel: RootViewModelType
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Lifecycle
    
    public init() {
        self.viewModel = RootViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.inputs.viewDidLoad()
    }
}

// MARK: - Configurations

extension RootViewController {
    
    private func bindViewModel() {
        viewModel.outputs.flowContext
            .sink { [unowned self] context in
                context.move(from: self)
            }
            .store(in: &cancellables)
    }
}
