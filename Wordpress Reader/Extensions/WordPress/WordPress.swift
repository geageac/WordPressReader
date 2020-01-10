//
//  WordPress.swift
//  WordPress
//
//  Created by Pierre Marty on 12/05/2017.
//  Copyright © 2017 alpeslog. All rights reserved.
//  Modified/Extended by Tezz
//

import Foundation
import UIKit

var wordPressPostDataTask : URLSessionDataTask?
var wordPressCategoryDataTask : URLSessionDataTask?

enum apiType : String,Codable {
    case rest
    case graphql
}

public struct WordpressSite : CustomStringConvertible, Codable {
    public var description: String {
        return "\n\(name): \(apiURL)"
    }
    
    var name: String
    var apiURL: String
    var logoURL: String?
    var tacURL : String?
    var categories : [Category]?
    var apiType: apiType?
    
    func hasLogoURL() -> Bool {
        if (self.logoURL == "") {
            return false
        }
        return true
    }
    
    func hasTaC() -> Bool {
        if (self.logoURL == "") {
            return false
        }
        return true
    }
    
    init(name: String, apiURL: String, logoURL: String? = nil, tacURL: String? = nil, categories: [Category]? = nil, apiType: apiType? = nil) {
        self.name = name
        self.apiURL = apiURL
        self.logoURL = logoURL
        self.tacURL = tacURL
        self.categories = categories
        self.apiType = apiType
    }
}

public struct Category : CustomStringConvertible, Codable {
    public var description: String {
        return "\n\(id): \(name)"
    }
    
    public let id: Int
    public let name: String
    public var posts : [Post] = []
    
    init? (data: Dictionary<String, AnyObject>) {
        guard
        let identifier = data["id"] as? Int,
        let title = data["name"] as? String
            else {
                return nil
        }
        self.id = identifier
        self.name = title
    }
}

public struct Post : CustomStringConvertible, Codable {
    public let id: Int
    public let date: String
    public let title: String
    public let content: String
    public let image: URL
    public let link: URL
    public var description: String {
        return "\n\(id): \(title)"
    }
    
    private func fetchImage(imageURL: URL) -> UIImage {
        do {
            let data = try Data(contentsOf: imageURL)
            if let image = UIImage(data: data) {
                return image
            }
        } catch {
            print("failed to fetch image", error)
        }
        return UIImage()
    }
    
    init? (data: Dictionary<String, AnyObject>) {
        guard
            let identifier = data["id"] as? Int,
            let date = data["date"] as? String,
//            let date = wpDateFormatter.date(from: dateString),
            let titleDictionary = data["title"] as? Dictionary<String, Any>,
            let title = titleDictionary["rendered"] as? String,
            let contentDictionary = data["content"] as? Dictionary<String, Any>,
            let image = URL(string: (data["jetpack_featured_media_url"] as? String) ?? ""),
            let link = data["link"] as? String,
            let content = contentDictionary["rendered"] as? String
            else {
                return nil
        }
        
        self.id = identifier
        self.date = date
        self.title = String(htmlEncodedString: title)
        self.content = content
        self.image = image
        self.link = URL(string: link)!
    }
    
//    private let wpDateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss"
//        return formatter
//    }()
}

public class CategoryRequest: NSObject
{
    private var baseURL = ""
    
    private var parameters:Dictionary<String, Any>? = nil
    
    private var page:Int? = nil
    private var perPage:Int? = nil
    private var search:String? = nil
    
    private var requestURL = ""
    private var isFirstParameter = true       // for building the http request
    
    public convenience init(url: String, page:Int?=nil, perPage:Int?=nil, search:String?=nil) {
        self.init()
        self.baseURL = url
    }
    
    public convenience init(url: String, parameters:Dictionary<String, Any>?=nil) {
        self.init()
        self.baseURL = url
    }
    
    public func fetchCategories (completionHander:@escaping (Array<Category>?, Error?) -> Void) {
        requestURL = baseURL + "/categories"
        
        let url = URL(string: requestURL)!
        let urlSession = URLSession.shared
        
        // (Data?, URLResponse?, Error?)
        wordPressCategoryDataTask = urlSession.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completionHander(nil, error);
                return;
            }
            var jsonError: Error?
            var jsonResult:Any?
            do {
                jsonResult = try JSONSerialization.jsonObject(with:data!, options:[])
            } catch let error {
                jsonError = error
                jsonResult = nil
            }
            
            var categories:Array<Category> = []
            if let postArray = jsonResult as? [Dictionary<String, Any>] {
                for postDictionary in postArray {
                    if let category = Category(data:postDictionary as Dictionary<String, AnyObject>) {
                        categories.append(category)
                    }
                }
            }
            completionHander(categories, jsonError);
        })
        
        wordPressCategoryDataTask?.resume()
    }
}

public class PostRequest: NSObject
{
    private var baseURL = ""

    private var parameters:Dictionary<String, Any>? = nil
    
    private var page:Int? = nil
    private var perPage:Int? = nil
    private var search:String? = nil
    
    private var cid:Int? = nil
    
    private var requestURL = ""
    private var isFirstParameter = true       // for building the http request
    
    public convenience init(url: String, page:Int?=nil, perPage:Int?=nil, search:String?=nil, cid:Int?=nil) {
        self.init()
        self.baseURL = url
        self.page = page            // page parameter is one based [1..[
        self.perPage = perPage
        self.cid = cid
        self.search = search
    }
    
