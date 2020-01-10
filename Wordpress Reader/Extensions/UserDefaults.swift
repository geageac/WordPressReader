import Foundation
import DefaultsKit
import UIKit
import JGProgressHUD

let defaults = Defaults()

extension DefaultsKey {
    static var recentSite = Key<WordpressSite>("recentSite")
    static var cachedWordpressSites = Key<[WordpressSite]>("cachedWordpressSites")
    static var cachedArticles = Key<[Post]>("cachedArticles")
    static var cachedCategories = Key<[Category]>("cachedCategories")
    static var bookmarkedSongs = Key<[SongInformation]>("bookmarkedSongs")
    static var favoritePosts = Key<[Post]>("favoritePosts")
    static var featuredPosts = Key<[Post]>("featuredPosts")
    static var interviewPosts = Key<[Post]>("interviewPosts")
    static var reviewPosts = Key<[Post]>("reviewPosts")
    static let isFirstRun = Key<Bool>("firstRun")
}

extension DefaultsKey {
    static var favoriteStations = Key<[AzuraCastStation]>("favoriteStations") {
        didSet {
            NotificationCenter.default.post(name: .FavoriteStationsUpdated, object: nil)
        }
    }
    static var cachedStations = Key<[AzuraCastStation]>("cachedStations") {
        didSet {
            NotificationCenter.default.post(name: .CachedStationsUpdated, object: nil)
        }
    }
}

let multiSiteEnabled : Bool = false

func isFirstRun() -> Bool {
    guard let firstRun = defaults.get(for: .isFirstRun) else { return true }
    return firstRun
}

func isFavoriteStation(station: AzuraCastStation) -> Bool {
    var bool : Bool = false
    guard let favoriteStations = defaults.get(for: .favoriteStations) else { return false }
    
    if favoriteStations.contains(where: { $0.stationID == station.stationID }) {
        bool = true
    }
    return bool
}

func isBookmarkedSong(song: SongInformation) -> Bool {
    var bool : Bool = false
    guard let bookmarkedSongs = defaults.get(for: .bookmarkedSongs) else { return false }
    
    if bookmarkedSongs.contains(where: { $0.songID == song.songID }) {
        bool = true
    }
    return bool
}

func isFavoritePost(post: Post) -> Bool {
    var bool : Bool = false
    guard let favoritePosts = defaults.get(for: .favoritePosts) else { return false }
    
    if favoritePosts.contains(where: { $0.id == post.id }) {
        bool = true
    }
    return bool
}

func isSavedPost(post: Post, section: [Post]?) -> Bool {
    var bool : Bool = false
    guard let savedPosts = section else { return false }
    
    if savedPosts.contains(where: { $0.id == post.id }) {
        bool = true
    }
    return bool
}

func isNewPost(post: Post, section: [Post]?) -> Bool {
    var bool : Bool = true
    guard let savedPosts = section else { return false }
    
    if savedPosts.contains(where: { $0.id == post.id }) {
        bool = false
    }
    return bool
}

func setFavoriteStation(station: AzuraCastStation, completion: ()? = nil) {
    if isFavoriteStation(station: station) {
        print("Already a favorite!")
    } else {
        var favoriteStations = getFavoriteStations()
        favoriteStations.append(station)
        defaults.set(favoriteStations, for: .favoriteStations)
        print("Added to favorites!")
        completion
    }
}

func setBookmarkedSong(song: SongInformation, completion: ()? = nil) {
    if isBookmarkedSong(song: song) {
        print("Already bookmarked!")
    } else {
        var bookmarkedSongs = getBookmarkedSongs()
        bookmarkedSongs.append(song)
        defaults.set(bookmarkedSongs, for: .bookmarkedSongs)
        print("Added to bookmarks!")
        completion
    }
}

func setFavoritePost(post: Post, completion: ()? = nil) {
    if isFavoritePost(post: post) {
        print("Already a favorite post!")
    } else {
        var favoritePosts = getFavoritePosts()
        favoritePosts.append(post)
        defaults.set(favoritePosts, for: .favoritePosts)
        print("Added to favorites!")
        completion
    }
}


func setCachedStations(stations: [AzuraCastStation]) {
    defaults.set(stations, for: .cachedStations)
}

func setCachedArticles(posts: [Post]) {
    defaults.set(posts, for: .cachedArticles)
}

func setCachedCategories(categories: [Category]) {
    defaults.set(categories, for: .cachedCategories)
}

func setCachedWordpressSites(Wsites: [WordpressSite]) {
    defaults.set(Wsites, for: .cachedWordpressSites)
}

func setRecentSite(site: WordpressSite) {
    defaults.set(site, for: .recentSite)
}

func getFavoriteStations() -> [AzuraCastStation] {
    guard let favoriteStations = defaults.get(for: .favoriteStations) else { return [] }
    return favoriteStations
}

func getBookmarkedSongs() -> [SongInformation] {
    guard let bookmarkedSongs = defaults.get(for: .bookmarkedSongs) else { return [] }
    return bookmarkedSongs
}

func getCachedStations() -> [AzuraCastStation] {
    guard let cachedStations = defaults.get(for: .cachedStations) else { return [] }
    return cachedStations
}

func getCachedArticles() -> [Post] {
    guard let cachedArticles = defaults.get(for: .cachedArticles) else { return [] }
    return cachedArticles
}

func getCachedCategories() -> [Category] {
    guard let cachedCategories = defaults.get(for: .cachedCategories) else { return [] }
    return cachedCategories
}

func getRecentSite() -> WordpressSite {
    guard let recentSite = defaults.get(for: .recentSite) else { return sites[0] }
    return recentSite
}

func getCachedWordpressSites() -> [WordpressSite] {
    guard let wordPressSites = defaults.get(for: .cachedWordpressSites) else { return [] }
    return wordPressSites
}

func getFeaturedPosts() -> [Post] {
    guard let fPosts = defaults.get(for: .featuredPosts) else { return [] }
    return fPosts
}

func getInterviewPosts() -> [Post] {
    guard let iPosts = defaults.get(for: .interviewPosts) else { return [] }
    return iPosts
}

func getReviewPosts() -> [Post] {
    guard let rPosts = defaults.get(for: .reviewPosts) else { return [] }
    return rPosts
}

func getFavoritePosts() -> [Post] {
    guard let favoritePosts = defaults.get(for: .favoritePosts) else { return [] }
    return favoritePosts
}

func showSucess(sender: UIViewController) {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Loading"
    hud.show(in: sender.view)
    hud.dismiss(afterDelay: 3.0)
}

func deleteBookmarkedSong(song: SongInformation) {
    if isBookmarkedSong(song: song) {
        print("deleting from bookmarks")
        var bookmarkedSongs = getBookmarkedSongs()
        if let index = bookmarkedSongs.firstIndex(where: { $0.songID == song.songID }) {
            bookmarkedSongs.remove(at: index)
            defaults.set(bookmarkedSongs, for: .bookmarkedSongs)
        }
    }
}

func deleteFavoritesStation(station: AzuraCastStation) {
    if isFavoriteStation(station: station) {
        print("deleting from favorites")
        var favoriteStations = getFavoriteStations()
        if let index = favoriteStations.firstIndex(where: { $0.streamURL == station.streamURL }) {
            favoriteStations.remove(at: index)
            defaults.set(favoriteStations, for: .favoriteStations)
        }
    }  else {
        print("Not a favorite")
    }
}
