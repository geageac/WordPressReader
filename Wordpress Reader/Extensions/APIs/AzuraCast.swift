//
//  AzuraCast.swift
//  Spotify_App
//
//  Created by Tezz on 12/16/19.
//  Copyright © 2019 Anıl Akkaya. All rights reserved.
//

import Foundation
import SwiftyJSON

let radioURL = "https://radio.undergroundvampireclub.com/"

class AzuraCastStation : Codable {
    var name : String?
    var streamURL : URL?
    var image : String?
    var desc : String?
    var longDesc : String?
    var stationID: Int?
    
    init(name: String, streamURL: URL, image: String, desc: String, longDesc: String, stationID: Int? = nil) {
        self.name = name
        self.streamURL = streamURL
        self.image = image
        self.desc = desc
        self.longDesc = longDesc
        self.stationID = stationID
    }
}
    
struct SongInformation : Equatable, Codable {
    var songName: String?
    var songArtist: String?
    var songImageURL: URL?
    var songID : String?
    
    init(songName: String, songArtist: String, songImageURL: URL, songID: String? = nil) {
        self.songName = songName
        self.songArtist = songArtist
        self.songImageURL = songImageURL
        self.songID = songID
    }
}


    func getAzuraCastStations(completion: ()? = nil) {
            let azuraCastAPIURL = radioURL + "api/"
            let url = URL(string: azuraCastAPIURL + "stations")
            URLSession.shared.dataTask(with: url!) { (data, response, err) in
                guard let data = data else { return }
                do {
                    var v : [AzuraCastStation] = []
                    guard let json = try? JSON(data: data) else { return }
                    
                    for (index, station) in json.enumerated() {
                        let station = station.1
                        guard let stationName = station["name"].string else { return }
                        guard let id = station["id"].int else { return }
                        guard let url = station["listen_url"].string else { return }
                        guard let stationUrl = URL(string: url) else { return }
                        guard let stationDesc = station["description"].string else { return }
                        let s = AzuraCastStation(name: stationName, streamURL: stationUrl, image: "", desc: stationDesc, longDesc: "", stationID: id)
                        v.append(s)
                        if index == json.count - 1 {
                            DispatchQueue.main.async {
                                stations = v
                                print("Stations:", stations.count)
                                setCachedStations(stations: v)
                                completion
                            }
                            print("last loop")
                        }
                    }
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
            }.resume()
        }

var stations : [AzuraCastStation] = getFavoriteStations() {
    didSet {
        
    }
}

var songTitle = ""

extension Notification.Name {
    static let SongInformationUpdated = Notification.Name("SongInformationUpdated")
    static let FavoriteStationsUpdated = Notification.Name("FavoriteStationsUpdated")
    static let CachedStationsUpdated = Notification.Name("CachedStationsUpdated")
    static let SiteInformationUpdated = Notification.Name("SiteInformationUpdated")
}

var songInfoTimer : Timer?
