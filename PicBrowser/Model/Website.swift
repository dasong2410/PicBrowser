//
//  Website.swift
//  PicBrowser
//
//  Created by Marcus Mao on 3/22/22.
//

import Foundation

extension String.Encoding {
    static let gb_18030_2000 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue)))
}

struct PostInfo{
    var id: Int
    var title: String
    var url: String
}

struct Website: Hashable {
    var name: String
    var url: String
    var listEncoding: String.Encoding
    var startWith: String
    var prefix: String
    var title: String
    
    var postEncoding: String.Encoding
    var imgTag: String
    var imgAttr: String
    var imgPrefix: String
}

let websiteList: [Website] = [
    Website(name: "草榴-新时代的我们", url: "https://www.t66y.com/thread0806.php?fid=8&search=&page=%@", listEncoding: .utf8, startWith: "htm_data/", prefix: "https://www.t66y.com/", title: "text", postEncoding: .utf8, imgTag: "img", imgAttr: "ess-data", imgPrefix: ""),
    Website(name: "草榴-達蓋爾的旗幟", url: "https://www.t66y.com/thread0806.php?fid=16&search=&page=%@", listEncoding: .utf8, startWith: "htm_data/", prefix: "https://www.t66y.com/", title: "text", postEncoding: .utf8, imgTag: "img", imgAttr: "ess-data", imgPrefix: ""),
    
    Website(name: "汽车之家-媳妇当车模", url: "https://club.autohome.com.cn/JingXuan/104/%@", listEncoding: .gb_18030_2000, startWith: "//club.autohome.com.cn", prefix: "https:", title: "title", postEncoding: .utf8, imgTag: "img", imgAttr: "data-src", imgPrefix: "https:"),
    Website(name: "汽车之家-美人生活秀", url: "https://club.autohome.com.cn/JingXuan/292/%@", listEncoding: .gb_18030_2000, startWith: "//club.autohome.com.cn", prefix: "https:", title: "title", postEncoding: .utf8, imgTag: "img", imgAttr: "data-src", imgPrefix: "https:"),
    Website(name: "汽车之家-爱情连连看", url: "https://club.autohome.com.cn/JingXuan/282/%@", listEncoding: .gb_18030_2000, startWith: "//club.autohome.com.cn", prefix: "https:", title: "title", postEncoding: .utf8, imgTag: "img", imgAttr: "data-src", imgPrefix: "https:"),

    Website(name: "丽丝库-秀人网", url: "https://www.lisiku1.com/forum-117-%@.html", listEncoding: .gb_18030_2000, startWith: "thread", prefix: "https://www.lisiku1.com/", title: "img", postEncoding: .gb_18030_2000, imgTag: "img", imgAttr: "src", imgPrefix: "https://www.lisiku1.com/"),
    Website(name: "丽丝库-魅妍社MiStar", url: "https://www.lisiku1.com/forum-126-%@.html", listEncoding: .gb_18030_2000, startWith: "thread", prefix: "https://www.lisiku1.com/", title: "img", postEncoding: .gb_18030_2000, imgTag: "img", imgAttr: "src", imgPrefix: "https://www.lisiku1.com/"),
    Website(name: "丽丝库-推女神TGo", url: "https://www.lisiku1.com/forum-138-%@.html", listEncoding: .gb_18030_2000, startWith: "thread", prefix: "https://www.lisiku1.com/", title: "img", postEncoding: .gb_18030_2000, imgTag: "img", imgAttr: "src", imgPrefix: "https://www.lisiku1.com/"),
    Website(name: "丽丝库-青豆客QingDouKe", url: "https://www.lisiku1.com/forum-139-%@.html", listEncoding: .gb_18030_2000, startWith: "thread", prefix: "https://www.lisiku1.com/", title: "img", postEncoding: .gb_18030_2000, imgTag: "img", imgAttr: "src", imgPrefix: "https://www.lisiku1.com/"),
    Website(name: "丽丝库-爱尤物UGirlsApp", url: "https://www.lisiku1.com/forum-140-%@.html", listEncoding: .gb_18030_2000, startWith: "thread", prefix: "https://www.lisiku1.com/", title: "img", postEncoding: .gb_18030_2000, imgTag: "img", imgAttr: "src", imgPrefix: "https://www.lisiku1.com/"),
    Website(name: "丽丝库-头条女神Goddes", url: "https://www.lisiku1.com/forum-142-%@.html", listEncoding: .gb_18030_2000, startWith: "thread", prefix: "https://www.lisiku1.com/", title: "img", postEncoding: .gb_18030_2000, imgTag: "img", imgAttr: "src", imgPrefix: "https://www.lisiku1.com/"),

    Website(name: "秀人网", url: "http://www.xiuren.org/category/XiuRen-%@.html", listEncoding: .utf8, startWith: "http://www.xiuren.org/XiuRen", prefix: "", title: "title", postEncoding: .utf8, imgTag: "a", imgAttr: "href", imgPrefix: ""),
    Website(name: "尤果网", url: "http://www.xiuren.org/category/ugirls-%@.html", listEncoding: .utf8, startWith: "http://www.xiuren.org/ugirls", prefix: "", title: "title", postEncoding: .utf8, imgTag: "a", imgAttr: "href", imgPrefix: ""),
    Website(name: "推女郎", url: "http://www.xiuren.org/category/TuiGirl-%@.html", listEncoding: .utf8, startWith: "http://www.xiuren.org/tuigirl", prefix: "", title: "title", postEncoding: .utf8, imgTag: "a", imgAttr: "href", imgPrefix: ""),
    
    Website(name: "ons.ooo-性感美女", url: "https://ons.ooo/type/1/?page=%@", listEncoding: .utf8, startWith: "/article/", prefix: "https://ons.ooo", title: "text", postEncoding: .utf8, imgTag: "img", imgAttr: "data-original", imgPrefix: ""),
    Website(name: "ons.ooo-制服丝袜", url: "https://ons.ooo/type/2/?page=%@", listEncoding: .utf8, startWith: "/article/", prefix: "https://ons.ooo", title: "text", postEncoding: .utf8, imgTag: "img", imgAttr: "data-original", imgPrefix: "")
]
