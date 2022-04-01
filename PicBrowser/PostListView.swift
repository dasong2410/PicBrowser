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
    var website: Website
    @ObservedObject private var posts: PostList
    @State var favPosts: [PostsEntity]?
    
    @FetchRequest(
        entity: PostsEntity.entity(),
        sortDescriptors: []
    ) var dbPosts: FetchedResults<PostsEntity>
    
    init(website: Website){
        self.website = website
        self.posts = PostList(website: self.website)
        self.posts.extractPosts()
        
//        favPosts = loadQuestion()
    }
    
    func loadQuestion() -> [PostsEntity]? {
        let fetchRequest: NSFetchRequest<PostsEntity> = PostsEntity.fetchRequest()

        do {
            let array = try managedObjectContext.fetch(fetchRequest) as [PostsEntity]
            return array
        } catch let errore {
            print("error FetchRequest \(errore)")
        }

        return nil
    }
    
    var body: some View {
        VStack{
            ScrollViewReader{ proxy in
                HStack{
                    Button {
                        if posts.currPageNo>1{
                            posts.currPageNo -= 1
                            posts.extractPosts()
                            proxy.scrollTo(0, anchor: .bottom)
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    Text("Page: \(posts.currPageNo)")
                    Spacer()
                    
                    Button {
                        posts.currPageNo += 1
                        posts.extractPosts()
                        proxy.scrollTo(0, anchor: .bottom)
                    } label: {
                        Image(systemName: "arrow.right")
                    }
                    .buttonStyle(.bordered)
                }.padding(5)
                
                List{
//                    ForEach(posts.posts, id: \.src){ item in
//                        NavigationLink {
//                            PicGallery(url: item.src, title: item.title)
//                        } label: {
//                            Text(item.title)
//                        }
//                    }
                    
                    // out of index if not define this var
                    let indices = posts.posts.indices
//                    var cnt = indices.count
                    ForEach(indices) { i in
                        let item = posts.posts[i]
                        NavigationLink {
                            PicGallery(url: item.src, title: item.title)
                        } label: {
                            Text(item.title)
                        }
                        .id(i)
                    }
                }
                .navigationTitle(website.name)
                .navigationBarTitleDisplayMode(.inline)
                .refreshable {
                    print("Refresh list")
                }
            }
        }
    }
}

struct ArtList_Previews: PreviewProvider {
    static var previews: some View {
        PostListView(website: Website(name: "草榴-新时代的我们", url: "https://www.t66y.com/thread0806.php?fid=8&search=&page=", encoding: .utf8, startWith: "htm_data/", prefix: "https://www.t66y.com/", title: "text"))
    }
}
