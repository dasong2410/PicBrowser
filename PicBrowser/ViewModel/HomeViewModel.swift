//
//  HomeViewModel.swift
//  PicBrowser
//
//  Created by Marcus Mao on 4/9/22.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var allImages: [String] = []
//    ["https://s3.xoimg.com/i/2022/04/02/1zocfy.jpg",
//                                          "https://s3.xoimg.com/i/2022/04/02/1zof8g.jpg",
//                                          "https://s3.xoimg.com/i/2022/04/02/1zok9t.jpg",
//                                          "https://s3.xoimg.com/i/2022/04/02/1zoist.jpg",
//                                          "https://s3.xoimg.com/i/2022/04/02/1zol7u.jpg",
//                                          "https://s3.xoimg.com/i/2022/04/02/1zoh33.jpg",
//                                          "https://s3.xoimg.com/i/2022/04/02/1zoonc.jpg",
//                                          "https://s3.xoimg.com/i/2022/04/02/1zoq4r.jpg",
//                                          "https://s3.xoimg.com/i/2022/04/02/1zp5sv.jpg",
//                                          "https://s3.xoimg.com/i/2022/04/02/1zskw8.jpg"]
    
    @Published var showImageViewer = false
    @Published var selectedImageID: String = ""
    
    @Published var imageViewerOffset: CGSize = .zero
    
    @Published var bgOpacity: Double = 1
    @Published var imageScale: CGFloat = 1
    
    @Published var showSheet = false
    @Published var hideStatusBar = false
    
    func onChange(value: CGSize) {
        imageViewerOffset = value
        
        let halHeight = UIScreen.main.bounds.height / 2
        let progress = imageViewerOffset.height / halHeight
        
        withAnimation(.default) {
            bgOpacity = Double(1 - (progress < 0 ? -progress : progress))
        }
    }
    
    func onEnd(value: DragGesture.Value) {
        withAnimation(.easeOut) {
            var translation = value.translation.height
            
            if translation < 0 {
                translation = -translation
            }
            
            if translation < 80 {
                imageViewerOffset = .zero
                bgOpacity = 1
            } else {
                showImageViewer.toggle()
                imageViewerOffset = .zero
                bgOpacity = 1
                
                hideStatusBar.toggle()
            }
        }
    }
}
