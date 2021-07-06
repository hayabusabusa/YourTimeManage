//
//  DebugCell.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/07/07.
//

import UIKit

final class DebugCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    private func configure() {
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = .systemFill
    }
    
    func configureCell(with title: String) {
        titleLabel.text = title
    }
}
