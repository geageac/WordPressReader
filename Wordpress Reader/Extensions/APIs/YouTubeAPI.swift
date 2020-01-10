//
//  YouTubeAPI.swift
//  Wordpress Reader
//
//  Created by Tezz on 1/8/20.
//  Copyright © 2020 UVC Media. All rights reserved.
//

import Foundation
import UIKit

struct ytVideo {
    var id: String?
    var title: String?
    var channelId: String?
    var videoId: String?
    var imageURL: URL?
    var link: URL?
    
    init(id: String, title: String, channelId: String, videoId: String, imageURL: URL) {
        self.id = id
        self.title = title
        self.channelId = channelId
        self.videoId = videoId
        self.imageURL = imageURL
        self.link = createYTLink(id: videoId)
    }
    
    private func createYTLink(id: String) -> URL {
        let string = "https://youtube.com/watch?v=" + id
        guard let url = URL(string: string) else { return URL(string: "")!}
        return url
    }
}

var videos : [ytVideo] = []

func generateYTImageList() -> [URL] {
    var urls : [URL] = []
    for ytVideo in videos {
        urls.append(ytVideo.imageURL!)
    }
    return urls
}

let imageList = generateYTImageList()

extension UIViewController {
    func openYTapp(videoId: String) {
        guard let appURL = URL(string: "youtube://" + videoId) else { return }
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        }
    }
    
    func openYTapp(user: String) {
        guard let appURL = URL(string: "youtube://www.youtube.com/user/" + user) else { return }
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        }
    }
}
