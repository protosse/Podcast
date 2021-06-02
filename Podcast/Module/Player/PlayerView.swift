//
//  PlayerView.swift
//  Podcast
//
//  Created by liuliu on 2021/6/2.
//

import Kingfisher
import SwiftUI
import UIKit
import WebKit

struct PlayerView: View {
    @ObservedObject var viewModel: PlayerViewModel
    @ObservedObject var audioPlayerManager = AudioPlayerManager.share

    @State var htmlHeight: CGFloat = 0

    init(episode: Episode) {
        viewModel = PlayerViewModel(episode: episode)
    }

    var body: some View {
        let url = URL(string: viewModel.episode.imageUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        return VStack {
            SpectrumView(spectra: $audioPlayerManager.spectra)
                .frame(height: 50)
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    KFImage(url)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                    HStack {
                        Text(viewModel.episode.title ?? "")
                            .font(.system(size: 16))
                        Spacer(minLength: 10)
                        Button(action: {}) {
                            Image(systemName: "play.fill")
                        }
                        .frame(width: 35, height: 35)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                    }
                    Text(viewModel.episode.author ?? "")
                        .font(.system(size: 12))
                    WebView(htmlString: viewModel.episode.desc ?? "", dynamicHeight: $htmlHeight)
                        .frame(height: htmlHeight)
                }
                .padding(.all, 10)
            }
        }
        .onLoad(perform: load)
    }

    func load() {
//        audioPlayerManager.play(episode: viewModel.episode)
    }
}

struct WebView: UIViewRepresentable {
    var htmlString: String
    @Binding var dynamicHeight: CGFloat
    var webView: WKWebView = WKWebView()

    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .clear
        if htmlString != context.coordinator.content {
            context.coordinator.content = htmlString
            let html =
                """
                <html>
                <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
                <style type="text/css">
                img {margin-left:3px;width:100%;height:auto;}
                video {margin-left:3px;width:100%;height:auto;}
                body {margin-left:10px;margin-top:10px;margin-right:10px;}
                </style>
                </head>
                <body>\(htmlString)</body>
                </html>
                """
            webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var content = ""

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.readyState", completionHandler: { complete, _ in
                if complete != nil {
                    webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { height, _ in
                        DispatchQueue.main.async {
                            self.parent.dynamicHeight = height as? CGFloat ?? 0
                        }
                    })
                }
            })
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let episode = Episode()
        episode.title = "25位小朋友眼里的成人世界"
        episode.desc = "<p>故事FM ❜ 第 507 期</p>\n<p>&nbsp;</p>\n<p><span style=\"color: #ff0000;\">* </span>本期节目由儿童家居设计品牌 PUPUPULA 赞助播出</p>\n<p>&nbsp;</p>\n<p>各位大朋友、小朋友好，明天就是一年一度的六一儿童节了。和往年一样，本年度的六一特供也保准能让你收获非常快乐的二十分钟。</p>\n<p>在这期节目里，我们的听众们采访了自己的孩子，询问了他们一些成年人日常思考的问题。小孩的思维方式总是和大人不太一样，听听他们怎么说，也许能让你对生活有点新的认识。</p>\n<p>/Staff/<br />\n讲述者 | 登登 汉堡 张连欣 小恩 双儿 刘依阳 瓜瓜<br />\n殷可玥 开开 梁几何 胡鸯鸯 小耳朵儿 乖乖 堂堂 徐可欣<br />\nCookie 鲁止一 小梦 丁韬瑜 婷婷 乐乐 劳埃德 钱钱 果果<br />\n主播 | @寇爱哲<br />\n制作人 | 刘逗<br />\n声音设计 | 孙泽雨<br />\n实习生 | 李士萌<br />\n文字整理 | 李士萌<br />\n校对 | 乔正禹<br />\n运营 | 翌辰 雨露</p>\n<p>/BGM List/<br />\n01.Story FM Theme Music box &#8211; 桑泉（片头曲)<br />\n02.Frets Pretty Damn Intriguing（保姆伴）<br />\n03.Deep Saffron &#8211; Brian Eno（张叔叔）<br />\n04.A Train &#8211; 彭寒（后悔）<br />\n05.Chris Remo &#8211; Cottonwood Hike（玉梅）<br />\n06.Chris Remo &#8211; Hidden Away（分手）<br />\n07.The Box &#8211; 彭寒（片尾曲）</p>\n<p>&nbsp;</p>\n<p><strong>用你的声音，讲述你的故事。故事FM 是一档亲历者自述的声音节目，每周一三五更新。在以下渠道均可收听我们的节目：</strong></p>\n<p>苹果播客 | 网易云音乐 | 喜马拉雅<br />\n蜻蜓FM | 荔枝FM | 懒人听书<br />\n小宇宙 | QQ音乐 | 酷狗音乐 | 酷我音乐<br />\nSpotify | Google Podcast</p>\n<p><img class=\"aligncenter wp-image-2525 size-large\" src=\"https://static.storyfm.cn/media/2021/04/Banner-1-1024x1024.jpg\" alt=\"\" width=\"1024\" height=\"1024\" srcset=\"https://static.storyfm.cn/media/2021/04/Banner-1-1024x1024.jpg 1024w, https://static.storyfm.cn/media/2021/04/Banner-1-150x150.jpg 150w, https://static.storyfm.cn/media/2021/04/Banner-1-300x300.jpg 300w, https://static.storyfm.cn/media/2021/04/Banner-1-768x768.jpg 768w, https://static.storyfm.cn/media/2021/04/Banner-1-882x882.jpg 882w\" sizes=\"(max-width: 1024px) 100vw, 1024px\" /></p>\n"
        episode.author = "kouaizhe"
        episode.imageUrl = "https://static.storyfm.cn/media/2020/01/600x600-满.jpg"
        episode.streamUrl = "https://static.storyfm.cn/media/2021/05/beijing-metro-youth-guide-1.mp3"
        episode.duration = 1277
        return PlayerView(episode: episode)
    }
}
