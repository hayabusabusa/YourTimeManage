//
//  Button.swift
//  
//
//  Created by Shunya Yamada on 2021/07/18.
//

import UIKit
import SwiftUI

public class Button: UIButton {
    
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    public var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    public var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    public var normalBackgroundColor: UIColor = .clear {
        didSet {
            setBackgroundImage(normalBackgroundColor.image(), for: .normal)
        }
    }
    
    public var highlightedBackgroundColor: UIColor = UIColor.systemBlue.withAlphaComponent(0.14) {
        didSet {
            setBackgroundImage(highlightedBackgroundColor.image(), for: .highlighted)
        }
    }
    
    public var selectedBackgroundColor: UIColor = .clear {
        didSet {
            setBackgroundImage(selectedBackgroundColor.image(), for: .selected)
        }
    }
    
    public var disabledBackgroundColor: UIColor = .clear {
        didSet {
            setBackgroundImage(disabledBackgroundColor.image(), for: .disabled)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public convenience init(style: Style) {
        self.init(frame: .zero)
        style.apply(for: self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.borderColor = borderColor.resolvedColor(with: traitCollection).cgColor
        setBackgroundImage(normalBackgroundColor.resolvedColor(with: traitCollection).image(), for: .normal)
        setBackgroundImage(highlightedBackgroundColor.resolvedColor(with: traitCollection).image(), for: .highlighted)
        setBackgroundImage(selectedBackgroundColor.resolvedColor(with: traitCollection).image(), for: .selected)
        setBackgroundImage(disabledBackgroundColor.resolvedColor(with: traitCollection).image(), for: .disabled)
    }
    
    private func configure() {
        isExclusiveTouch = true

        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        
        setTitleColor(.link, for: .normal)
        
        setBackgroundImage(normalBackgroundColor.image(), for: .normal)
        setBackgroundImage(highlightedBackgroundColor.image(), for: .highlighted)
        setBackgroundImage(selectedBackgroundColor.image(), for: .selected)
        setBackgroundImage(disabledBackgroundColor.image(), for: .disabled)
    }
}

private extension UIColor {
    
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { context in
            self.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}

// MARK: - Previews

struct ButtonPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            Button.Wrapped(style: .small)
            Button.Wrapped(style: .small)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.fixed(width: 160, height: 44))
    }
}

private extension Button {
    
    struct Wrapped: UIViewRepresentable {
        typealias UIViewType = Button
        
        let style: Button.Style
        
        func makeUIView(context: Context) -> Button {
            let view = Button(style: style)
            view.setTitle("ボタン", for: .normal)
            return view
        }
        
        func updateUIView(_ uiView: Button, context: Context) {
            // None
        }
    }
}

