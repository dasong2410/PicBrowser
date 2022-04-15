//
//  PicDetailTabView.swift
//  PicBrowser
//
//  Created by Marcus Mao on 4/8/22.
//

import SwiftUI

struct ImageView: View {
    @EnvironmentObject var homeData: HomeViewModel
    //    @GestureState var draggingOffset: CGSize = .zero
    @State var draggingOffset: CGSize = .zero
    
    //    var imgs: [String] = [
    //        "https://s3.xoimg.com/i/2022/04/02/1zocfy.jpg",
    //        "https://s3.xoimg.com/i/2022/04/02/1zof8g.jpg",
    //        "https://s3.xoimg.com/i/2022/04/02/1zok9t.jpg",
    //        "https://s3.xoimg.com/i/2022/04/02/1zoist.jpg",
    //        "https://s3.xoimg.com/i/2022/04/02/1zol7u.jpg",
    //        "https://s3.xoimg.com/i/2022/04/02/1zoh33.jpg",
    //        "https://s3.xoimg.com/i/2022/04/02/1zoonc.jpg",
    //        "https://s3.xoimg.com/i/2022/04/02/1zoq4r.jpg",
    //        "https://s3.xoimg.com/i/2022/04/02/1zp5sv.jpg",
    //        "https://s3.xoimg.com/i/2022/04/02/1zskw8.jpg"
    //    ]
    
    var body: some View {
        ZStack {
            ScrollView(.init()) {
                TabView(selection: $homeData.selectedImageID) {
                    ForEach(homeData.allImages, id: \.self) { image in
                        LazyVStack {
                            ImageLoadingView(url: image)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(18)
                                .padding(.horizontal, 1)
                                .tag(image)
                                .scaleEffect(homeData.selectedImageID == image ? (homeData.imageScale > 1 ? homeData.imageScale : 1) : 1)
                                .offset(y: homeData.imageViewerOffset.height)
                                .gesture(
                                    MagnificationGesture()
                                        .onChanged({(value) in
                                            homeData.imageScale = value
                                        }).onEnded({(_) in
                                            withAnimation(.spring()){
//                                                homeData.imageScale = 1
                                            }
                                        })
                                        .simultaneously(with: TapGesture(count: 2).onEnded({
                                            withAnimation{
                                                homeData.imageScale = homeData.imageScale > 1 ? 1 : 4
                                            }
                                        }))
                                )
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .overlay(
                    Button {
                        withAnimation(.default) {
                            homeData.showSheet.toggle()
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.blue)
                            .padding()
                    }
                        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                        .opacity(homeData.bgOpacity)
                    , alignment: .topTrailing
                )
            }
            .ignoresSafeArea()
//            .gesture(DragGesture().onChanged({ value in
//                draggingOffset = value.translation
//                homeData.onChange(value: draggingOffset)
//            }).onEnded(homeData.onEnd(value:)))
//            .transition(.move(edge: .bottom))
//            .transition(.scale)
        }
        .gesture(DragGesture().onChanged({ value in
            draggingOffset = value.translation
            homeData.onChange(value: draggingOffset)
        }).onEnded(homeData.onEnd(value:)))
        .transition(.move(edge: .bottom))
//        .transition(.scale)
    }
}

struct PicDetailTabView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView()
    }
}
