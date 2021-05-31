//
//  EpisodeCell.swift
//  Podcast
//
//  Created by liuliu on 2021/5/31.
//

import Kingfisher
import SwiftUI

struct EpisodeCell: View {
    let model: Episode

    var body: some View {
        HStack(alignment: .top) {
            KFImage(URL(string: model.imageUrl ?? ""))
                .resizable()
                .frame(width: 80, height: 80)
            VStack(alignment: .leading, spacing: 15) {
                Text(model.title ?? "")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                Spacer()
                Text(secondsToHourMinutes(Int(model.duration)))
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(height: 80)
            .lineLimit(1)
            Spacer()
        }
        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
    }

    private func secondsToHourMinutes(_ seconds: Int) -> String {
        let hour = seconds / 3600
        let minute = seconds / 60 % 60

        if hour > 0 {
            return String(format: "%i h,%i min", hour, minute)
        } else if minute > 0 {
            return String(format: "%i min", minute)
        } else {
            return String(format: "%i s", seconds)
        }
    }
}

struct EpisodeCell_Previews: PreviewProvider {
    static var previews: some View {
        let model = Episode()
        model.title = "直到地狱尽头"
        model.imageUrl = "https://is5-ssl.mzstatic.com/image/thumb/Podcasts113/v4/88/22/ab/8822ab0a-448c-a8ae-66d3-f6d18f41268c/mza_4718731764701138855.jpg/200x200bb.png"
        model.duration = 3000
        return EpisodeCell(model: model)
            .background(Color(R.color.defaultBackground.name))
            .previewLayout(.sizeThatFits)
    }
}
