//
//  SpectrumView.swift
//  Podcast
//
//  Created by liuliu on 2021/6/2.
//

import SwiftUI

struct SpectrumView: View {
    var barWidth: CGFloat = 0
    var space: CGFloat = 0

    @Binding var spectra: [[Float]]

    var body: some View {
        GeometryReader { g in
            let space = self.space == 0 ? g.size.width / 239 : self.space
            let barWidth = self.barWidth == 0 ? space * 2 : self.barWidth
            HStack {
                if !spectra.isEmpty {
                    Path { p in
                        for (i, amplitude) in spectra[0].enumerated() {
                            let x = CGFloat(i) * (barWidth + space) + space
                            let y = translateAmplitudeToYPosition(height: g.size.height, amplitude: amplitude)
                            p.addRect(CGRect(x: x, y: y, width: barWidth, height: g.size.height - y))
                        }
                    }
                    .fill(
                        LinearGradient(gradient: .init(colors: [Color(red: 52 / 255.0, green: 232 / 255.0, blue: 158 / 255.0),
                                                                Color(red: 15 / 255.0, green: 52 / 255.0, blue: 67 / 255.0)]),
                        startPoint: .top, endPoint: .bottom)
                    )

                    if spectra.count > 1 {
                        Path { p in
                            for (i, amplitude) in spectra[1].enumerated() {
                                let x = CGFloat(spectra[1].count - 1 - i) * (barWidth + space) + space
                                let y = translateAmplitudeToYPosition(height: g.size.height, amplitude: amplitude)
                                p.addRect(CGRect(x: x, y: y, width: barWidth, height: g.size.height - y))
                            }
                        }
                        .fill(
                            LinearGradient(gradient: .init(colors: [Color(red: 194 / 255.0, green: 21 / 255.0, blue: 0 / 255.0),
                                                                    Color(red: 255 / 255.0, green: 197 / 255.0, blue: 0 / 255.0)]),
                            startPoint: .top, endPoint: .bottom)
                        )
                    }
                }
            }
        }
    }

    private func translateAmplitudeToYPosition(height: CGFloat, amplitude: Float) -> CGFloat {
        let barHeight = CGFloat(amplitude) * height
        return height - barHeight
    }
}

struct SpectrumView_Previews: PreviewProvider {
    static var previews: some View {
        SpectrumView(spectra: .constant([[0.1, 0.4, 0.3, 0.24, 0.28], [0.1, 0.4, 0.3]]))
            .previewLayout(.fixed(width: 320, height: 120))
    }
}
