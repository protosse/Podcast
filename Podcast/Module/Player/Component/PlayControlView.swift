//
//  PlayControlView.swift
//  Podcast
//
//  Created by liuliu on 2021/6/3.
//

import Introspect
import SwiftUI

struct PlayControlView: View {
    @ObservedObject var audioPlayerManager = AudioPlayerManager.share

    @State private var draggedOffset: CGFloat = 0
    @State private var isShowFull = false

    @State private var labelWidth: CGFloat?

    var onSetTap: VoidBlock?
    var onPlayListTap: VoidBlock?

    var body: some View {
        VStack(spacing: 0) {
            topBar()
            if isShowFull {
                fullControl()
            } else {
                simpleControl()
            }
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
        .background(Color.white)
        .cornerRadius(10, corners: [.topLeft, .topRight])
        .background(
            VStack {
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 20)
                    .cornerRadius(10, corners: [.topLeft, .topRight])
                    .shadow(radius: 4)
                Spacer()
            }
        )
        .offset(y: draggedOffset)
    }

    fileprivate func topBar() -> some View {
        HStack {
            Spacer()
            Rectangle()
                .fill(Color.secondary)
                .frame(width: 40, height: 4)
                .cornerRadius(5)
            Spacer()
        }
        .contentShape(Rectangle())
        .frame(height: 30)
        .gesture(
            DragGesture()
                .onChanged({ value in
                    let offsetY = value.translation.height
                    withAnimation(.interactiveSpring()) {
                        self.draggedOffset = offsetY
                    }
                })
                .onEnded({ value in
                    let offsetY = value.translation.height
                    self.isShowFull = offsetY > 0 ? false : true
                    withAnimation(.interactiveSpring()) {
                        self.draggedOffset = 0
                    }
                })
        )
        .onTapGesture {
            withAnimation(.interactiveSpring()) {
                self.isShowFull.toggle()
            }
        }
    }

    fileprivate func fullControl() -> some View {
        VStack(spacing: 10) {
            HStack {
                Text(secondsToHourMinutes(Int(audioPlayerManager.currentPlayTime)))
                    .equalWidth($labelWidth)
                slider()
                Text(secondsToHourMinutes(Int(audioPlayerManager.currentItemDuration)))
                    .equalWidth($labelWidth)
            }
            .accentColor(Color(R.color.boulder.name))
            .font(.system(size: 14))

            controlButtons()
                .padding(.horizontal, 10)
                .accentColor(.black)

            Spacer().frame(height: 0)

            setButtons()
                .padding(.horizontal, 10)
                .accentColor(.black)
        }
        .accentColor(.black)
    }

    fileprivate func simpleControl() -> some View {
        HStack(spacing: 20) {
            playButton()
            slider()
            playModeButton()
        }
        .padding(.horizontal, 10)
        .accentColor(.black)
    }

    fileprivate func slider() -> some View {
        Slider(value: $audioPlayerManager.currentProgress, in: 0 ... 100) { move in
            if !move {
                audioPlayerManager.seek(progress: audioPlayerManager.currentProgress)
            }
        }
        .introspectSlider {
            let size: CGFloat = 20
            let image = UIImage(color: .lightGray, size: CGSize(width: size, height: size)).withRoundedCorners(radius: size / 2)
            $0.setThumbImage(image, for: .normal)
        }
    }

    fileprivate func playButton() -> some View {
        Button(action: {
            audioPlayerManager.pauseOrResume()
        }, label: {
            Image(systemName: audioPlayerManager.isPlaying ? "pause.fill" : "play.fill")
                .resizable()
                .frame(width: 25, height: 25)
        })
    }

    fileprivate func playModeButton() -> some View {
        Button(action: {
            audioPlayerManager.modeLoop()
        }, label: {
            Image(systemName: audioPlayerManager.mode.imageName)
        })
    }

    fileprivate func controlButtons() -> some View {
        HStack {
            Button(action: {
                audioPlayerManager.seek(timeOffset: -10)
            }, label: {
                Image(systemName: "gobackward.10")
            })
            Spacer()

            Button(action: {
                audioPlayerManager.previous()
            }, label: {
                Image(systemName: "backward.fill")
            })
            Spacer()

            playButton()
            Spacer()

            Button(action: {
                audioPlayerManager.next()
            }, label: {
                Image(systemName: "forward.fill")
            })
            Spacer()

            Button(action: {
                audioPlayerManager.seek(timeOffset: 10)
            }, label: {
                Image(systemName: "goforward.10")
            })
        }
    }

    fileprivate func setButtons() -> some View {
        HStack {
            Button(action: {
                onSetTap?()
            }, label: {
                Image(systemName: "gearshape.fill")
            })
            Spacer()

            Button(action: {
                onPlayListTap?()
            }, label: {
                Image(systemName: "music.note.list")
            })
            Spacer()

            playModeButton()
        }
    }

    private func secondsToHourMinutes(_ seconds: Int) -> String {
        return String(format: "%02i:%02i", seconds / 60, seconds % 60)
    }
}

struct PlayControlView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            PlayControlView()
                .previewLayout(.sizeThatFits)
        }
    }
}
