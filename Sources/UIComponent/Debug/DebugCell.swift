//
//  DebugCell.swift
//  
//
//  Created by Shunya Yamada on 2021/07/11.
//

import UIKit
import SwiftUI

public class DebugCell: UICollectionViewCell {
    
    // MARK: Subviews
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .systemGray2
        return imageView
    }()
    
    // MARK: Initializer
    
    init() {
        super.init(frame: .zero)
        let stackView = UIStackView(axis: .horizontal,
                                    alignment: .fill,
                                    spacing: 8,
                                    distribution: .equalSpacing,
                                    subviews: [
                                        titleLabel,
                                        iconImageView
                                    ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.embed(in: contentView, insets: .symetric(horizontal: 16, vertical: 12))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configurations
    
    public func configure(title: String) {
        titleLabel.text = title
    }
}

// MARK: - Previews

struct DebugCellPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            DebugCell.Wrapped(title: "ライトモード Preview")
            DebugCell.Wrapped(title: "ダークモード Preview")
                .preferredColorScheme(.dark)
        }
        .previewLayout(.fixed(width: 320, height: 44))
    }
}

private extension DebugCell {
    
    struct Wrapped: UIViewRepresentable {
        typealias UIViewType = DebugCell
        
        let title: String
        
        func makeUIView(context: Context) -> DebugCell {
            let view = DebugCell()
            view.configure(title: title)
            return view
        }
        
        func updateUIView(_ uiView: DebugCell, context: Context) {
            // None
        }
    }
}
