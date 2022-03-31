//
//  PicGallery.swift
//  PicsBrowser
//
//  Created by Marcus Mao on 3/1/22.
//

import SwiftUI
import SwiftSoup

struct PicGallery: View {
    var url: String
    var title: String
    
    var body: some View {
        let pics:[String] = extractPicSrcs(url: url)
        
        let columns = [
               GridItem(.flexible()),
               GridItem(.flexible()),
               GridItem(.flexible())
           ]
        
        //        NavigationView{
        GeometryReader{ geo in
            let w = geo.size.width/3+1.5
            let h = w
            ScrollView{
                LazyVGrid(columns: columns, alignment: .leading, spacing: 1) {
                    ForEach(0..<pics.count) { i in
                        NavigationLink {
                            PicDetail(picName: pics[i], pics: pics, idx: i)
                        } label: {
//                            AsyncImage(url: URL(string: pics[i])) { image in
//                                image.resizable()
//                            } placeholder: {
//                                ProgressView()
//                            }
////                            .aspectRatio(1, contentMode: .fill)
//                            .scaledToFill()
//                            .frame(width: w, height: h)
//                            .clipped()
                            
                            AsyncImage(
                                url: URL(string: pics[i]),
                                transaction: Transaction(animation: .easeInOut)
                            ) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .transition(.scale(scale: 0.1, anchor: .center))
                                case .failure:
                                    Image("PicNotFound")
                                        .resizable()
                                        .border(Color.gray, width: 0.5)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .scaledToFill()
                            .frame(width: w, height: h)
                            .clipped()
                        }
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

func extractPicSrcs(url: String) -> [String]{
    var imgArray: [String] = []
    
    if let url = URL(string: url) {
        do {
            let contents = try String(contentsOf: url)
//            print(contents)
            
            do {
                let doc: Document = try SwiftSoup.parse(contents)
                let imgs: Elements = try doc.select("img")
                for img in imgs{
                    var src = try img.attr("ess-data")
                    if src==""{
                        src = try img.attr("data-src")
                        
                        if src==""{
                            continue
                        }
                        
                        src = "https:" + src
                    }
                    print(src)
                    imgArray.append(src)
                }
                return imgArray
            } catch Exception.Error(_, let message) {
                print(message)
            } catch {
                print(error)
            }
            
            return imgArray
        } catch {
            // contents could not be loaded
        }
    } else {
        // the URL was bad!
    }
    
    return imgArray
}

struct PicGallry_Previews: PreviewProvider {
    static var previews: some View {
        PicGallery(url: "https://www.t66y.com/htm_data/2202/7/4930114.html", title: "Test")
    }
}
