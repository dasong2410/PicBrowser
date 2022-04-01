//
//  PicGallery.swift
//  PicsBrowser
//
//  Created by Marcus Mao on 3/1/22.
//

import SwiftUI
import SwiftSoup
import CoreData

struct PicGallery: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    let persistenceController = PersistenceController.shared
    
    @FetchRequest(
        entity: PostsEntity.entity(),
        sortDescriptors: []
    ) var favPosts: FetchedResults<PostsEntity>
    
    var url: String
    var title: String
    
    @State var isLiked: Bool = false
    
    var body: some View {
        let pics:[String] = extractPicSrcs(url: url)
        
        let columns = [
               GridItem(.flexible()),
               GridItem(.flexible()),
               GridItem(.flexible())
           ]
        
        //        NavigationView{
        GeometryReader{ geo in
            let w = geo.size.width/3+1.5
            let h = w
            ScrollView{
                LazyVGrid(columns: columns, alignment: .leading, spacing: 1) {
                    ForEach(0..<pics.count) { i in
                        NavigationLink {
                            PicDetail(picName: pics[i], pics: pics, idx: i)
                        } label: {
//                            AsyncImage(
//                                url: URL(string: pics[i]),
//                                transaction: Transaction(animation: .easeInOut)
//                            ) { phase in
//                                switch phase {
//                                case .empty:
//                                    ProgressView()
//                                case .success(let image):
//                                    image
//                                        .resizable()
//                                        .transition(.scale(scale: 0.1, anchor: .center))
//                                case .failure:
//                                    Image("PicNotFound")
//                                        .resizable()
//                                        .border(Color.gray, width: 0.5)
//                                @unknown default:
//                                    EmptyView()
//                                }
//                            }
//                            .scaledToFill()
//                            .frame(width: w, height: h)
//                            .clipped()
                            
                            ImageLoadingView(url: pics[i], w: w, h: h)
                        }
                    }
                }
                .onAppear() {
                    URLCache.shared.memoryCapacity = 1024 * 1024 * 300
                    print("Cache size: \(URLCache.shared.memoryCapacity/1024)KB")
                    
                    if (favPosts.contains { p in
                        p.url == self.url
                    }) {
                        isLiked = true
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
                            var cnt = objects.count
                            for i in (0..<cnt) {
                                var p = objects[i]
                                managedObjectContext.delete(p)
                            }
                        } catch {
                            // handle the Core Data error
                        }
                    } else {
                        let post = PostsEntity(context: managedObjectContext)
                        post.title = title
                        post.url = url
                        
                        do {
                            try managedObjectContext.save()
                        } catch {
                            // handle the Core Data error
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
        }
        
    }
}

func extractPicSrcs(url: String) -> [String]{
    var imgArray: [String] = []
    
    if let url = URL(string: url) {
        do {
            let contents = try String(contentsOf: url)
//            print(contents)
            
            do {
                let doc: Document = try SwiftSoup.parse(contents)
                let imgs: Elements = try doc.select("img")
                for img in imgs{
                    var src = try img.attr("ess-data")
                    if src==""{
                        src = try img.attr("data-src")
                        
                        if src==""{
                            continue
                        }
                        
                        src = "https:" + src
                    }
                    print(src)
                    imgArray.append(src)
                }
                return imgArray
            } catch Exception.Error(_, let message) {
                print(message)
            } catch {
                print(error)
            }
            
            return imgArray
        } catch {
            // contents could not be loaded
        }
    } else {
        // the URL was bad!
    }
    
    return imgArray
}

struct PicGallry_Previews: PreviewProvider {
    static var previews: some View {
        PicGallery(url: "https://www.t66y.com/htm_data/2202/7/4930114.html", title: "Test")
    }
}
