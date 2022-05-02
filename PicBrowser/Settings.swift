//
//  Settings.swift
//  PicsBrowser
//
//  Created by Marcus Mao on 3/2/22.
//

import SwiftUI

struct Settings: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @EnvironmentObject var homeData: HomeViewModel
    
//    var website = Website(name: "草榴-新时代的我们", url: "https://www.t66y.com/thread0806.php?fid=8&search=&page=", listEncoding: .utf8, startWith: "htm_data/", prefix: "https://www.t66y.com/", title: "text", postEncoding: .utf8, imgTag: "img", imgAttr: "ess-data", imgPrefix: "")
    
    var body: some View {
            NavigationView{
                List {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                    
//                    NavigationLink(destination: NavigationLazyView(Favs().navigationTitle("My Favorites").navigationBarTitleDisplayMode(.inline))) {
//                        Text("Favorites")
//                    }
                    NavigationLink{
                        Favs()
                            .navigationTitle("Favorites")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Text("Favorites")
                    }
                    
//                    PicGallery(website: website, url: "https://www.t66y.com/htm_data/2202/7/4930114.html", title: "Test")
                }
                .navigationTitle("Settings")
                //                .navigationBarTitleDisplayMode(.inline)
            }
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
