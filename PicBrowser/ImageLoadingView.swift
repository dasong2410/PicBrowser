//
//  ImageLoadingView.swift
//  PicBrowser
//
//  Created by Marcus Mao on 3/31/22.
//

import SwiftUI

struct ImageLoadingView: View {
    @StateObject var imageLoader: ImageLoader
//    @ObservedObject var imageLoader: ImageLoader
    var url: String
//    var url: String {
//        didSet {
//            imageLoader.fetch()
//        }
//    }
//    var w: CGFloat?
//    var h: CGFloat?
    
    init(url: String?/*, w: CGFloat?, h: CGFloat?*/) {
        self._imageLoader = StateObject(wrappedValue: ImageLoader(url: url))
        self.url = url!
//        self.w = w
//        self.h = h
    }
    
    var body: some View {
        ZStack {
            if imageLoader.image != nil {
                Image(uiImage: imageLoader.image!)
                    .resizable()
                    .scaledToFill()
//                    .frame(width: w, height: h)
//                    .clipped()
            } else if imageLoader.errorMessage != nil {
                Text(imageLoader.errorMessage!)
                    .foregroundColor(Color.pink)
//                    .frame(width: w, height: h)
                
                Image("PicNotFound")
                    .resizable()
//                    .frame(width: w, height: h)
                    .border(Color.gray, width: 0.5)
            } else {
                ProgressView()
//                    .frame(width: w, height: h)
            }
        }
//        .frame(width: w, height: h)
        /* sometimes onAppear will not be called, not sure if it is a bug */
        .onAppear() {
            print("ImageLoadingView appear: \(url)")
//            imageLoader.fetch()
        }
        .onDisappear() {
            print("ImageLoadingView disappear: \(url)")
        }
    }
}

struct ImageLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ImageLoadingView(url: nil)
    }
}
