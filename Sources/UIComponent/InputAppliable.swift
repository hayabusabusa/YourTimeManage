//
//  InputAppliable.swift
//  
//
//  Created by Shunya Yamada on 2021/07/11.
//

import Foundation

protocol InputAppliable {
    associatedtype Input
    func apply(input: Input)
}
