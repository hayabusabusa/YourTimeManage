//
//  BannerAdView.swift
//  Package
//
//  Created by Shunya Yamada on 2025/11/30.
//

import GoogleMobileAds
import SwiftUI

/// バナーの広告を表示する View.
public struct BannerAdView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = BannerAdViewController
    /// 広告 ID.
    private let adUnitID = GoogleAdsView.adUnitID
    /// 広告読み込みエラー受け取り時のコールバック.
    var didFailToReceiveAdWithError: ((any Error) -> Void)?

    public init(
        didFailToReceiveAdWithError: ((any Error) -> Void)? = nil
    ) {
        self.didFailToReceiveAdWithError = didFailToReceiveAdWithError
    }

    public func makeUIViewController(context: Context) -> BannerAdViewController {
        let viewController = BannerAdViewController()
        viewController.bannerView.delegate = context.coordinator
        viewController.bannerView.adUnitID = adUnitID
        return viewController
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator { error in
            didFailToReceiveAdWithError?(error)
        }
    }

    public func updateUIViewController(_ uiViewController: BannerAdViewController, context: Context) {}
}

public extension BannerAdView {
    final class Coordinator: NSObject, BannerViewDelegate {
        var didFailToReceiveAdWithError: ((any Error) -> Void)?

        init(didFailToReceiveAdWithError: ((any Error) -> Void)? = nil) {
            self.didFailToReceiveAdWithError = didFailToReceiveAdWithError
        }

        public func bannerView(
            _ bannerView: BannerView,
            didFailToReceiveAdWithError error: any Error
        ) {
            didFailToReceiveAdWithError?(error)
        }
    }
}

public final class BannerAdViewController: UIViewController {
    /// バナー広告の View.
    private(set) var bannerView = BannerView()

    public override func loadView() {
        super.loadView()
        configureSubviews()
    }

    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        updateBannerViewSizeIfNeeded()
    }

    public override func viewWillTransition(
        to size: CGSize,
        with coordinator: any UIViewControllerTransitionCoordinator
    ) {
        coordinator.animate { _ in
            // 何もしない.
        } completion: { [weak self] error in
            self?.updateBannerViewSizeIfNeeded()
        }
    }
}

private extension BannerAdViewController {
    func configureSubviews() {
        bannerView.isAutoloadEnabled = true
        bannerView.rootViewController = self
        bannerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(bannerView)
        NSLayoutConstraint.activate([
            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    func updateBannerViewSizeIfNeeded() {
        let width = view.frame.inset(by: view.safeAreaInsets).size.width
        let adSize = currentOrientationAnchoredAdaptiveBanner(width: width)

        guard adSize.size != bannerView.adSize.size else {
            return
        }
        bannerView.adSize = adSize
        bannerView.load(GoogleMobileAds.Request())
    }
}
