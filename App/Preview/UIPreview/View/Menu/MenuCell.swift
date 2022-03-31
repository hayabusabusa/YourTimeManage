//
//  MenuCell.swift
//  UIPreview
//
//  Created by Shunya Yamada on 2022/04/01.
//

import UIKit

final class MenuCell: UICollectionViewCell {
    
    // MARK: Subview
    
    private lazy var contentHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var iconBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue.withAlphaComponent(0.3)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .systemGray4
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure(with title: String, iconImage: UIImage?) {
        titleLabel.text = title
        iconImageView.image = iconImage
    }
}

private extension MenuCell {
    
    func configure() {
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = .systemGray.withAlphaComponent(0.2)
        
        configureSubview()
    }
    
    func configureSubview() {
        addSubview(contentHStackView)
        addSubview(dividerView)
        
        contentHStackView.addArrangedSubview(iconBackgroundView)
        contentHStackView.addArrangedSubview(titleLabel)
        contentHStackView.addArrangedSubview(accessoryImageView)
        
        iconBackgroundView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            contentHStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            contentHStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentHStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            contentHStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            iconBackgroundView.widthAnchor.constraint(equalToConstant: 56),
            iconBackgroundView.heightAnchor.constraint(equalToConstant: 56),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.centerXAnchor.constraint(equalTo: iconBackgroundView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor),
            
            accessoryImageView.widthAnchor.constraint(equalToConstant: 12),
            
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dividerView.heightAnchor.constraint(equalToConstant: 0.5),
        ])
    }
}
