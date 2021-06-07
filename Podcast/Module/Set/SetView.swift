//
//  SetView.swift
//  Podcast
//
//  Created by liuliu on 2021/5/28.
//

import Kingfisher
import SwiftUI

struct SetView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
        ZStack {
            Color(R.color.defaultBackground.name).ignoresSafeArea()
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Button(action: {
                                KingfisherManager.shared.cache.clearCache()
                                DB.share.clearUnImportant()
                                ITunesService.share.downloadManager.cache.clearDiskCache()
                            }) {
                                Text("Clear Cache").foregroundColor(.white)
                            }
                            Spacer()
                        }
                        HStack {
                            NavigationLink(destination: LicenseView()) {
                                Text("License").foregroundColor(.white)
                            }
                            Spacer()
                        }
                        HStack {
                            Button(action: {}) {
                                Text("Version").foregroundColor(.white)
                            }
                            Spacer()
                            Text(UIApplication.shared.version ?? "")
                                .foregroundColor(.white)
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
                Spacer().frame(height: 40)
            }
        }
        .navigationBarTitle(Text("Setting"), displayMode: .inline)
        }
    }
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        SetView()
    }
}
