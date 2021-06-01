//
//  PodcastDetailListViewController.swift
//  Podcast
//
//  Created by liuliu on 2021/6/1.
//

import JXPagingView
import UIKit

class PodcastDetailListViewController: BaseViewController {
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?

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

        configTableView()
    }

    func configTableView() {
        tableView.delegate = self
        view.addSubview(tableView)
    }
}

extension PodcastDetailListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
