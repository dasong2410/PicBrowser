//
//  WebsitesEditView.swift
//  PicBrowser
//
//  Created by Marcus Mao on 3/30/22.
//

import SwiftUI

struct WebsitesEditView: View {
    var body: some View {
        List {
            ForEach(websiteList, id: \.url) { w in
                Text(w.name)
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
        .toolbar {
            Button {
                
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

struct WebsitesCfgListView_Previews: PreviewProvider {
    static var previews: some View {
        WebsitesEditView()
    }
}
