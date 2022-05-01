//
//  PicDetailTabView.swift
//  PicBrowser
//
//  Created by Marcus Mao on 4/8/22.
//

import SwiftUI

struct ImageView: View {
    @EnvironmentObject var homeData: HomeViewModel
    @State var draggingOffset: CGSize = .zero
    @GestureState var press = false
    
    var body: some View {
        GeometryReader { proxy in
            //        ZStack {
            ScrollView(.init()) {
                TabView(selection: $homeData.selectedImageID) {
                    ForEach(homeData.allImages, id: \.self) { image in
                        LazyVStack {
                            ImageLoadingView(url: image)
                                .aspectRatio(contentMode: .fit)
//                                .cornerRadius(18)
                                .padding(.horizontal, 1)
                                .tag(image)
                                .scaleEffect(homeData.selectedImageID == image ? (homeData.imageScale > 1 ? homeData.imageScale : 1) : 1)
                            //                                .offset(y: homeData.imageViewerOffset.height)
                                .offset(homeData.imageViewerOffset)
//                                .position(x: 0, y: 0)
                                .gesture(
                                    MagnificationGesture()
                                        .onChanged({(value) in
//                                            homeData.imageScale = value<1 ? 1 : value
//                                            print("Image scale: \(homeData.imageScale)")
//                                            
                                            
                                            let delta = value / homeData.lastScaleValue
                                            homeData.lastScaleValue = value
                                            homeData.imageScale = homeData.imageScale * delta
                                            if homeData.imageScale<1 {
                                                homeData.imageScale = 1
                                            }
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
                                            }
                                        }))
                                    // has to be here, or can not disable tabview swipe when image is scaled
                                        .simultaneously(with: homeData.imageScale==1 ? nil :  DragGesture()
                                            .onChanged({ value in
                                                draggingOffset = value.translation
                                                homeData.onChange(value: draggingOffset)
                                            })
                                                .onEnded(homeData.onEnd(value:)))
                                )
                            
                                .onLongPressGesture {
                                    homeData.showSheet.toggle()
                                }
                            //                                .transition(.move(edge: .bottom))
                        }
                        .border(Color.red)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                //                .overlay(
                //                    Button {
                //                        withAnimation(.default) {
                //                            homeData.showSheet.toggle()
                //                        }
                //                    } label: {
                //                        Image(systemName: "square.and.arrow.up")
                //                            .foregroundColor(.blue)
                //                            .padding()
                //                    }
                //                        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                //                        .opacity(homeData.bgOpacity)
                //                    , alignment: .topTrailing
                //                )
            }
            .ignoresSafeArea()
            .border(Color.green)
//            .transition(.move(edge: .bottom))
            .gesture(DragGesture()
                .onChanged({ value in
                    var xx = proxy.frame(in: .local)
                    print("Min x: \(xx.minX)")
                    print("Max x: \(xx.maxX)")
                    print("Min y: \(xx.minY)")
                    print("Max x: \(xx.maxY)")
                    
                    xx = proxy.frame(in: .global)
                    print("Min x: \(xx.minX)")
                    print("Max x: \(xx.maxX)")
                    print("Min y: \(xx.minY)")
                    print("Max x: \(xx.maxY)")
                    
                    draggingOffset = value.translation
                    homeData.onChange(value: draggingOffset)
                })
                    .onEnded(homeData.onEnd(value:)))
            
            
            //            .gesture(DragGesture().onChanged({ value in
            //                draggingOffset = value.translation
            //                homeData.onChange(value: draggingOffset)
            //            }).onEnded(homeData.onEnd(value:)))
            //            .transition(.move(edge: .bottom))
            //            .transition(.scale)
            //        }
            //        .gesture(
            //            DragGesture()
            //                .onChanged({ value in
            //                    draggingOffset = value.translation
            //                    homeData.onChange(value: draggingOffset)
            //                })
            //                .onEnded(homeData.onEnd(value:)))
            //        .transition(.move(edge: .bottom))
            //        .transition(.scale)
        }
        .transition(.move(edge: .bottom))
    }
}

struct PicDetailTabView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView()
    }
}
