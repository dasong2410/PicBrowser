//
//  PicDetail.swift
//  PicBrowser
//
//  Created by Marcus Mao on 2/28/22.
//

import SwiftUI

struct PicDetail: View {
    @State var picName: String
    
    @State var scale: CGFloat = 1.0
    @State var lastScaleValue: CGFloat = 1.0
    @State var dragOffset = CGSize.zero
    @State var dragOffsetAcc = CGSize.zero
    var pics:[String] = []
    @State var idx: Int = 0
    
    
    @State var startPos : CGPoint = .zero
    @State var isSwipping = true
    
    @State private var location: CGPoint = .zero
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil // 1
    
    var body: some View {
        VStack{
            AsyncImage(url: URL(string: picName)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .aspectRatio(contentMode: .fit)
            .scaleEffect(scale)
//            .position(location)
            .offset(dragOffset)
            .gesture(
                MagnificationGesture()
                    .onChanged { val in
                        let delta = val / lastScaleValue
                        self.lastScaleValue = val
                        scale = scale * delta
                        if scale<1 {
                            scale = 1
                        }
                        //                scale = val
                        
                        //... anything else e.g. clamping the newScale
                        
                        
                    }
                    .onEnded { val in
                        // without this the next gesture will be broken
                        self.lastScaleValue = 1.0
                    }
            )
            .simultaneousGesture(
                DragGesture()
                    .onChanged { gesture in
                        if scale != 1 {
                            dragOffset = CGSize(width: gesture.translation.width + dragOffsetAcc.width, height: gesture.translation.height + dragOffsetAcc.height)
                        }
                        
                        if self.isSwipping {
                            self.startPos = gesture.location
                            self.isSwipping.toggle()
                        }
                    }
                    .onEnded { gesture in
                        if scale == 1 {
                            let xDist =  abs(gesture.location.x - self.startPos.x)
                            let yDist =  abs(gesture.location.y - self.startPos.y)
                            if self.startPos.x > gesture.location.x && yDist < xDist {
                                // left
                                if idx<pics.count-1 {
                                    idx += 1
                                    print("Next pic: \(idx)")
                                    picName = pics[idx]
                                }
                            }
                            else if self.startPos.x < gesture.location.x && yDist < xDist {
                                // right
                                if idx>0 {
                                    idx -= 1
                                    print("Next pic: \(idx)")
                                    picName = pics[idx]
                                }
                            }
                            self.isSwipping.toggle()
                        } else {
                            dragOffsetAcc = dragOffset
                        }
                    }
            )
            .onTapGesture(count: 2) {
                scale = 1
                dragOffset = .zero
            }
        }
    }
}

struct PicDetail_Previews: PreviewProvider {
    static var previews: some View {
        PicDetail(picName: "https://sxopic.com/i/2022/03/01/a36z3b.jpeg")
    }
}
