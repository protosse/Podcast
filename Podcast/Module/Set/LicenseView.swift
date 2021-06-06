//
//  LicenseView.swift
//  Podcast
//
//  Created by liuliu on 2021/6/6.
//

import AcknowList
import SwiftUI
import UIKit

struct LicenseView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<LicenseView>) -> AcknowListViewController {
        return AcknowListViewController()
    }

    func updateUIViewController(
        _ uiViewController: AcknowListViewController, context: UIViewControllerRepresentableContext<LicenseView>) {
    }
}
