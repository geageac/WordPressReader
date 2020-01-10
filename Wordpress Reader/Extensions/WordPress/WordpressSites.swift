import Foundation

let uvcSite = WordpressSite(name: "UVC", apiURL: "https://undergroundvampireclub.com/wp-json/wp/v2", logoURL: "https://undergroundvampireclub.com/wp-content/uploads/2019/06/UVC-2.png", tacURL: "https://undergroundvampireclub.com/wpautoterms/terms-and-conditions", apiType: .rest)
let uuSite = WordpressSite(name: "Underground Underdogs", apiURL: "https://undergroundunderdogs.com/wp-json/wp/v2", logoURL: "", apiType: .rest)
let ffSite = WordpressSite(name: "FreshFruitOnly!", apiURL: "https://public-api.wordpress.com/wp/v2/sites/freshfruitonly.com", logoURL: "", apiType: .rest)
let techCrunch = WordpressSite(name: "TechCrunch", apiURL: "https://techcrunch.com/wp-json/wp/v2", logoURL: "https://www.quinyx.com/hs-fs/hubfs/Images/Random/techcrunch.png?t=1516968704806&width=1709&name=techcrunch.png", apiType: .rest)

let sites : [WordpressSite] = [uvcSite, uuSite, ffSite,techCrunch]

var currentSite = getRecentSite() {
    didSet {
//        setCachedCategories(categories: [])
//        setCachedArticles(posts: [])
        NotificationCenter.default.post(name: .SiteInformationUpdated, object: nil)
    }
}


extension Notification.Name {
    static var playbackStarted: Notification.Name {
        return .init(rawValue: "RadioPlayer.playbackStarted")
    }

    static var playbackPaused: Notification.Name {
        return .init(rawValue: "RadioPlayer.playbackPaused")
    }

    static var playbackStopped: Notification.Name {
        return .init(rawValue: "RadioPlayer.playbackStopped")
    }
}
