//
//  GridImageView.swift
//  PicBrowser
//
//  Created by Marcus Mao on 4/9/22.
//

import SwiftUI

struct GridImageView: View {
    @EnvironmentObject var homeData: HomeViewModel
    var url: String
    
    var body: some View {
        Button {
//            withAnimation(.easeIn) {
//                homeData.selectedImageID = url
//                homeData.showImageViewer.toggle()
//                homeData.hideStatusBar.toggle()
//            }
//            print("Image url: \(url)")
            homeData.selectedImageID = url
            homeData.showImageViewer.toggle()
            homeData.hideStatusBar.toggle()
        } label: {
            ImageLoadingView(url: url)
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct GridImageView_Previews: PreviewProvider {
    static var previews: some View {
//        GridImageView(index: 1)
        ContentView()
    }
}
