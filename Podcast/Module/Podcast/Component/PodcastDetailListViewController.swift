//
//  PodcastDetailListViewController.swift
//  Podcast
//
//  Created by liuliu on 2021/6/1.
//

import JXPagingView
import MGSwipeTableCell
import SwiftUI
import UIKit

class PodcastDetailListViewController: BaseViewController, BindableType, HasSubscriptions {
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?

    var viewModel: PodcastViewModel!

    var dataSource: [Episode] = []

    override var isHideNavigationWhenWillAppear: Bool {
        return true
    }

    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = R.color.defaultBackground()
        $0.keyboardDismissMode = .onDrag
        $0.estimatedRowHeight = 44
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
        $0.tableFooterView = UIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let loadingView = LoadingView(isPlayGame: true)
        loadingView.configAnimationLayout = { $0.top = 30 }
        self.loadingView = loadingView
        configTableView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin.top().left().right().bottom(view.pin.safeArea)
    }

    func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellWithClass: EpisodeTableViewCell.self)
        view.addSubview(tableView)
    }

    func bindViewModel() {
        viewModel.$dataSource
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                self?.dataSource = data
                self?.tableView.reloadData()

                // 如果在tableView中直接使用viewModel.dataSource
                // reloadData会出现dataSource没有更新的情况
                // 必须delay一定时间才能获取到更新的数据
            })
            .store(in: &subscriptions)

        viewModel.$refreshState.removeDuplicates()
            .sink { [weak self] state in
                switch state {
                case .content:
                    self?.endLoading()
                case .loading:
                    self?.startLoading()
                case .error:
                    self?.endLoading()
                case .empty:
                    break
                }
            }
            .store(in: &subscriptions)

        viewModel.fetchEpisode()
    }
}

extension PodcastDetailListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: EpisodeTableViewCell.self)
        let model = dataSource[indexPath.row]
        cell.configure(with: model)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        present(UIHostingController(rootView: PlayerView(episode: model).environmentObject(AudioPlayerManager.share)), animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
}

// MARK: JXPagingViewListViewDelegate

extension PodcastDetailListViewController: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return view
    }

    func listScrollView() -> UIScrollView {
        return tableView
    }

    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> Void) {
        listViewDidScrollCallback = callback
    }
}

extension PodcastDetailListViewController: StatefulViewController {
    func hasContent() -> Bool {
        return !dataSource.isEmpty
    }
}
