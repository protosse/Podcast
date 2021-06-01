//
//  PodcastDetailViewController.swift
//  Podcast
//
//  Created by liuliu on 2021/5/31.
//

import JXPagingView
import JXSegmentedView
import PinLayout
import SwiftUI
import Then
import UIKit

class PodcastDetailViewController: BaseViewController {
    enum Segment: Int, CaseIterable {
        case list, detal

        var desc: String {
            switch self {
            case .list:
                return "Episodes"
            case .detal:
                return "Detail"
            }
        }

        static var titles: [String] {
            return Segment.allCases.map { $0.desc }
        }
    }

    var pagingView: JXPagingView!

    lazy var segmentedViewDataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.titles = Segment.titles
        dataSource.titleNormalColor = UIColor.white.withAlphaComponent(0.6)
        dataSource.titleSelectedColor = UIColor.white
        dataSource.isTitleColorGradientEnabled = true
        dataSource.reloadData(selectedIndex: 0)
        return dataSource
    }()

    lazy var segmentedView = JXSegmentedView().then {
        let line = JXSegmentedIndicatorLineView()
        line.indicatorWidth = 40
        line.indicatorColor = R.color.accentColor() ?? .red
        $0.indicators = [line]
        $0.backgroundColor = R.color.defaultBackground()
    }

    lazy var lineView = GradientLineView().then {
        let color = R.color.accentColor() ?? .red
        $0.gradientColors = [color, color, color].map { $0.cgColor }
        $0.gradientAnimateColors = [color, color.adjust(by: 1.5), color].map { $0.cgColor }
    }

    lazy var headerView = PodcastDetailHeaderView()

    lazy var listVC = PodcastDetailListViewController()

    var podcast: Podcast!

    init(podcast: Podcast) {
        super.init(nibName: nil, bundle: nil)
        self.podcast = podcast
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(lineView)

        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)
        headerView.configure(with: podcast)
        segmentedView.dataSource = segmentedViewDataSource
        pagingView = JXPagingView(delegate: self)
        pagingView.mainTableView.backgroundColor = R.color.defaultBackground()
        view.addSubview(pagingView)
        segmentedView.listContainer = pagingView.listContainerView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        lineView.pin.top().left().right().height(2)
        pagingView.pin.below(of: lineView).left().right().bottom(view.pin.safeArea)

        segmentedView.frame = CGRect(x: 0, y: 0, width: view.width, height: 50)
    }
}

extension PodcastDetailViewController: JXPagingViewDelegate {
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return Int(headerView.height)
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return headerView
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return Int(segmentedView.height)
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentedView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return Segment.allCases.count
    }

    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        let segment = Segment(rawValue: index)!
        switch segment {
        case .list:
            return listVC
        case .detal:
            return listVC
        }
    }
}

extension JXPagingListContainerView: JXSegmentedViewListContainer {}

struct PodcastDetailRepresentation: UIViewControllerRepresentable {
    var podcast: Podcast

    func makeUIViewController(context: UIViewControllerRepresentableContext<PodcastDetailRepresentation>) -> PodcastDetailViewController {
        return PodcastDetailViewController(podcast: podcast)
    }

    func updateUIViewController(
        _ uiViewController: PodcastDetailViewController, context: UIViewControllerRepresentableContext<PodcastDetailRepresentation>) {
    }
}
