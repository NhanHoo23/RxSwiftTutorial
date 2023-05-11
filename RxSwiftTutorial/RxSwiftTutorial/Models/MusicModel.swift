//
//  MusicModel.swift
//  RxSwiftTutorial
//
//  Created by NhanHoo23 on 11/05/2023.
//

import MTSDK

// MARK: - Welcome
struct FeedResult: Codable {
    let feed: Feed
}

// MARK: - Feed
struct Feed: Codable {
    let title: String
    let id: String
    let author: Author
    let links: [Link]
    let copyright, country: String
    let icon: String
    let updated: String
    let results: [Music]
}

// MARK: - Author
struct Author: Codable {
    let name: String
    let url: String
}

// MARK: - Link
struct Link: Codable {
    let linkSelf: String

    enum CodingKeys: String, CodingKey {
        case linkSelf = "self"
    }
}

// MARK: - Result
struct Music: Codable {
    let artistName, id, name, releaseDate: String
    let kind: Kind
    let artistID: String
    let artistURL: String
    let contentAdvisoryRating: ContentAdvisoryRating?
    let artworkUrl100: String
    let genres: [Genre]
    let url: String

    enum CodingKeys: String, CodingKey {
        case artistName, id, name, releaseDate, kind
        case artistID = "artistId"
        case artistURL = "artistUrl"
        case contentAdvisoryRating, artworkUrl100, genres, url
    }
}

enum ContentAdvisoryRating: String, Codable {
    case explict = "Explict"
}

// MARK: - Genre
struct Genre: Codable {
    let genreID: String
    let name: Name
    let url: String

    enum CodingKeys: String, CodingKey {
        case genreID = "genreId"
        case name, url
    }
}

enum Name: String, Codable {
    case country = "Country"
    case dance = "Dance"
    case hipHopRap = "Hip-Hop/Rap"
    case latin = "Latin"
    case music = "Music"
    case pop = "Pop"
    case rBSoul = "R&B/Soul"
}

enum Kind: String, Codable {
    case songs = "songs"
}
