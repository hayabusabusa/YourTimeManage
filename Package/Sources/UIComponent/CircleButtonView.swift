//
//  CircleButtonView.swift
//  
//
//  Created by Shunya Yamada on 2022/05/05.
//

import UIKit

public final class CircleButtonView: UIView {

    // MARK: Subviews

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.alpha = 0.28
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var borderBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 2.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public private(set) lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: Properties

    private let size: CGFloat = 80.0
    private let padding: CGFloat = 6.0

    public var color: UIColor = .systemBlue {
        didSet {
            backgroundView.backgroundColor = color
            borderBackgroundView.layer.borderColor = color.cgColor
            button.titleLabel?.textColor = color
            button.imageView?.tintColor = color
        }
    }

    // MARK: Lifecycle

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
}

// MARK: - Configurations

private extension CircleButtonView {

    func configure() {
        isExclusiveTouch = true

        let cornerRadius = size / 2.0
        backgroundView.backgroundColor = .systemBlue
        backgroundView.layer.cornerRadius = cornerRadius - padding
        borderBackgroundView.layer.borderColor = UIColor.systemBlue.cgColor
        borderBackgroundView.layer.cornerRadius = cornerRadius
        button.layer.cornerRadius = cornerRadius
        button.titleLabel?.textColor = .systemBlue
        button.imageView?.tintColor = .systemBlue

        configureSubviews()
    }

    func configureSubviews() {
        addSubview(borderBackgroundView)
        addSubview(backgroundView)
        addSubview(button)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 80),
            heightAnchor.constraint(equalToConstant: 80),
            borderBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            borderBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            borderBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            borderBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
    }
}
