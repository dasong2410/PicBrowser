//
//  PostListViewModel.swift
//  PicBrowser
//
//  Created by Marcus Mao on 3/28/22.
//

import Foundation
import SwiftSoup

@MainActor
class PostListViewModel: ObservableObject {
    @Published var currPageNo: Int = 1
    @Published var posts: [Post]=[]
    var website: Website
    
    init(website: Website){
        self.website = website
    }
    
    func extractPosts() {
        var idx: Int = 0
        posts.removeAll()
        let urlWithPgNo: String = String(format: website.url, String(currPageNo))
        
        if let url = URL(string: urlWithPgNo) {
            do {
                let contents: String = try String(contentsOf: url, encoding: website.listEncoding)
                //                    print(contents)
                
                do {
                    let doc: Document = try SwiftSoup.parse(contents)
                    let postTags: Elements = try doc.select("a")
                    for h in postTags {
                        var src = try h.attr("href")
                        if src.starts(with: website.startWith) {
                            src = website.prefix + src
                            
                            var title: String = ""
                            if website.title=="text" {
                                title = try h.text()
                            } else if website.title=="title" {
                                title = try h.attr("title")
                            } else if website.title=="img" {
//                                title = ""
                                let imgs = try h.getElementsByTag("img")
                                if imgs.count>0 {
                                    title = try imgs.attr("title")
                                }
//                                print("Test \(title)")
                            } else {
                                continue
                            }
                            
                            if title=="" {
                                continue
                            }
                            
                            if !posts.contains(where: {$0.url == src}) {
                                posts.append(Post(id: idx, title: title, url: src))
                                idx += 1
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
