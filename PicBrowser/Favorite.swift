//
//  Settings.swift
//  PicsBrowser
//
//  Created by Marcus Mao on 3/2/22.
//

import SwiftUI

struct Favorite: View {
    var body: some View {
        NavigationView{
            List{
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                Text("Hello, World!")
                Text("Hello, World!")
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
            .navigationTitle("My Favorite")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Favorite()
    }
}
