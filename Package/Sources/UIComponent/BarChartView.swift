//
//  BarChartView.swift
//  
//
//  Created by Shunya Yamada on 2022/03/31.
//

import Charts
import UIKit

final class BarChartView: UIView {
    
    private lazy var chartView: Charts.BarChartView = {
        let chartView = Charts.BarChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
}

private extension BarChartView {
    
    func configure() {
        configureSubviews()
    }
    
    func configureSubviews() {
        addSubview(chartView)
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: topAnchor),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartView.bottomAnchor.constraint(equalTo: bottomAnchor),
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}

