//
//  Settings.swift
//  PicsBrowser
//
//  Created by Marcus Mao on 3/2/22.
//

import SwiftUI

struct Settings: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        VStack{
            NavigationView{
                List{
                    Section{
                        Toggle("Dark Mode", isOn: $isDarkMode)
                        
                        NavigationLink{
                            Favs()
                                .navigationTitle("My Favorites")
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            Text("Favorites")
                        }
                    }
                }
                .navigationTitle("Settings")
//                .navigationBarTitleDisplayMode(.inline)
            }
            
            Spacer()
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
