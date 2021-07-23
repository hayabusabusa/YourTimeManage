//
//  LoginViewController+Preview.swift
//  
//
//  Created by Shunya Yamada on 2021/07/23.
//

import SwiftUI

struct LoginViewControllerPreview: PreviewProvider {
    static var previews: some View {
        Group {
            LoginViewController.Wrapped()
        }
    }
}

private extension LoginViewController {
    
    struct Wrapped: UIViewControllerRepresentable {
        typealias UIViewControllerType = LoginViewController
        
        func makeUIViewController(context: Context) -> LoginViewController {
            return LoginViewController()
        }
        
        func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {
            // None
        }
    }
}
