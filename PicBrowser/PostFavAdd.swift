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
    @State private var selected: String = ""
    @State var s = 2
    
    var body: some View {
        Form {
            Picker("Website", selection: $selected) {
                ForEach(websiteList, id: \.name) { w in
                    Text(w.name)
                }
            }
//            Picker("Please choose website", selection: $s) {
//                ForEach(1..<10) {
//                    Text("\($0) people")
//                }
//            }
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
                let websites: [Website] = websiteList.filter { $0.name == selected }
                let website = websites[0]
                
                let post = PostsEntity(context: managedObjectContext)
                post.websiteUrl = website.url
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
