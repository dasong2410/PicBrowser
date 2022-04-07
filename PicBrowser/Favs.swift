//
//  Favs.swift
//  PicBrowser
//
//  Created by Marcus Mao on 3/30/22.
//

import SwiftUI
import CoreData

struct Favs: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    let persistenceController = PersistenceController.shared
//    @State var isPresented: Bool = false
    
    //    @FetchRequest(
    //        entity: PostsEntity.entity(),
    //        sortDescriptors: []
    //    ) var posts: FetchedResults<PostsEntity>
    
    @State var posts: [PostsEntity] = []
    
    //    var favPosts:[PostInfo] = [
    //        PostInfo(title: "[寫真] 迷人的一生有你就好好的 [22P]", url: "https://www.t66y.com/htm_data/2203/8/4992564.html"),
    //        PostInfo(title: "[寫真] 春红似水柔情蜜意惹人爱 [22P]", url: "https://www.t66y.com/htm_data/2203/8/4992548.html"),
    //        PostInfo(title: "[歐美] 体验一下性的美妙绝伦 [22P]", url: "https://www.t66y.com/htm_data/2203/8/4992439.html"),
    //        PostInfo(title: "[歐美] 欧美金发美妞儿顶着住吗[29P]", url: "https://www.t66y.com/htm_data/2203/8/4992408.html"),
    //        PostInfo(title: "[歐美] 白罗斯模特皮肤白皙身材迷人[20P]", url: "https://www.t66y.com/htm_data/2203/8/4992371.html")
    //    ]
    
    var body: some View {
//        List {
            List(posts, id: \.self) { p in
                if let websiteUrl = p.websiteUrl {
                    let websites: [Website] = websiteList.filter { $0.url == websiteUrl }
                    
                    if websites.count>0 {
                        if let url = p.url, let title = p.title {
                            
                            let website = websites[0]
                            NavigationLink {
                                PicGallery(website: website, url: url, title: title)
                            } label: {
                                Text(title)
                            }
                            .swipeActions(allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    print("Deleting conversation")
                                    PersistenceController.shared.delete(p)
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                        }
                    }
                }
                
            }
//            .onDelete(perform: deleteFavPost)
            
            //            Text("Count: \(posts[0].postTitle!)")
            //                let indices = posts.indices
            //
            //                ForEach(indices){ i in
            //                    let p = posts[i]
            //                    if let url = p.url, let title = p.title {
            //                        NavigationLink {
            //    //                        PicGallery(url: url, title: title, isLiked: true)
            //                            PicGallery(url: url, title: title)
            //                        } label: {
            //                            Text(title)
            //                        }
            //                        .swipeActions(allowsFullSwipe: false) {
            //                            Button(role: .destructive) {
            //                                print("Deleting conversation")
            //                            } label: {
            //                                Label("Delete", systemImage: "trash.fill")
            //                            }
            //                        }
            //                    }
            //
            //                }
//        }
        .onAppear() {
            do {
                // Create a fetch request with a string filter
                // for an entity’s name
                let fetchRequest: NSFetchRequest<PostsEntity> = PostsEntity.fetchRequest()
                
                //                fetchRequest.predicate = NSPredicate(
                //                    format: "url LIKE %@", url
                //                )
                
                // Perform the fetch request to get the objects
                // matching the predicate
                posts = try managedObjectContext.fetch(fetchRequest)
                //                var cnt = posts.count
            } catch {
                // handle the Core Data error
            }
            
            //            var cnt = posts.count
            //            print(cnt)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                NavigationLink {
                    PostFavAddView()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
//        .sheet(isPresented: $isPresented) {
//            PostFavAddView()
//        }
    }
    
    func deleteFavPost(at offsets: IndexSet) {
        for index in offsets {
            let post = posts[index]
            PersistenceController.shared.delete(post)
        }
    }
}

struct Favs_Previews: PreviewProvider {
    static var previews: some View {
        Favs()
    }
}
