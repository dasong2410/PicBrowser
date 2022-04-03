//
//  PostFavAdd.swift
//  PicBrowser
//
//  Created by Marcus Mao on 4/2/22.
//

import SwiftUI

struct PostFavAddView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var title: String = ""
    @State var url: String = ""
    
    var body: some View {
        Form {
            HStack {
                Text("Title")
                    .frame(width: 40, alignment: .leading)
                TextField("Post title", text: $title)
            }
            HStack {
                Text("Url")
                    .frame(width: 40, alignment: .leading)
                TextField("Post url", text: $url)
            }
        }
        .toolbar {
            Button("Done"){
                let post = PostsEntity(context: managedObjectContext)
                post.title = title
                post.url = url
                
                do {
                    try managedObjectContext.save()
                } catch {
                    // handle the Core Data error
                }
                
                mode.wrappedValue.dismiss()
            }
        }
    }
}

struct PostFavAdd_Previews: PreviewProvider {
    static var previews: some View {
        PostFavAddView()
    }
}
