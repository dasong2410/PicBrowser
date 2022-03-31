//
//  PostList.swift
//  PicBrowser
//
//  Created by Marcus Mao on 3/28/22.
//

import Foundation
import SwiftSoup

@MainActor
class PostList: ObservableObject{
    @Published var currPageNo: Int = 1
    @Published var posts: [(title: String, src: String)]=[]
    var website: Website
    
    init(website: Website){
        self.website = website
    }
    
    func extractPosts() {
        posts.removeAll()
        let urlWithPgNo = website.url + "\(currPageNo)"
        if let url = URL(string: urlWithPgNo) {
            do {
                let contents = try String(contentsOf: url, encoding: website.encoding)
                //                    print(contents)
                
                do {
                    let doc: Document = try SwiftSoup.parse(contents)
                    let postInfo: Elements = try doc.select("a")
                    for h in postInfo{
                        var src = try h.attr("href")
                        if src.starts(with: website.startWith) {
                            src = website.prefix + src
                            
                            var title: String
                            if website.title=="text" {
                                title = try h.text()
                            } else if website.title=="title" {
                                title = try h.attr("title")
                            } else {
                                continue
                            }
                            
                            if title=="" {
                                continue
                            }
                            
                            if !posts.contains(where: {$0.src == src}) {
                                posts.append((title, src))
                            }
                            
                            print(title + " -> " + src)
                        }
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
