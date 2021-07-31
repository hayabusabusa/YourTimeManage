//
//  RootModel.swift
//  
//
//  Created by Shunya Yamada on 2021/07/31.
//

import Combine
import Foundation

protocol RootModelProtocol {
    
}

final class RootModel: RootModelProtocol {
    
    private var cancellables = Set<AnyCancellable>()
}
