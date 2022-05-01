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
    @Published var dragOffsetAcc: CGSize = .zero
    
    @Published var bgOpacity: Double = 1
    @Published var imageScale: CGFloat = 1
    @Published var lastScaleValue: CGFloat = 1
    
    @Published var showSheet = false
    @Published var hideStatusBar = false
    @Published var swipe = true
    
    func onChange(value: CGSize) {
//        imageViewerOffset = value
        
        imageViewerOffset = CGSize(width: value.width + dragOffsetAcc.width, height: value.height + dragOffsetAcc.height)
        
        let halHeight = UIScreen.main.bounds.height / 2
        let progress = imageViewerOffset.height / halHeight
        
        if imageScale == 1 {
            withAnimation(.default) {
                bgOpacity = Double(1 - (progress < 0 ? -progress : progress))
            }
        }
    }
    
    func onEnd(value: DragGesture.Value) {
        withAnimation(.easeOut) {
            if imageScale == 1 {
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
            } else {
                dragOffsetAcc = imageViewerOffset
                print("Offset: \(imageViewerOffset)")
            }
        }
    }
}
