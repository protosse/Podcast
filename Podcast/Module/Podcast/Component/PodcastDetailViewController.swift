//
//  PodcastDetailViewController.swift
//  Podcast
//
//  Created by liuliu on 2021/5/31.
//

import JXPagingView
import JXSegmentedView
import MJRefresh
import PinLayout
import SwiftUI
import Then
import UIKit

class PodcastDetailViewController: BaseViewController, HasSubscriptions {
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

    override var isHideNavigationWhenWillAppear: Bool {
        return true
    }

    var pagingView: JXPagingView!

    lazy var segmentedViewDataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.titles = Segment.titles
        dataSource.titleNormalColor = .white.withAlphaComponent(0.6)
        dataSource.titleSelectedColor = .white
        dataSource.isTitleColorGradientEnabled = true
        return dataSource
    }()

    lazy var segmentedView = JXSegmentedView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)).then {
        let line = JXSegmentedIndicatorLineView()
        line.indicatorWidth = 40
        line.indicatorColor = R.color.accentColor() ?? .red
        $0.indicators = [line]
        $0.backgroundColor = R.color.defaultBackground()
    }

    lazy var headerView = PodcastDetailHeaderView()

    var viewModel: PodcastViewModel!

    init(viewModel: PodcastViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)
        headerView.configure(with: viewModel.podcast)

        segmentedView.delegate = self
        segmentedView.dataSource = segmentedViewDataSource

        pagingView = JXPagingView(delegate: self)
        pagingView.mainTableView.backgroundColor = R.color.defaultBackground()
        view.addSubview(pagingView)
        segmentedView.listContainer = pagingView.listContainerView

        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let popGesture = navigationController?.interactivePopGestureRecognizer {
            popGesture.isEnabled = (segmentedView.selectedIndex == 0)
            pagingView.listContainerView.scrollView.panGestureRecognizer.require(toFail: popGesture)
            pagingView.mainTableView.panGestureRecognizer.require(toFail: popGesture)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pagingView.pin.top().left().right().bottom(view.pin.safeArea)
    }

    func bindViewModel() {
        viewModel.$isCollected
            .assign(to: \.isSelected, on: headerView.collectButton)
            .store(in: &subscriptions)

        headerView.collectButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self, !self.viewModel.dataSource.isEmpty else { return }
                self.viewModel.collectToggle()
            }
            .store(in: &subscriptions)
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
            let vc = PodcastDetailListViewController()
            vc.bind(to: viewModel)
            return vc
        case .detal:
            let vc = PodcastDetailContentViewController()
            vc.bind(to: viewModel)
            return vc
        }
    }
}

extension JXPagingListContainerView: JXSegmentedViewListContainer {}

extension PodcastDetailViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (index == 0)
    }
}

struct PodcastDetailRepresentation: UIViewControllerRepresentable {
    var viewModel: PodcastViewModel

    func makeUIViewController(context: UIViewControllerRepresentableContext<PodcastDetailRepresentation>) -> PodcastDetailViewController {
        return PodcastDetailViewController(viewModel: viewModel)
    }

    func updateUIViewController(
        _ uiViewController: PodcastDetailViewController, context: UIViewControllerRepresentableContext<PodcastDetailRepresentation>) {
    }
}
