//
//  UIStackView+.swift
//  
//
//  Created by Shunya Yamada on 2021/07/11.
//

import UIKit

public extension UIStackView {
    
    convenience init(axis: NSLayoutConstraint.Axis, alignment: Alignment, spacing: CGFloat, distribution: Distribution, subviews: [UIView]) {
        self.init(frame: .zero)
        self.axis = axis
        self.alignment = alignment
        self.spacing = spacing
        self.distribution = distribution
        subviews.forEach { addArrangedSubview($0) }
    }
}
