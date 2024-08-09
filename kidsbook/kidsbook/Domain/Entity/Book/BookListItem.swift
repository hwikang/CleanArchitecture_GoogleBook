//
//  BookListItem.swift
//  kidsbook
//
//  Created by paytalab on 8/9/24.
//

import Foundation

struct BookList: Decodable {
    var totalItems: Int
    let items: [BookListItem]
    
    enum CodingKeys: CodingKey {
        case totalItems
        case items
    }
    init(totalItems: Int, books: [BookListItem]) {
        self.totalItems = totalItems
        self.items = books
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalItems = try container.decode(Int.self, forKey: CodingKeys.totalItems)
        items = try container.decode([BookListItem].self, forKey: CodingKeys.items)
    }
   
}

struct BookListItem: Decodable {
    let identifier: String
    let title: String
    let authors: [String]
    let thumbnail: URL?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case volumeInfo
    }
    enum InfoCodingKeys: String, CodingKey {
        case title
        case authors
        case imageLinks
    }
    enum ImageLinksCodingKeys: String, CodingKey {
        case thumbnail
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = try container.decode(String.self, forKey: .identifier)
        let infoContainer = try container.nestedContainer(keyedBy: InfoCodingKeys.self, forKey: .volumeInfo)
        self.title = try infoContainer.decode(String.self, forKey: .title)
        self.authors = try infoContainer.decodeIfPresent([String].self, forKey: .authors) ?? []
        if let imageContainer = try? infoContainer.nestedContainer(keyedBy: ImageLinksCodingKeys.self, forKey: .imageLinks) {
            let imageURLString = try imageContainer.decode(String.self, forKey: .thumbnail)
            self.thumbnail = URL(string: imageURLString)
        } else {
            self.thumbnail = nil
        }
    }
}
