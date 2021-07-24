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
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .systemGray2
        return imageView
    }()
    
    private lazy var divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        view.sized(height: 1)
        return view
    }()
    
    // MARK: Initializer
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = .systemFill
        let stackView = UIStackView(axis: .horizontal,
                                    alignment: .fill,
                                    spacing: 12,
                                    distribution: .fill,
                                    subviews: [
                                        titleLabel,
                                        detailLabel,
                                        iconImageView
                                    ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.embed(in: contentView, insets: .symetric(horizontal: 16, vertical: 12))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configurations
    
    public func configure(title: String, detail: String? = nil) {
        titleLabel.text = title
        detailLabel.text = detail
        detailLabel.isHidden = detail == nil
        iconImageView.isHidden = detail != nil
    }
}

// MARK: - Previews

struct DebugCellPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            DebugCell.Wrapped(title: "ライトモード Preview", detail: "詳細")
            DebugCell.Wrapped(title: "ダークモード Preview", detail: "詳細")
                .preferredColorScheme(.dark)
        }
        .previewLayout(.fixed(width: 320, height: 44))
    }
}

private extension DebugCell {
    
    struct Wrapped: UIViewRepresentable {
        typealias UIViewType = DebugCell
        
        let title: String
        let detail: String?
        
        func makeUIView(context: Context) -> DebugCell {
            let view = DebugCell(frame: .zero)
            view.configure(title: title, detail: detail)
            return view
        }
        
        func updateUIView(_ uiView: DebugCell, context: Context) {
            // None
        }
    }
}