    public convenience init(url: String, parameters:Dictionary<String, Any>?=nil) {
        self.init()
        self.baseURL = url
        self.parameters = parameters
    }
    
    public func fetchLastPosts (completionHandler:@escaping (Array<Post>?, Error?) -> Void) {
        requestURL = baseURL + "/posts"
        isFirstParameter = true
        if let page = self.page {
            self.appendParameter("page", page)
        }
        
        if let perPage = self.perPage {
            self.appendParameter("per_page", perPage)
        }
        
        if let search = self.search {
            self.appendParameter("search", search)
        }
        if let cid = self.cid {
            self.appendParameter("cid", cid)
        }
        let url = URL(string: requestURL)!
        let urlSession = URLSession.shared
        
        // (Data?, URLResponse?, Error?)
        wordPressPostDataTask = urlSession.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completionHandler(nil, error);
                return;
            }
            var jsonError: Error?
            var jsonResult:Any?
            do {
                jsonResult = try JSONSerialization.jsonObject(with:data!, options:[])
            } catch let error {
                jsonError = error
                jsonResult = nil
            }
            
            var posts:Array<Post> = []
            if let postArray = jsonResult as? [Dictionary<String, Any>] {
                for postDictionary in postArray {
                    if let post = Post(data:postDictionary as Dictionary<String, AnyObject>) {
                        posts.append(post)
                    }
                }
            }
            completionHandler(posts, jsonError);
        })
        
        wordPressPostDataTask?.resume()
    }
    
    public func fetchPostsBySearch (completionHandler:@escaping (Array<Post>?, Error?) -> Void) {
        requestURL = baseURL + "/posts"
        isFirstParameter = true
        if let page = self.page {
            self.appendParameter("page", page)
        }
        
        if let perPage = self.perPage {
            self.appendParameter("per_page", perPage)
        }
        
        if let search = self.search {
            self.appendParameter("search", search)
        }
        
        let encoded = requestURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        
        let url = URL(string: encoded!)
        let urlSession = URLSession.shared
        
        // (Data?, URLResponse?, Error?)
        wordPressPostDataTask = urlSession.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completionHandler(nil, error);
                return;
            }
            var jsonError: Error?
            var jsonResult:Any?
            do {
                jsonResult = try JSONSerialization.jsonObject(with:data!, options:[])
            } catch let error {
                jsonError = error
                jsonResult = nil
            }
            
            var posts:Array<Post> = []
            if let postArray = jsonResult as? [Dictionary<String, Any>] {
                for postDictionary in postArray {
                    if let post = Post(data:postDictionary as Dictionary<String, AnyObject>) {
                        posts.append(post)
                    }
                }
            }
            completionHandler(posts, jsonError);
        })

        wordPressPostDataTask?.resume()
    }
    
    public func fetchPostsByCategory (completionHandler:@escaping (Array<Post>?, Error?) -> Void) {
        requestURL = baseURL + "/posts"
        isFirstParameter = true
        
        if let cid = self.cid {
            self.appendParameter("categories", cid)
        }
        
        if let page = self.page {
            self.appendParameter("page", page)
        }
        
        if let perPage = self.perPage {
            self.appendParameter("per_page", perPage)
        }
        
        let url = URL(string: requestURL)!
        let urlSession = URLSession.shared
        
        // (Data?, URLResponse?, Error?)
        wordPressPostDataTask = urlSession.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completionHandler(nil, error);
                return;
            }
            var jsonError: Error?
            var jsonResult:Any?
            do {
                jsonResult = try JSONSerialization.jsonObject(with:data!, options:[])
            } catch let error {
                jsonError = error
                jsonResult = nil
            }
            
            var posts:Array<Post> = []
            if let postArray = jsonResult as? [Dictionary<String, Any>] {
                for postDictionary in postArray {
                    if let post = Post(data:postDictionary as Dictionary<String, AnyObject>) {
                        posts.append(post)
                    }
                }
            }
            completionHandler(posts, jsonError);
        })
        
        wordPressPostDataTask?.resume()
    }
    
    private func appendParameter (_ name:String, _ value:Any) {
        if isFirstParameter {
            requestURL += "?\(name)=\(value)"
            isFirstParameter = false
        }
        else {
            requestURL += "&\(name)=\(value)"
        }
    }
    
    public struct ParamKey {
        public static let page = "page"
        public static let perPage = "per_page"
        public static let search = "search"
        public static let cid = "category"
    }
    
}

func fetchCategories(completion: @escaping () -> ()) {
    print("fetching posts!")
    let apiURL = currentSite.apiURL
    let postRequest = CategoryRequest(url: apiURL)
    postRequest.fetchCategories(completionHander: { categories, error in
        if let cat = categories {
            DispatchQueue.main.async {
                setCachedCategories(categories: cat)
                var blankCategories = getCachedCategories()
                for (index, category) in blankCategories.enumerated() {
                    let postRequest = PostRequest(url: apiURL, page: 1, perPage: 75, cid: category.id)
                    postRequest.fetchPostsByCategory(completionHandler: { posts, error in
                        if let newposts = posts {
                            blankCategories[index].posts = newposts
                            setCachedCategories(categories: blankCategories)
                            DispatchQueue.main.async {
                                if (index == blankCategories.endIndex - 1) {
                                    print("finished fetching posts!")
                                    currentSite.categories = blankCategories
                                    setRecentSite(site: currentSite)
                                    delay(n: 1, completion: { completion() })
                                }
                            }
                        }
                    })
                }
            }
        }
    })
}
