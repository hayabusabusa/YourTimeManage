//
//  RootModel.swift
//  
//
//  Created by Shunya Yamada on 2021/07/31.
//

import Combine
import Domain
import Foundation

protocol RootModelProtocol {
    func isSignedIn() -> Bool 
}

final class RootModel: RootModelProtocol {
    
    private let authProvider: AuthProviderProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(authProvider: AuthProviderProtocol = AuthProvider.shared) {
        self.authProvider = authProvider
    }
    
    func isSignedIn() -> Bool {
        return authProvider.currentUser != nil
    }
}
