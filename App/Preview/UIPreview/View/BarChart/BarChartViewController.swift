//
//  BarChartViewController.swift
//  UIPreview
//
//  Created by Shunya Yamada on 2022/04/01.
//

import UIComponent
import UIKit

final class BarChartViewController: UIViewController {
    
    // MARK: Subview
    
    private lazy var barChartView: BarChartView = {
        let chartView = BarChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubview()
    }
}

private extension BarChartViewController {
    
    func configureSubview() {
        view.backgroundColor = .systemBackground
        view.addSubview(barChartView)
        
        NSLayoutConstraint.activate([
            barChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            barChartView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            barChartView.heightAnchor.constraint(equalToConstant: 240)
        ])
    }
}
