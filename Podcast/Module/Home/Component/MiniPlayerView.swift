//
//  MiniPlayerView.swift
//  Podcast
//
//  Created by liuliu on 2021/5/27.
//

import SwiftUI

struct MiniPlayerView: View {
    private let buttonWidth: CGFloat = 54
    @State var progress: CGFloat = 0

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "rosette")
                    .frame(width: 40, height: 40)
                Text("asd")
                    .font(.system(size: 13))
                    .foregroundColor(.white)
                    .lineLimit(1)
                Spacer()
            }
            .visualEffect()
            .frame(height: 80)
            .background(Color(.white).opacity(0.1))
            .overlay({
                PlayButton(width: buttonWidth, progress: $progress)
                    .offset(x: -50, y: -buttonWidth / 2)
            }(), alignment: .topTrailing)
            .onTapGesture {
            }
        }
        .background(Color(.clear))
    }
}

struct PlayButton: View {
    var width: CGFloat = 54
    @Binding var progress: CGFloat

    private let lineWidth: CGFloat = 5

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: min(self.progress, 1.0))
                .stroke(style: StrokeStyle(lineWidth: lineWidth,
                                           lineCap: .round,
                                           lineJoin: .round))
                .foregroundColor(.accentColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)

            Button(action: {}) {
                Image(systemName: "play.fill")
            }
            .frame(width: width - lineWidth, height: width - lineWidth)
            .background(Color.white)
            .clipShape(Circle())
        }
        .frame(width: width, height: width)
    }
}

struct MiniPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        MiniPlayerView()
            .previewLayout(.fixed(width: 320, height: 120))
            .background(Color(R.color.defaultBackground.name))
    }
}
