//
//  ArtList.swift
//  PicsBrowser
//
//  Created by Marcus Mao on 3/1/22.
//

import SwiftUI
import SwiftSoup

struct PostListView: View {
    var url: String = "https://www.t66y.com/thread0806.php?fid=8&search=&page="
    var name: String = "草榴-新时代的我们"
    var website: Website
//    @State var postList: [(title: String, src: String)]=[]
//    @State var currPageNo = 0{
//        didSet{
//            print(currPageNo)
////            postList = extractPostList(url: url + "\(currPageNo)")
//
//            viewModel.extractPostList(url: url + "\(currPageNo)")
//        }
//    }
    
//    @StateObject private var viewModel: ViewModel = ViewModel(url: "https://www.t66y.com/thread0806.php?fid=8&search=&page=")
    
    @ObservedObject private var viewModel: ViewModel
    
//    init(){
//        _currPageNo = State(initialValue: 1)
//        _postList = State(initialValue: extractPostList(url: url + "\(currPageNo)"))
//    }
    
    init(website: Website){
//        self.name = name
//        self.url = url
        self.website = website
        self.viewModel = ViewModel()
        self.viewModel.extractPostList(url: self.website.url, encoding: self.website.encoding)
    }
    
//    init(){
//        self.viewModel = ViewModel(url: url)
//    }

    var body: some View {
//        var postList = extractPostList(url: "https://www.t66y.com/thread0806.php?fid=8&search=&page=1")
        
//        NavigationView{
            VStack{
                HStack{
                    Button(" < "){
                        if viewModel.currPageNo>1{
//                            currPageNo -= 1
                            viewModel.currPageNo -= 1
                            viewModel.extractPostList(url: website.url, encoding: website.encoding)
                        }
                    }
                    .buttonStyle(.bordered)
                    Spacer()
                    Text("Page: \(viewModel.currPageNo)")
                    Spacer()
                    Button(" > "){
//                        currPageNo += 1
                        viewModel.currPageNo += 1
                        viewModel.extractPostList(url: website.url, encoding: website.encoding)
                    }
                    .buttonStyle(.bordered)
                }.padding(5)
                
                List{
//                    ForEach(postList, id: \.src){item in
                    ForEach(viewModel.postList, id: \.src){item in
                        
                        NavigationLink {
                            PicGallry(url: item.src, title: item.title)
                        } label: {
                            Text(item.title)
                        }
                    }
                }
                .navigationTitle(name)
                .navigationBarTitleDisplayMode(.inline)
                .refreshable {
                    print("Refresh list")
                }
//            }
        }
    }
}

//func extractPostList(url: String) -> [(title: String, src: String)]{
//    var imgArray: [(String, String)] = []
//
//    if let url = URL(string: url) {
//        do {
//            let contents = try String(contentsOf: url)
//            print(contents)
//
//            do {
//                let doc: Document = try SwiftSoup.parse(contents)
//                let imgs: Elements = try doc.select("a")
//                for img in imgs{
//                    let src = try img.attr("href")
//                    let title = try img.text()
//                    if src.starts(with: "htm_data/") {
//                        print(src)
//                        imgArray.append((title, "https://www.t66y.com/" + src))
//                    }
//                }
//                return imgArray
//            } catch Exception.Error(let type, let message) {
//                print(message)
//            } catch {
//                print("error")
//            }
//
//            return imgArray
//        } catch {
//            // contents could not be loaded
//        }
//    } else {
//        // the URL was bad!
//    }
//
//    return imgArray
//}
//
//struct PostInfo{
//    var title: String
//    var src: String
//}

extension PostListView{
    @MainActor class ViewModel: ObservableObject{
        @Published var currPageNo: Int = 1
        @Published var postList: [(title: String, src: String)]=[]
        
        
//        init(url: String){
//            extractPostList(url: url)
//        }

        func extractPostList(url: String, encoding: String.Encoding) {
            postList.removeAll()
            let url2 = url + "\(currPageNo)"
            if let url3 = URL(string: url2) {
                do {
                    let contents = try String(contentsOf: url3, encoding: encoding)
//                    print(contents)
                    
                    do {
                        let doc: Document = try SwiftSoup.parse(contents)
                        let postInfo: Elements = try doc.select("a")
                        for h in postInfo{
                            var src = try h.attr("href")
                            var title = try h.text()
                            
                            if src.starts(with: "htm_data/") {
                                src = "https://www.t66y.com/" + src
                            
                            } else if src.starts(with: "//club.autohome.com.cn"){
                                if title==""{
                                    title = try h.attr("title")
                                    
                                    if title == ""{
                                        continue
                                    }
                                }
                                src = "https:" + src
                               
                            } else {
                                continue
                            }
                            
                            if !postList.contains(where: {$0.src == src}){
                                postList.append((title, src))
                            }
                            
                            
                            
                            print(title + " -> " + src)
                        }
                    } catch Exception.Error(_, let message) {
                        print(message)
                    } catch {
                        print(error)
                    }
                } catch {
                    print(error)
                }
            } else {
                // the URL was bad!
                print("The URL was bad!")
            }
        }
    }
}


extension String.Encoding {
    static let gb_18030_2000 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue)))
}

struct ArtList_Previews: PreviewProvider {
    static var previews: some View {
        PostListView(website: Website(name: "草榴-新时代的我们", url: "https://www.t66y.com/thread0806.php?fid=8&search=&page=", encoding: .utf8))
    }
}
