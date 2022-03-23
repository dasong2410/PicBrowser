//
//  Website.swift
//  PicBrowser
//
//  Created by Marcus Mao on 3/22/22.
//

import Foundation

struct Website{
    var name: String
    var url: String
    var encoding: String.Encoding
}

let websiteList: [Website] = [
    Website(name: "草榴-新时代的我们", url: "https://www.t66y.com/thread0806.php?fid=8&search=&page=", encoding: .utf8),
    Website(name: "草榴-達蓋爾的旗幟", url: "https://www.t66y.com/thread0806.php?fid=16&search=&page=", encoding: .utf8),
    Website(name: "汽车之家-媳妇当车模", url: "https://club.autohome.com.cn/JingXuan/104/", encoding: .gb_18030_2000),
    Website(name: "汽车之家-美人生活秀", url: "https://club.autohome.com.cn/JingXuan/292/", encoding: .gb_18030_2000),
    Website(name: "汽车之家-爱情连连看", url: "https://club.autohome.com.cn/JingXuan/282/", encoding: .gb_18030_2000)
]
