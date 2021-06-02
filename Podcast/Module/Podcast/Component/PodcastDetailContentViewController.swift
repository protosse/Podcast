//
//  PodcastDetailContentViewController.swift
//  Podcast
//
//  Created by liuliu on 2021/6/1.
//

import ActiveLabel
import JXPagingView
import UIKit

class PodcastDetailContentViewController: BaseViewController, BindableType, HasSubscriptions {
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?

    var viewModel: PodcastViewModel!

    override var isHideNavigationWhenWillAppear: Bool {
        return true
    }

    lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = R.color.defaultBackground()
        $0.showsHorizontalScrollIndicator = false
    }

    lazy var contentLabel = ActiveLabel().then {
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.font = .boldSystemFont(ofSize: 14)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        scrollView.addSubview(contentLabel)

        let urlType = ActiveType.urlType
        let emailType = ActiveType.emailType
        contentLabel.customize { label in
            label.enabledTypes = [urlType, emailType]
            label.customColor[urlType] = R.color.accentColor()
            label.customColor[emailType] = R.color.accentColor()
        }

        contentLabel.handleCustomTap(for: emailType) { email in
            let urlString = "mailto:\(email)"
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }

        contentLabel.handleCustomTap(for: urlType) { string in
            if let url = URL(string: string) {
                UIApplication.shared.open(url)
            }
        }

        view.addSubview(scrollView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.pin.all()
        layout()
    }

    func configure(_ title: String?) {
        contentLabel.text = title
        layout()
        scrollView.contentSize.height = contentLabel.bottom + 10
    }

    func layout() {
        contentLabel.pin.top(10).horizontally(10).sizeToFit(.width)
    }

    func bindViewModel() {
        viewModel.$podcast
            .sink { [weak self] podcast in
                self?.configure(podcast.summary)
            }
            .store(in: &subscriptions)
    }
}

// MARK: JXPagingViewListViewDelegate

extension PodcastDetailContentViewController: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return view
    }

    func listScrollView() -> UIScrollView {
        return scrollView
    }

    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> Void) {
        listViewDidScrollCallback = callback
    }
}

// MARK: UITableViewDelegate

extension PodcastDetailContentViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
}

extension ActiveType {
    static let urlType = ActiveType.custom(pattern: #"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)"#)
    static let emailType = ActiveType.custom(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
}
