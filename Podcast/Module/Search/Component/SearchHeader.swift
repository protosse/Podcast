//
//  SearchHeader.swift
//  Podcast
//
//  Created by liuliu on 2021/5/31.
//

import SwiftUI

struct SearchHeader: View {
    let placeHolder: String
    @Binding var searchText: String
    let onCommit: VoidBlock
    let onCancel: VoidBlock

    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                PlaceholderTextField(placeholder: Text(placeHolder).foregroundColor(.gray), text: $searchText, commit: onCommit)
                    .foregroundColor(.white)

                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                }

                Button(action: onCancel) {
                    Text("Cancel")
                }
            }
            .padding(.horizontal, 15)

            Color.accentColor.frame(height: 2)
        }
    }
}

struct SearchHeader_Previews: PreviewProvider {
    static var previews: some View {
        SearchHeader(placeHolder: "Podcast", searchText: .constant(""), onCommit: {}, onCancel: {})
            .background(Color(R.color.barTint.name))
            .previewLayout(.sizeThatFits)
    }
}
