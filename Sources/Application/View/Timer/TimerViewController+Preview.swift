//
//  TimerViewController+Preview.swift
//  
//
//  Created by Shunya Yamada on 2021/07/23.
//

import UIKit
import SwiftUI

// MARK: Preview

struct TimerViewControllerPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            TimerViewController.Wrapped()
            TimerViewController.Wrapped()
                .preferredColorScheme(.dark)
        }
    }
}

private extension TimerViewController {
    
    struct Wrapped: UIViewControllerRepresentable {
        typealias UIViewControllerType = UINavigationController
        
        func makeUIViewController(context: Context) -> UINavigationController {
            let nvc = UINavigationController(rootViewController: TimerViewController())
            return nvc
        }
        
        func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
            // None
        }
    }
}
