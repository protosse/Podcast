//
//  SetView.swift
//  Podcast
//
//  Created by liuliu on 2021/5/28.
//

import SwiftUI

struct SetView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color(R.color.defaultBackground.name).ignoresSafeArea()
            VStack {
                Text("Setting").foregroundColor(.white)
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Button(action: {}) {
                                Text("Clear Cache").foregroundColor(.white)
                            }
                            Spacer()
                        }
                        HStack {
                            Button(action: {}) {
                                Text("About").foregroundColor(.white)
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 15)
                }
                Button(action: {}) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark").foregroundColor(.white)
                    }
                    .frame(width: 50, height: 50)
                    .background(Color.accentColor)
                    .clipShape(Circle())
                }
            }
        }
    }
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        SetView()
    }
}
