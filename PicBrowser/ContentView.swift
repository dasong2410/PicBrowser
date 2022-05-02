//
//  ContentView.swift
//  PicBrowser
//
//  Created by Marcus Mao on 2/28/22.
//

import SwiftUI
import SwiftSoup

struct ContentView: View {
    @StateObject var homeData = HomeViewModel()
    
//    init() {
//        UIScrollView.appearance().bounces = false
//    }
    
    var body: some View {
        TabView{
            WebsiteList()
                .tabItem{
                    Image(systemName: "list.dash")
                }
            
            Settings()
                .tabItem{
                    Image(systemName: "gear")
                }
        }
        /* https://stackoverflow.com/questions/69309689/ios-15-swiftui-tabview-tab-bar-appearance-doesnt-update-between-views */
        .onAppear {
            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
            
            URLCache.shared.memoryCapacity = 1024 * 1024 * 300
        }
        .overlay(
            ZStack {
                if homeData.showImageViewer {
                    Color.black
                        .opacity(homeData.bgOpacity)
                        .ignoresSafeArea()

                    ImageView()
//                    Text("Selected image id: \(homeData.selectedImageID)")
                }
            }
                .ignoresSafeArea()
                .edgesIgnoringSafeArea(.all)
            
        )
        .sheet(isPresented: $homeData.showSheet) {
            if let data = try? Data(contentsOf: URL(string: homeData.selectedImageID)!) {
                if let image = UIImage(data: data) {
                    ShareSheet(items: [image])
                }
            }
        }
        .statusBar(hidden: homeData.hideStatusBar)
        .environmentObject(homeData)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
