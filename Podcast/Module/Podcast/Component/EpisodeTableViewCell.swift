//
//  EpisodeTableViewCell.swift
//  Podcast
//
//  Created by liuliu on 2021/6/1.
//

import MGSwipeTableCell
import PinLayout
import SwiftUI
import Then
import Tiercel
import UIKit

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
        backgroundColor = R.color.defaultBackground()
        selectionStyle = .none
        contentView.addSubviews([contentImageView, titleLabel, releaseDateLabel])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var task: DownloadTask?
    var model: Episode?

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
        self.model = model
        contentImageView.kf.setImage(model.imageUrl)
        titleLabel.text = model.title
        releaseDateLabel.text = secondsToHourMinutes(Int(model.duration))
        
        let rightButton: UIButton
        if model.fileUrl.isNilOrEmpty {
            rightButton = MGSwipeButton(title: "Delete", icon: nil, backgroundColor: self.backgroundColor, callback: { cell -> Bool in
                guard let cell = cell as? EpisodeTableViewCell else { return true }
                cell.delete()
                return true
            })
        }else {
            rightButton = MGSwipeButton(title: "Download", icon: nil, backgroundColor: self.backgroundColor, callback: { cell -> Bool in
                guard let cell = cell as? EpisodeTableViewCell else { return true }
                cell.download()
                return true
            })
        }

        let buttons = [rightButton]
        buttons.forEach {
            $0.setTitleColor(.white, for: .normal)
        }
        self.rightButtons = buttons
        self.swipeBackgroundColor = .clear
    }

    func download() {
        guard var model = model, let url = model.streamUrl else { return }
        if let task = ITunesService.share.downloadManager.fetchTask(url) {
            if self.task == nil {
                self.task = task
            }
        } else {
            task = ITunesService.share.downloadManager.download(url)
            task?.progress { [weak self] t in
                
            }.success { [weak self] t in
                guard let fileUrl = FilePath.share.save(episode: t.filePath) else { return }
                model.fileUrl = fileUrl
                model.updateDB()
                self?.configure(with: model)
            }.failure { [weak self] t in
                
            }
        }
    }
    
    func delete() {
        guard let fileUrl = model?.fileUrl else { return }
        
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
        } else if minute > 0 {
            return String(format: "%i min", minute)
        } else {
            return String(format: "%i s", seconds)
        }
    }
}

struct EpisodeCellRepresentable: UIViewRepresentable {
    var model: Episode

    func makeUIView(context: Context) -> EpisodeTableViewCell {
        let cell = EpisodeTableViewCell(style: .default, reuseIdentifier: "")
        cell.configure(with: model)
        return cell
    }

    func updateUIView(_ uiView: EpisodeTableViewCell, context: Context) {
    }
}
