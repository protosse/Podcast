//
//  PlayControlView.swift
//  Podcast
//
//  Created by liuliu on 2021/6/3.
//

import Introspect
import SwiftUI

struct PlayControlView: View {
    @State var progress: Double = 0.5

    var body: some View {
        VStack(spacing: 10) {
            Rectangle()
                .fill(Color(white: 0.667))
                .frame(width: 40, height: 4)
                .cornerRadius(5)

            HStack {
                Text("00:00")
                Slider(value: $progress, in: 0 ... 1)
                    .introspectSlider {
                        let size: CGFloat = 20
                        let image = UIImage(color: .lightGray, size: CGSize(width: size, height: size)).withRoundedCorners(radius: size / 2)
                        $0.setThumbImage(image, for: .normal)
                    }
                Text("00:00")
            }
            .accentColor(Color(R.color.boulder.name))
            .font(.system(size: 14))

            HStack {
                Button(action: {}, label: {
                    Image(systemName: "play.fill")
                })
                Spacer()

                Button(action: {}, label: {
                    Image(systemName: "play.fill")
                })
                Spacer()

                Button(action: {}, label: {
                    Image(systemName: "play.fill")
                })
                Spacer()

                Button(action: {}, label: {
                    Image(systemName: "play.fill")
                })
                Spacer()

                Button(action: {}, label: {
                    Image(systemName: "play.fill")
                })
            }
            .accentColor(.black)
            
            HStack {
                Button(action: {}, label: {
                    Image(systemName: "play.fill")
                })
                Spacer()

                Button(action: {}, label: {
                    Image(systemName: "play.fill")
                })
                Spacer()

                Button(action: {}, label: {
                    Image(systemName: "play.fill")
                })
            }
            .accentColor(.black)
        }
        .padding(.all, 10)
    }
}

struct PlayControlView_Previews: PreviewProvider {
    static var previews: some View {
        PlayControlView()
            .previewLayout(.sizeThatFits)
            .frame(width: 320)
    }
}
