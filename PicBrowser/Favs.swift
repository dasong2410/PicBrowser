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
    
    var website = Website(name: "草榴-新时代的我们", url: "https://www.t66y.com/thread0806.php?fid=8&search=&page=", listEncoding: .utf8, startWith: "htm_data/", prefix: "https://www.t66y.com/", title: "text", postEncoding: .utf8, imgTag: "img", imgAttr: "ess-data", imgPrefix: "")
    
    //        @FetchRequest(
    //            entity: PostsEntity.entity(),
    //            sortDescriptors: []
    //        ) var posts: FetchedResults<PostsEntity>
    
    @State var posts: [PostsEntity] = []
    
    var body: some View {
        List(posts, id: \.self) { p in
            if let websiteUrl = p.websiteUrl {
                let websites: [Website] = websiteList.filter { $0.url == websiteUrl }
                
                if websites.count>0 {
                    if let url = p.url, let title = p.title {
                        
                        let website = websites[0]
                        NavigationLink {
                            PicGallery2(website: website, url: url, title: title)
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
        .onAppear() {
            do {
                let fetchRequest: NSFetchRequest<PostsEntity> = PostsEntity.fetchRequest()
                posts = try managedObjectContext.fetch(fetchRequest)
            } catch {
                print(error.localizedDescription)
            }
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
    }
}

struct Favs_Previews: PreviewProvider {
    static var previews: some View {
        Favs()
    }
}
