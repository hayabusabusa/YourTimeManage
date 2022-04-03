//
//  BarChartView.swift
//  
//
//  Created by Shunya Yamada on 2022/03/31.
//

import Charts
import UIKit

public final class BarChartView: UIView {
    
    private lazy var chartView: Charts.BarChartView = {
        let chartView = Charts.BarChartView()
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.axisLineColor = .systemGray3
        chartView.xAxis.labelTextColor = .systemGray
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.granularity = 1
        chartView.xAxis.valueFormatter = Formatter()
        chartView.leftAxis.gridColor = .systemGray3
        chartView.leftAxis.labelCount = 5
        chartView.leftAxis.axisMinimum = 0
        chartView.leftAxis.axisLineColor = .systemGray3
        chartView.leftAxis.labelTextColor = .systemGray
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public required init?(coder: NSCoder) {
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
        
        let data1 = BarChartDataEntry(x: 0, y: 10)
        let data2 = BarChartDataEntry(x: 1, y: 40)
        let data3 = BarChartDataEntry(x: 2, y: 20)
        let data4 = BarChartDataEntry(x: 3, y: 40)
        let dataSet = BarChartDataSet(entries: [data1, data2, data3, data4])
        let data = BarChartData(dataSet: dataSet)
        
        chartView.data = data
    }
}

private extension BarChartView {
    
    class Formatter: AxisValueFormatter {
        
        private let data: [Double: String] = [
            0: "その0",
            1: "その1",
            2: "その2"
        ]
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return data[value] ?? "nil"
        }
    }
}
