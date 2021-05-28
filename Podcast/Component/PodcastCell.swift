//
//  PodcastCell.swift
//  Podcast
//
//  Created by liuliu on 2021/5/28.
//

import Kingfisher
import SwiftUI

struct PodcastCell: View {
    let model: Podcast

    var body: some View {
        HStack(alignment: .top) {
            KFImage(URL(string: model.artworkUrl100 ?? ""))
                .resizable()
                .frame(width: 80, height: 80)
            VStack(alignment: .leading, spacing: 15) {
                Text(model.trackName ?? "")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                Text(model.artistName ?? "")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.8))
                Text(model.releaseDate ?? "")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.8))
            }
            .lineLimit(1)
            Spacer()
        }
        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
    }
}

struct PodcastCell_Previews: PreviewProvider {
    static var previews: some View {
        let model = Podcast()
        model.trackName = "郭德纲相声十年经典"
        model.artistName = "德云社郭德纲相声"
        model.releaseDate = "2016-03-29"
        model.artworkUrl100 = "https://is5-ssl.mzstatic.com/image/thumb/Podcasts113/v4/88/22/ab/8822ab0a-448c-a8ae-66d3-f6d18f41268c/mza_4718731764701138855.jpg/200x200bb.png"
        return PodcastCell(model: model)
            .background(Color(R.color.defaultBackground.name))
            .previewLayout(.sizeThatFits)
    }
}
