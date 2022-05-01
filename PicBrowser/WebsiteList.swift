//
//  WebsiteList.swift
//  PicBrowser
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
                    .swipeActions(allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            print("Deleting website configuration")
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
                    .swipeActions(allowsFullSwipe: false) {
                        Button {
                            print("Modifying website configuration")
                        } label: {
                            Label("Modify", systemImage: "pencil")
                        }
                    }
                }
            }
            .navigationTitle("Websites")
//            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct WebsiteList_Previews: PreviewProvider {
    static var previews: some View {
        WebsiteList()
    }
}
