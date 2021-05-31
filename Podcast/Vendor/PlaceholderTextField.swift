//
//  PlaceholderTextField.swift
//  Podcast
//
//  Created by liuliu on 2021/5/31.
//

import SwiftUI

struct PlaceholderTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> Void = { _ in }
    var commit: () -> Void = { }

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}

struct PlaceholderTextField_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderTextField(placeholder: Text("Podcast").foregroundColor(.red), text: .constant(""))
    }
}
