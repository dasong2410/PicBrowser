//
//  ContentView.swift
//  PicBrowser
//
//  Created by Marcus Mao on 2/28/22.
//

import SwiftUI
import SwiftSoup

struct ContentView: View {
    var body: some View {
        TabView{
            WebsiteList()
                .tabItem{
//                    Label("List", systemImage: "list.dash")
                    Image(systemName: "list.dash")
                }
            Settings()
                .tabItem{
//                    Label("Fav", systemImage: "star")
                    Image(systemName: "gear")
                }
        }
        // https://stackoverflow.com/questions/69309689/ios-15-swiftui-tabview-tab-bar-appearance-doesnt-update-between-views
        .onAppear {
            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
