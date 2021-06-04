//
//  PodcastDetailHeaderView.swift
//  Podcast
//
//  Created by liuliu on 2021/6/1.
//

import UIKit
import PinLayout

class PodcastDetailHeaderView: UIView {
    let contentImageView = UIImageView().then {
        $0.cornerRadius = 8
        $0.contentMode = .scaleAspectFill
    }

    let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 16)
    }

    let authLabel = UILabel().then {
        $0.textColor = UIColor.white.withAlphaComponent(0.8)
        $0.font = .systemFont(ofSize: 12)
    }

    let collectButton = UIButton(type: .custom).then {
        $0.backgroundColor = R.color.accentColor()
        $0.setTitle("Collect", for: .normal)
        $0.setTitle("✓ Collected", for: .selected)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = R.color.defaultBackground()
        addSubviews([contentImageView, titleLabel, authLabel, collectButton])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Podcast) {
        contentImageView.kf.setImage(model.artworkUrl100)
        titleLabel.text = model.trackName
        authLabel.text = model.artistName

        collectButton.isSelected = model.isCollected
        layout()
    }

    func layout() {
        contentImageView.pin.top().width(self.width * 0.3).height(self.width * 0.3).left(20)

        titleLabel.pin
            .after(of: contentImageView, aligned: .center)
            .marginLeft(16).right(10).sizeToFit()

        authLabel.pin
            .above(of: titleLabel, aligned: .left)
            .marginBottom(10).right(10).sizeToFit()

        collectButton.pin
            .below(of: titleLabel, aligned: .left)
            .marginTop(10).width(self.width * 0.3).height(30)
        collectButton.cornerRadius = 15

        self.pin.wrapContent(.vertically, padding: PEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
    }
}
