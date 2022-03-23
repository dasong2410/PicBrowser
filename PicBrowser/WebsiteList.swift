//
//  WebsiteList.swift
//  PicsBrowser
//
//  Created by Marcus Mao on 3/2/22.
//

import SwiftUI
import SwiftSoup

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

struct WebsiteList: View {
    
    var body: some View {
        NavigationView{
            List{
                ForEach(websiteList, id: \.url){w in
//                    NavigationLink {
//                        PostListView(website: w)
//                    } label: {
//                        Text(w.name)
//                    }
                    
                    NavigationLink(destination: NavigationLazyView(PostListView(website: w))) {
                        Text(w.name)
                    }
                }
            }
            .navigationTitle("Website List")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct WebsiteList_Previews: PreviewProvider {
    static var previews: some View {
        WebsiteList()
    }
}
