//
//  SampleChartViewController.swift
//  
//
//  Created by Shunya Yamada on 2021/07/05.
//

import Charts
import Shared
import UIKit

public final class SampleChartViewController: UIViewController {
    
    // MARK: SubViews
    
    private lazy var chartView: BarChartView = {
        let barChartView = BarChartView()
        return barChartView
    }()
    
    // MARK: Properties
    
    // MARK: Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureSubViews()
    }
}

// MARK: - Configurations

extension SampleChartViewController {
    
    private func configureSubViews() {
        chartView.embed(in: view, insets: .all(8))
    }
}
