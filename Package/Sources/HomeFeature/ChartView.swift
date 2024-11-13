//
//  ChartView.swift
//
//
//  Created by Shunya Yamada on 2024/10/09.
//

import Charts
import SwiftUI

// MARK: - Chart

struct StackedChartData: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var data: [ChartData]
}

struct ChartData: Identifiable {
    var id: String = UUID().uuidString
    var category: Category
    var value: Double
}

enum Category: String, CaseIterable {
    case japanese
    case mathematics
    case english

    var color: Color {
        switch self {
        case .japanese:
            Color(.systemBlue)
        case .mathematics:
            Color(.systemYellow)
        case .english:
            Color(.systemRed)
        }
    }

    static var colors: KeyValuePairs<String, Color> {
        [
           Category.japanese.rawValue: Category.japanese.color,
           Category.mathematics.rawValue: Category.mathematics.color,
           Category.english.rawValue: Category.english.color
       ]
    }
}

struct ChartView: View {
    @State private var stackedData: [StackedChartData] = [
        StackedChartData(
            title: "月曜日",
            data: [
                ChartData(category: .japanese, value: 0)
            ]
        ),
        StackedChartData(
            title: "火曜日",
            data: [
                ChartData(category: .japanese, value: 0)
            ]
        )
    ]

    private static var _stackedData: [StackedChartData] {
        [
            StackedChartData(
                title: "月曜日",
                data: [
                    ChartData(
                        category: .japanese,
                        value: 1.5
                    ),
                    ChartData(
                        category: .mathematics,
                        value: 1.2
                    )
                ]
            ),
            StackedChartData(
                title: "火曜日",
                data: [
                    ChartData(
                        category: .english,
                        value: 3.5
                    )
                ]
            ),
            StackedChartData(
                title: "水曜日",
                data: [
                    ChartData(
                        category: .english,
                        value: 0
                    )
                ]
            ),
            StackedChartData(
                title: "木曜日",
                data: [
                    ChartData(
                        category: .english,
                        value: 0
                    )
                ]
            ),
            StackedChartData(
                title: "金曜日",
                data: [
                    ChartData(
                        category: .english,
                        value: 0
                    )
                ]
            )
        ]
    }

    var body: some View {
        Chart(stackedData) { stacked in
            ForEach(stacked.data) { data in
                BarMark(
                    x: .value("曜日", stacked.title),
                    y: .value("時間", data.value)
                )
                .foregroundStyle(
                    by: .value(
                        "category",
                        data.category.rawValue
                    )
                )
                .cornerRadius(4.0)
            }
        }
        .chartForegroundStyleScale(Category.colors)
        .task {
            Task {
                try? await Task.sleep(for: .seconds(1))
                withAnimation(.easeInOut) {
                    stackedData = Self._stackedData
                }
            }
        }
    }
}

// MARK: - PieChart

/// 円グラフの `View`.
///
/// - note: [参考](https://useyourloaf.com/blog/swiftui-pie-charts/)
struct PieChartView: View {
    private var data = [
        ChartData(
            category: .japanese,
            value: 0.5
        ),
        ChartData(
            category: .mathematics,
            value: 0.4
        ),
        ChartData(
            category: .english,
            value: 0.1
        )
    ]

    var body: some View {
        Chart(data) { element in
            SectorMark(
                angle: .value(
                    "value",
                    element.value
                ),
                innerRadius: .ratio(0.6),
                angularInset: 2
            )
            .cornerRadius(4)
            .annotation(position: .overlay) {
                // 0.1 以下は表示しない方がいい
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundStyle(Color.black)
                        .frame(width: 32, height: 32)
                        .overlay {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(lineWidth: 2.0)
                                .foregroundStyle(Color.white)
                        }
                    Text(element.category.rawValue.prefix(1).uppercased())
                        .bold()
                        .foregroundStyle(Color.white)
                }
            }
            .foregroundStyle(
                by: .value(
                    "category",
                    element.category.rawValue
                )
            )
        }
        .scaledToFit()
        .chartForegroundStyleScale(Category.colors)
    }
}

// MARK: - HeatMap

struct HeatMapData: Identifiable {
    var id = UUID().uuidString
}

struct HeatMapItemView: View {
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(
                    .adaptive(
                        minimum: 40,
                        maximum: .infinity
                    )
                )
            ]
        ) {
            CircularProgressView(
                color: .blue,
                progress: Double.random(in: 0...1),
                lineWidth: 6,
                size: 28
            )

            Text("W")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(Color(.systemGray2))
        }
    }
}

struct HeatMapView: View {
    @State private var data = [HeatMapData]()
    private static var _data: [HeatMapData] {
        [
            HeatMapData(),
            HeatMapData(),
            HeatMapData(),
            HeatMapData(),
            HeatMapData(),
            HeatMapData(),
            HeatMapData(),
        ]
    }

    var body: some View {
        HStack {
            ForEach(data) { element in
                HeatMapItemView()
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(1))
            withAnimation {
                data = Self._data
            }
        }
    }
}

// MARK: - View

struct HomeView: View {
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16) {
                HeatMapView()

                PieChartView()
                    .frame(height: 200)

//                ChartView()
//                    .frame(height: 200)
            }
            .padding()
        }
        .navigationTitle("ホーム")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        HomeView()
    }
}
