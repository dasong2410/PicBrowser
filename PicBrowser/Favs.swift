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
    @State var posts: [PostsEntity] = []
    
    let persistenceController = PersistenceController.shared
    
    var body: some View {
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
                                if let idx = posts.firstIndex(of: p) {
                                    posts.remove(at: idx)
                                }
                                
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
