//
//  PicGallry.swift
//  PicsBrowser
//
//  Created by Marcus Mao on 3/1/22.
//

import SwiftUI
import SwiftSoup

struct PicGallry: View {
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
    //                ForEach(pics, id: \.self) { pic in
    //                    NavigationLink{
    //                        PicDetail(picName: pic)
    //                    }label: {
    //                        AsyncImage(url: URL(string: pic)) { image in
    //                            image.resizable()
    //                        } placeholder: {
    //                            ProgressView()
    //                        }
    //                        .frame(width: 121, height: 121)
    //                        .aspectRatio(contentMode: .fit)
    //                    }
    //                }
                    
                    ForEach(0..<pics.count){ i in
                        NavigationLink{
                            PicDetail(picName: pics[i], pics: pics, idx: i)
                        }label: {
                            AsyncImage(url: URL(string: pics[i])) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
//                            .aspectRatio(1, contentMode: .fill)
                            .scaledToFill()
                            .frame(width: w, height: h)
                            .clipped()
                        }
                    }
                }
//                .padding(.horizontal)
                
    //            VStack(alignment: .leading, spacing: 3) {
    //                let picCnt: Int = pics.count
    //                if picCnt>0{
    //                    let colCnt: Int = 3
    //                    let rowCnt: Int = Int(ceil(Double(picCnt)/Double(colCnt)))
    //                    ForEach(0..<rowCnt){i in
    //                        HStack{
    //                            ForEach(0..<colCnt){ j in
    //                                let idx: Int = i*colCnt+j
    //                                if idx<picCnt{
    //                                    let pic: String = pics[idx]
    //                                    NavigationLink{
    //                                        PicDetail(picName: pic)
    //                                    }label: {
    //                                        AsyncImage(url: URL(string: pic)) { image in
    //                                            image.resizable()
    //                                        } placeholder: {
    //                                            ProgressView()
    //                                        }
    //                                        .frame(width: 120, height: 120)
    //                                        .aspectRatio(contentMode: .fit)
    //                                    }
    //                                }
    //                            }
    ////                            Spacer()
    //                        }
    //                    }
    //                }else{
    //                    Text("No picture to load in this page.")
    //                }
    //                Spacer()
    //            }
                //            }
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
        PicGallry(url: "https://www.t66y.com/htm_data/2202/7/4930114.html", title: "Test")
    }
}
