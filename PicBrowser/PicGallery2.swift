//
//  PicGallery.swift
//  PicsBrowser
//
//  Created by Marcus Mao on 3/1/22.
//

import SwiftUI
import SwiftSoup
import CoreData

struct PicGallery2: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    let persistenceController = PersistenceController.shared
    
    @EnvironmentObject var homeData: HomeViewModel
    
    // Will exit unexpectly when come from favs
    //    @FetchRequest(
    //        entity: PostsEntity.entity(),
    //        sortDescriptors: []
    //    ) var favPosts: FetchedResults<PostsEntity>
    
    var website: Website
    var url: String
    var title: String
    
    @State var isLiked: Bool = false
    
    init(website: Website, url: String, title: String) {
        self.website = website
        self.url = url
        self.title = title
        
        //        homeData.allImages.removeAll()
    }
    
    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        let w = getWidth()+1.5
        let h = w
        
        ScrollView{
            LazyVGrid(columns: columns, alignment: .leading, spacing: 1) {
                ForEach(homeData.allImages, id: \.self) { image in
                    GridImageView(url: image)
                        .scaledToFill()
                        .frame(width: w, height: h)
                        .clipped()
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button{
                if isLiked {
                    do {
                        // Create a fetch request with a string filter
                        // for an entity’s name
                        let fetchRequest: NSFetchRequest<PostsEntity> = PostsEntity.fetchRequest()
                        
                        fetchRequest.predicate = NSPredicate(
                            format: "url LIKE %@", url
                        )
                        
                        // Perform the fetch request to get the objects
                        // matching the predicate
                        let objects = try managedObjectContext.fetch(fetchRequest)
                        let cnt = objects.count
                        for i in (0..<cnt) {
                            let p = objects[i]
                            managedObjectContext.delete(p)
                        }
                    } catch {
                        // handle the Core Data error
                    }
                } else {
                    let post = PostsEntity(context: managedObjectContext)
                    post.websiteUrl = website.url
                    post.title = title
                    post.url = url
                    
                    do {
                        try managedObjectContext.save()
                    } catch {
                        // handle the Core Data error
                        print(error.localizedDescription)
                    }
                }
                
                isLiked.toggle()
            } label: {
                if isLiked {
                    Image(systemName: "heart.fill").foregroundColor(Color.red)
                } else {
                    Image(systemName: "heart").foregroundColor(Color.red)
                }
            }
        }
        .onAppear() {
            print("Cache size: \(URLCache.shared.memoryCapacity/1024)KB")
            
            let pics = extractPicSrcs(website: website, url: url)
            homeData.allImages.removeAll()
            homeData.allImages.append(contentsOf: pics)
            print("Image cnt: \(homeData.allImages.count)")
            
            do {
                let fetchRequest: NSFetchRequest<PostsEntity> = PostsEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(
                    format: "url LIKE %@", url
                )
                let posts = try managedObjectContext.fetch(fetchRequest)
                if posts.count>0 {
                    isLiked = true
                }
            } catch {
                print(error.localizedDescription)
            }
            
            //            if (favPosts.contains { p in
            //                p.url == self.url
            //            }) {
            //                isLiked = true
            //            }
        }
        
    }
    
    func getWidth() -> CGFloat {
        return UIScreen.main.bounds.width / 3
    }
}

struct PicGallry2_Previews: PreviewProvider {
    static var previews: some View {
        var website = Website(name: "草榴-新时代的我们", url: "https://www.t66y.com/thread0806.php?fid=8&search=&page=", listEncoding: .utf8, startWith: "htm_data/", prefix: "https://www.t66y.com/", title: "text", postEncoding: .utf8, imgTag: "img", imgAttr: "ess-data", imgPrefix: "")
        //        PicGallery2()
        ContentView()
    }
}
