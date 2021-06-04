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
        var model = Podcast()
        model.trackName = "直到地狱尽头"
        model.artistName = "机核网"
        model.releaseDate = "2016-03-29"
        model.artworkUrl100 = "https://static.gcores.com/assets/52fcb59ad1e09abecec58d39da6731cb.jpg"
        return PodcastCell(model: model)
            .background(Color(R.color.defaultBackground.name))
            .previewLayout(.sizeThatFits)
    }
}
