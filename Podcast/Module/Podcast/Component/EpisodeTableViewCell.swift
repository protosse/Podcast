//
//  EpisodeTableViewCell.swift
//  Podcast
//
//  Created by liuliu on 2021/6/1.
//

import UIKit
import PinLayout
import Then
import MGSwipeTableCell
import Tiercel

class EpisodeTableViewCell: MGSwipeTableCell {

    let contentImageView = UIImageView().then {
        $0.cornerRadius = 8
        $0.contentMode = .scaleAspectFill
    }

    let titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 14)
    }

    let releaseDateLabel = UILabel().then {
        $0.textColor = UIColor.white.withAlphaComponent(0.8)
        $0.font = .systemFont(ofSize: 12)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = R.color.defaultBackground()
        self.selectionStyle = .none
        contentView.addSubviews([contentImageView, titleLabel, releaseDateLabel])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        contentImageView.pin.top(10).width(80).height(80).left(20)

        titleLabel.pin.after(of: contentImageView, aligned: .top)
            .marginLeft(16).marginTop(8).right(10).sizeToFit(.width)

        releaseDateLabel.pin.after(of: contentImageView, aligned: .bottom)
            .marginLeft(16).marginBottom(8).right(10).sizeToFit(.width)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        return CGSize(width: contentView.width, height: contentImageView.frame.maxY + 10)
    }

    func configure(with model: Episode) {
        contentImageView.kf.setImage(model.imageUrl)
        titleLabel.text = model.title
        releaseDateLabel.text = secondsToHourMinutes(Int(model.duration))
    }
    
    func updateTask(_ task: DownloadTask) {
        switch task.status {
        case .running:
            break
        default:
            break
        }
    }
    
    private func secondsToHourMinutes(_ seconds: Int) -> String {
        let hour = seconds / 3600
        let minute = seconds / 60 % 60
        
        if hour > 0 {
            return String(format: "%i h,%i min", hour, minute)
        }else if minute > 0 {
            return String(format: "%i min", minute)
        }else {
            return String(format: "%i s", seconds)
        }
    }

}
