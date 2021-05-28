//
//  UIStyleExtension.swift
//  Podcast
//
//  Created by liuliu on 2021/5/28.
//

import UIKit

extension UINavigationController {
    func baseStyle() {
        navigationBar.isTranslucent = false
        navigationBar.shadowImage = UIImage()
    }
}

extension UITextField {
    func searchStyle() {
        textColor = .white
        font = UIFont.systemFont(ofSize: 15)
        leftView = UIImageView(image: #imageLiteral(resourceName: "search_28x29"))
        leftViewMode = .always
        clearButtonMode = .always
        returnKeyType = .search
        enablesReturnKeyAutomatically = true
        autoresizingMask = [.flexibleWidth]
    }

    func modifyClearButton(with image: UIImage) {
        clearButtonMode = .never
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 27, height: 15)
        clearButton.contentMode = .center
        clearButton.addTarget(self, action: #selector(UITextField.clear(_:)), for: .touchUpInside)
        rightView = clearButton
        rightViewMode = .whileEditing
    }

    @objc func clear(_ sender: AnyObject) {
        text = ""
        sendActions(for: .editingChanged)
    }
}
