//
//  PodcastDetailViewController.swift
//  Podcast
//
//  Created by liuliu on 2021/5/31.
//

import JXPagingView
import JXSegmentedView
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
}

struct PodcastDetailRepresentation: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<PodcastDetailRepresentation>) -> PodcastDetailViewController {
        return PodcastDetailViewController()
    }

    func updateUIViewController(
        _ uiViewController: PodcastDetailViewController, context: UIViewControllerRepresentableContext<PodcastDetailRepresentation>) {
    }
}
