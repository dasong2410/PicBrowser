//
//  HomeViewModel.swift
//  PicBrowser
//
//  Created by Marcus Mao on 4/9/22.
//

import SwiftUI
import SwiftSoup

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
    
    @Published var showImageViewer: Bool = false
    @Published var selectedImageID: String = ""
    @Published var selectedImageSize: CGSize = .zero
    
    @Published var imageViewerOffset: CGSize = .zero
    @Published var dragOffsetAcc: CGSize = .zero
    
    @Published var bgOpacity: Double = 1
    @Published var imageScale: CGFloat = 1
    @Published var lastScaleValue: CGFloat = 1
    
    @Published var showSheet: Bool = false
    @Published var hideStatusBar: Bool = false
    
    func onChange(value: CGSize) {
        var w = value.width + dragOffsetAcc.width
        var h = value.height + dragOffsetAcc.height
        
        let halHeight = UIScreen.main.bounds.height / 2
        let progress = imageViewerOffset.height / halHeight
        
        if imageScale == 1 {
            withAnimation(.default) {
                bgOpacity = Double(1 - (progress < 0 ? -progress : progress))
            }
            
            // when scale=1, don't change x-axis value
            w = imageViewerOffset.width
        } else {
            let scaleRatio = imageScale-1>0 ? imageScale-1 : 0
            
            var dragWidth = (scaleRatio*selectedImageSize.width - (UIScreen.main.bounds.width - selectedImageSize.width))/2
            dragWidth = dragWidth>0 ? dragWidth : 0
            w = abs(w)>dragWidth ? (w>0 ? dragWidth : -dragWidth) : w
            
            var dragHeight = (scaleRatio*selectedImageSize.height - (UIScreen.main.bounds.height - selectedImageSize.height))/2
            dragHeight = dragHeight>0 ? dragHeight : 0
            h = abs(h)>dragHeight ? (h>0 ? dragHeight : -dragHeight) : h
        }
        
        imageViewerOffset = CGSize(width: w, height: h)
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
                    dragOffsetAcc = .zero
                    bgOpacity = 1
                } else {
                    showImageViewer.toggle()
                    
                    imageViewerOffset = .zero
                    dragOffsetAcc = .zero
                    bgOpacity = 1
                    
                    hideStatusBar.toggle()
                }
            } else {
                dragOffsetAcc = imageViewerOffset
                print("Offset: \(imageViewerOffset)")
            }
        }
    }
    
    func extractImages(website: Website, url: String) {
        allImages.removeAll()
        
        if let url = URL(string: url) {
            do {
                let contents = try String(contentsOf: url, encoding: website.postEncoding)
    //            print(contents)
                
                do {
                    let doc: Document = try SwiftSoup.parse(contents)
                    let imgTags: Elements = try doc.select(website.imgTag)
                    for img in imgTags {
                        print("Tag info: \(img)")
                        
                        var src = try img.attr(website.imgAttr)
                        let txt = try img.text()
                        
                        if src.isEmpty || !txt.isEmpty {
                            continue
                        } else {
                            src = website.imgPrefix + src
                        }
                        
                        print("Image src: \(src)")
                        if !allImages.contains(where: { tagSrc in
                            src == tagSrc
                        }) {
                            // some image url may contain Chinese chars
                            allImages.append(src.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? src)
                        } else {
                            print("Image \(src) is already extracted.")
                        }
                    }
                } catch Exception.Error(_, let message) {
                    print(message)
                } catch {
                    print(error)
                }
            } catch {
                // contents could not be loaded
                print(error)
            }
        } else {
            // the URL was bad!
            print("The URL was bad!")
        }
    }
}
