//
//  PicDetailTabView.swift
//  PicBrowser
//
//  Created by Marcus Mao on 4/8/22.
//

import SwiftUI

struct ImageView: View {
    @EnvironmentObject var homeData: HomeViewModel
    @GestureState var press: Bool = false
    @State private var viewSize: CGSize = CGSize.zero
    
    var body: some View {
        ScrollView(.init()) {
            TabView(selection: $homeData.selectedImageID) {
                ForEach(homeData.allImages, id: \.self) { image in
                    LazyVStack {
                        ImageLoadingView(url: image)
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 0.5)
                            .tag(image)
                            .scaleEffect(homeData.selectedImageID == image ? (homeData.imageScale > 1 ? homeData.imageScale : 1) : 1)
                            .offset(homeData.imageViewerOffset)
                            .gesture(
                                MagnificationGesture()
                                    .onChanged({(value) in
                                        let delta = value / homeData.lastScaleValue
                                        homeData.lastScaleValue = value
                                        homeData.imageScale = homeData.imageScale * delta
                                        
                                        homeData.imageScale = homeData.imageScale<1 ? 1 : (homeData.imageScale>3 ? 3 : homeData.imageScale)
                                    }).onEnded({ value in
                                        withAnimation(.spring()){
                                            homeData.lastScaleValue = 1
                                            
                                            if homeData.imageScale == 1 {
                                                homeData.imageViewerOffset = .zero
                                                homeData.dragOffsetAcc = .zero
                                                homeData.bgOpacity = 1
                                            }
                                        }
                                    })
                                    .simultaneously(with: TapGesture(count: 2).onEnded({
                                        withAnimation{
                                            homeData.imageScale = homeData.imageScale > 1 ? 1 : 3
                                            homeData.imageViewerOffset = .zero
                                            homeData.dragOffsetAcc = .zero
                                            homeData.bgOpacity = 1
                                            
                                            //                                            print("Image: \(homeData.selectedImageID)")
                                            //                                            print("Image size: \(homeData.selectedImageSize.width) \(homeData.selectedImageSize.height)")
                                            //                                            print("Scale: \(homeData.imageScale)")
                                            //                                            print("Image size(scaled): \(homeData.selectedImageSize.width * homeData.imageScale) \(homeData.selectedImageSize.height * homeData.imageScale)")
                                        }
                                    }))
                                // has to be here, or can not disable tabview swipe when image is scaled
                                    .simultaneously(with: homeData.imageScale==1 ? nil :  DragGesture()
                                        .onChanged({ value in
                                            //                                                draggingOffset = value.translation
                                            homeData.onChange(value: value.translation)
                                        })
                                            .onEnded(homeData.onEnd(value:)))
                            )
                            .onLongPressGesture {
                                homeData.showSheet.toggle()
                            }
                    }
                    .size { size in
                        homeData.selectedImageSize = size
                    }
                    //                        .border(Color.red)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .ignoresSafeArea()
        //            .border(Color.green)
        .transition(.move(edge: .bottom))
        .gesture(DragGesture()
            .onChanged({ value in
                //                    draggingOffset = value.translation
                homeData.onChange(value: value.translation)
            })
                .onEnded(homeData.onEnd(value:)))
    }
}

// https://stackoverflow.com/questions/57577462/get-width-of-a-view-using-in-swiftui
extension View {
    func size(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geo.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

struct PicDetailTabView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView()
    }
}
