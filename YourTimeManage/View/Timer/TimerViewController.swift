//
//  TimerViewController.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/07/11.
//

import Combine
import UIComponent
import UIKit

final class TimerViewController: UIViewController {
    
    // MARK: SubViews
    
    private lazy var countdownLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ラベル"
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        return label
    }()
    
    private lazy var startButton: Button = {
        let button = Button(style: .small)
        button.setTitle("スタート", for: .normal)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stopButton: Button = {
        let button = Button(style: .small)
        button.setTitle("ストップ", for: .normal)
        button.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal,
                                    alignment: .fill,
                                    spacing: 8,
                                    distribution: .equalSpacing,
                                    subviews: [
                                        startButton,
                                        stopButton
                                    ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var adView: AdBanner = {
        // Info.plist の項目から AdMob の ID を読み込む.
        let adUnitID = Bundle.main.object(forInfoDictionaryKey: "GADUnitID") as? String
        let adBanner = AdBanner(viewController: self, adUnitID: adUnitID)
        adBanner.translatesAutoresizingMaskIntoConstraints = false
        return adBanner
    }()
    
    // MARK: Properties
    
    private let viewModel: TimerViewModelType
    private var cancelables = Set<AnyCancellable>()
    
    // MARK: Lifecycle
    
    init(viewModel: TimerViewModelType = TimerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubViews()
        configureNavigation()
        configureNotificationObserver()
        bindViewModel()
    }
    
    @objc
    private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func startButtonTapped() {
        viewModel.inputs.startButtonTapped()
    }
    
    @objc
    private func stopButtonTapped() {
        viewModel.inputs.stopButtonTapped()
    }
    
    @objc
    private func didEnterBackground() {
        
    }
    
    @objc
    private func willEnterForeground() {
        
    }
}

// MARK: - Configurations

extension TimerViewController {
    
    private func configureSubViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(countdownLabel)
        view.addSubview(buttonsStackView)
        view.addSubview(adView)
        NSLayoutConstraint.activate([
            countdownLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56),
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64),
            adView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            adView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "閉じる", style: .done, target: self, action: #selector(closeButtonTapped))
    }
    
    private func configureNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func bindViewModel() {
        viewModel.outputs.seconds
            .assign(to: \.text, on: countdownLabel)
            .store(in: &cancelables)
    }
}
