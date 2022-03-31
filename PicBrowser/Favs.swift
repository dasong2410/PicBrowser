//
//  Favs.swift
//  PicBrowser
//
//  Created by Marcus Mao on 3/30/22.
//

import SwiftUI

struct Favs: View {
    var favPosts:[PostInfo] = [
        PostInfo(title: "[寫真] 迷人的一生有你就好好的 [22P]", url: "https://www.t66y.com/htm_data/2203/8/4992564.html"),
        PostInfo(title: "[寫真] 春红似水柔情蜜意惹人爱 [22P]", url: "https://www.t66y.com/htm_data/2203/8/4992548.html"),
        PostInfo(title: "[歐美] 体验一下性的美妙绝伦 [22P]", url: "https://www.t66y.com/htm_data/2203/8/4992439.html"),
        PostInfo(title: "[歐美] 欧美金发美妞儿顶着住吗[29P]", url: "https://www.t66y.com/htm_data/2203/8/4992408.html"),
        PostInfo(title: "[歐美] 白罗斯模特皮肤白皙身材迷人[20P]", url: "https://www.t66y.com/htm_data/2203/8/4992371.html")
    ]
    var body: some View {
        List {
            ForEach(favPosts, id: \.url){ p in
                NavigationLink {
                    PicGallery(url: p.url, title: p.title)
                } label: {
                    Text(p.title)
                }
                .swipeActions(allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        print("Deleting conversation")
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }
                }
            }
            
        }
    }
}

struct Favs_Previews: PreviewProvider {
    static var previews: some View {
        Favs()
    }
}
