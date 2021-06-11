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
import MBProgressHUD

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

    let downloadPercentLabel = UILabel().then {
        $0.textColor = UIColor.white.withAlphaComponent(0.8)
        $0.font = .systemFont(ofSize: 12)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = R.color.defaultBackground()
        selectionStyle = .none
        swipeBackgroundColor = .clear
        contentView.addSubviews([contentImageView, titleLabel, releaseDateLabel, downloadPercentLabel])
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
            .marginLeft(16).marginBottom(8).sizeToFit()
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

        if let task = self.task, task.status == .running {
            downloadPercentLabel.isHidden = false
            rightButtons = []
        } else {
            downloadPercentLabel.isHidden = true
            let rightButton: UIButton
            if !model.fileUrl.isNilOrEmpty {
                rightButton = MGSwipeButton(title: "Delete", icon: nil, backgroundColor: backgroundColor, callback: { cell -> Bool in
                    guard let cell = cell as? EpisodeTableViewCell else { return true }
                    cell.delete()
                    return true
                })
            } else {
                rightButton = MGSwipeButton(title: "Download", icon: nil, backgroundColor: backgroundColor, callback: { cell -> Bool in
                    guard let cell = cell as? EpisodeTableViewCell else { return true }
                    cell.download()
                    return true
                })
            }

            let buttons = [rightButton]
            buttons.forEach {
                $0.setTitleColor(.white, for: .normal)
            }
            rightButtons = buttons
        }
    }

    func download() {
        guard let model = model, let url = model.streamUrl else { return }
        if let task = ITunesService.share.downloadManager.fetchTask(url) {
            self.task = task
            switch task.status {
            case .running:
                break
            default:
                ITunesService.share.downloadManager.start(task)
                downloadPercentLabel.isHidden = false
                rightButtons = []
                refreshButtons(false)
            }
        } else {
            task = ITunesService.share.downloadManager.download(url)
            downloadPercentLabel.isHidden = false
            rightButtons = []
            refreshButtons(false)
        }

        task?.progress { [weak self] t in
            guard let self = self else { return }
            self.downloadPercentLabel.text = String(format: "%.2f%%", t.progress.fractionCompleted * 100)
            self.downloadPercentLabel.pin
                .bottom(to: self.contentImageView.edge.bottom)
                .right(10).sizeToFit()
        }.success { [weak self] t in
            guard let fileUrl = FilePath.share.save(episode: t.filePath) else { return }
            model.fileUrl = fileUrl
            model.updateDB()
            self?.configure(with: model)
            self?.refreshButtons(false)
        }.failure { t in
            if let error = t.error, let window = UIWindow.key {
                let hud = MBProgressHUD.showAdded(to: window, animated: true).then {
                    $0.mode = .text
                    $0.bezelView.style = .solidColor
                    $0.detailsLabel.font = UIFont.systemFont(ofSize: 15)
                    $0.detailsLabel.text = error.localizedDescription
                    $0.removeFromSuperViewOnHide = true
                }
                hud.hide(animated: true, afterDelay: 2)
            }
        }
    }

    func delete() {
        guard let model = model, let fileUrl = model.fileUrl, let url = model.streamUrl else { return }
        FilePath.share.delete(episode: fileUrl)
        ITunesService.share.downloadManager.remove(url)
        model.fileUrl = nil
        model.updateDB()
        configure(with: model)
        refreshButtons(false)
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
