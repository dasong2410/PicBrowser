//
//  ArtList.swift
//  PicBrowser
//
//  Created by Marcus Mao on 3/1/22.
//

import SwiftUI
import SwiftSoup
import CoreData

struct PostListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject private var postList: PostList
    var website: Website
    
    init(website: Website){
        self.website = website
        self.postList = PostList(website: self.website)
        self.postList.extractPosts()
    }
    
    var body: some View {
        VStack{
            ScrollViewReader{ proxy in
                HStack{
                    Button {
                        if postList.currPageNo>1{
                            postList.currPageNo -= 1
                            postList.extractPosts()
                            proxy.scrollTo(0, anchor: .bottom)
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    Text("Page: \(postList.currPageNo)")
                    Spacer()
                    
                    Button {
                        postList.currPageNo += 1
                        postList.extractPosts()
                        proxy.scrollTo(0, anchor: .bottom)
                    } label: {
                        Image(systemName: "arrow.right")
                    }
                    .buttonStyle(.bordered)
                }.padding(5)
                
                List{
                    ForEach(postList.posts, id: \.url){ item in
                        NavigationLink {
                            PicGallery2(website: website, url: item.url, title: item.title)
                        } label: {
                            Text(item.title)
                        }
                        .id(item.id)
                    }
                }
                .navigationTitle(website.name)
                .navigationBarTitleDisplayMode(.inline)
                .refreshable {
                    print("Refresh list")
                    self.postList.extractPosts()
                }
            }
        }
    }
}

struct ArtList_Previews: PreviewProvider {
    static var previews: some View {
        PostListView(website: Website(name: "草榴-新时代的我们", url: "https://www.t66y.com/thread0806.php?fid=8&search=&page=", listEncoding: .utf8, startWith: "htm_data/", prefix: "https://www.t66y.com/", title: "text", postEncoding: .utf8, imgTag: "img", imgAttr: "ess-data", imgPrefix: ""))
    }
}
