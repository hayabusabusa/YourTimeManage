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

    var text: String {
        switch self {
        case .japanese:
            "国語"
        case .mathematics:
            "数学"
        case .english:
            "英語"
        }
    }

    static var colors: KeyValuePairs<String, Color> {
        [
            Category.japanese.rawValue: Category.japanese.color.opacity(0.6),
            Category.mathematics.rawValue: Category.mathematics.color.opacity(0.65),
            Category.english.rawValue: Category.english.color.opacity(0.65)
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
                innerRadius: .ratio(0.68),
                outerRadius: .automatic,
                angularInset: 2
            )
            .cornerRadius(4)
            .annotation(position: .overlay) {
                // 0.1 以下は表示しない方がいい
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(element.category.color)
                        .frame(width: 44, height: 44)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 2.0)
                                .foregroundStyle(.gray.opacity(0.2))
                        }
                    Text(element.category.text.prefix(1).uppercased())
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
        .frame(height: 260)
        .scaledToFit()
        .chartLegend(.hidden)
        .chartForegroundStyleScale(Category.colors)
    }
}

// MARK: - TitleView

struct TitleView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("今日の合計")
                .foregroundStyle(.gray)

            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text("5")
                    .bold()
                    .font(.system(size: 36))
                Text("時間")
                    .foregroundStyle(.gray)
                Text("30")
                    .bold()
                    .font(.system(size: 36))
                Text("分")
                    .foregroundStyle(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
    @State private var data = [
        HeatMapData(),
        HeatMapData(),
        HeatMapData(),
        HeatMapData(),
        HeatMapData(),
        HeatMapData(),
        HeatMapData(),
    ]

    var body: some View {
        HStack {
            ForEach(data) { element in
                HeatMapItemView()
            }
        }
    }
}

// MARK: - Summary

struct SummaryView: View {
    var body: some View {
        HStack {
            Button {
                // Action
            } label: {
                Text("今日")
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                Color(.systemGray2)
                                    .opacity(0.2)
                            )
                    )
            }
            
            Button {
                // Action
            } label: {
                Text("B")
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                Color(.systemGray2)
                                    .opacity(0.2)
                            )
                    )
            }
        }
    }
}

// MARK: - Hint

struct HintView: View {
    var body: some View {
        Button {
            // Action
        } label: {
            HStack {
                Text("🙌")
                    .font(.system(size: 30))

                VStack(alignment: .leading) {
                    Text("今日の記録はまだありません")
                        .bold()
                        .lineLimit(1)
                    Text("今から始めてみませんか？")
                        .lineLimit(1)
                }
                .foregroundStyle(Color(.label))
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )

                Image(systemName: "chevron.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(Color(.systemGray2))
                    .frame(
                        width: 16,
                        height: 16
                    )
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.1))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        Color(.systemGray2)
                            .opacity(0.2)
                    )
            }
        }
    }
}

// MARK: - Item Title View

struct ItemTitleView: View {
    var body: some View {
        HStack {
            Text("履歴一覧")
                .font(.system(size: 24))
                .bold()
                .foregroundStyle(Color(.label))
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }
}

// MARK: - Item

/// 履歴一覧の `View`.
///
/// - note: これを取るためには複数の日付から直近の 3 件を取る必要があるので
/// `CollectionGroup` でクエリを発行する必要がある.
///
/// - seealso: [公式ドキュメント](https://firebase.google.com/docs/firestore/query-data/queries?hl=ja#collection-group-query)
struct ItemView: View {
    var body: some View {
        Button {
            
        } label: {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(
                            width: 56,
                            height: 56
                        )
                        .foregroundStyle(Color.blue.opacity(0.1))
                    Image(systemName: "function")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: 24,
                            height: 24
                        )
                        .foregroundStyle(Color.blue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("タイトル")
                        .bold()
                        .lineLimit(1)
                        .foregroundStyle(Color(.label))
                    Text("メモがあれば表示してなければ非表示にしておく")
                        .font(.system(size: 14))
                        .lineLimit(1)
                        .foregroundStyle(Color.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("1")
                        .bold()

                    Text("時間")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.gray)

                    Text("23")
                        .bold()

                    Text("分")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.gray)
                }
                .foregroundStyle(Color(.label))
            }
        }
    }
}

// MARK: - View

public struct HomeView: View {
    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // NOTE: Header
                VStack(spacing: 0) {
                    HeatMapView()
                        .padding()
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(Color(.systemGray2).opacity(0.2))
                }
                
                // NOTE: Scroll
                ScrollView(.vertical) {
                    VStack(spacing: 24) {
                        TitleView()
                        
                        PieChartView()
                        
//                        SummaryView()

                        HintView()

                        ItemTitleView()

                        LazyVStack {
                            ForEach(0..<3) { _ in
                                ItemView()
                            }
                        }
                    }
                    .padding(.vertical, 24)
                    .padding(.horizontal)
                }
            }
            
            // NOTE: FAB
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    public init() {}
}

#Preview {
    NavigationView {
        HomeView()
    }
}
