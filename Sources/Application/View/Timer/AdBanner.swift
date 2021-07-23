//
//  AdBanner.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/07/19.
//

import GoogleMobileAds
import Shared
import UIKit

public final class AdBanner: UIView {
    
    private var adUnitID: String?
    private weak var rootViewController: UIViewController?
    
    private lazy var divider: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        view.sized(height: 1)
        return view
    }()
    
    private lazy var adView: GADBannerView = {
        let adView = GADBannerView(adSize: kGADAdSizeBanner)
        adView.translatesAutoresizingMaskIntoConstraints = false
        #if DEBUG
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [kGADSimulatorID]
        #endif
        // ID が指定されていない場合は公式のテスト ID を利用する.
        adView.adUnitID = adUnitID ?? "ca-app-pub-3940256099942544/2934735716"
        adView.rootViewController = rootViewController
        adView.load(GADRequest())
        return adView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public convenience init(viewController: UIViewController, adUnitID: String?) {
        self.init(frame: .zero)
        self.rootViewController = viewController
        self.adUnitID = adUnitID
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configure() {
        addSubview(divider)
        addSubview(adView)
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: topAnchor),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            adView.centerXAnchor.constraint(equalTo: centerXAnchor),
            adView.centerYAnchor.constraint(equalTo: centerYAnchor),
            heightAnchor.constraint(equalToConstant: kGADAdSizeBanner.size.height)
        ])
    }
}
