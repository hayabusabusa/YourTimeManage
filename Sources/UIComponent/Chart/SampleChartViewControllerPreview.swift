//
//  SwiftUIView.swift
//  
//
//  Created by Shunya Yamada on 2021/07/05.
//

import SwiftUI

struct SampleChartViewControllerPreview: PreviewProvider {
    static var previews: some View {
        SampleChartViewController.Wrapper()
            .previewLayout(.fixed(width: 320, height: 200))
    }
}

private extension SampleChartViewController {
    
    struct Wrapper: UIViewControllerRepresentable {
        
        typealias UIViewControllerType = SampleChartViewController
        
        func makeUIViewController(context: Context) -> UIViewControllerType {
            return SampleChartViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            // None
        }
    }
}
