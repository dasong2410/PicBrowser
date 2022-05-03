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

    var body: some View {
            NavigationView{
                List {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                    
                    NavigationLink{
                        Favs()
                            .navigationTitle("Favorites")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Text("Favorites")
                    }
                }
                .navigationTitle("Settings")
            }
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
