//
//  BookListItem.swift
//  kidsbook
//
//  Created by paytalab on 8/9/24.
//

import Foundation

public struct BookList: Decodable {
    let totalItems: Int
    let items: [BookListItem]
    
    enum CodingKeys: CodingKey {
        case totalItems
        case items
    }
    public init(totalItems: Int, books: [BookListItem]) {
        self.totalItems = totalItems
        self.items = books
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalItems = try container.decode(Int.self, forKey: CodingKeys.totalItems)
        items = try container.decodeIfPresent([BookListItem].self, forKey: CodingKeys.items) ?? []
    }
   
}

public struct BookListItem: Decodable {
    let identifier: String
    let title: String
    let authors: [String]
    let description: String?

    let thumbnail: String?
    let pageCount: Int?
    let buyLink: String
    let pdf: PDFData?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case volumeInfo
        case saleInfo
        case accessInfo
        case searchInfo
    }
    enum VolumeInfoCodingKeys: CodingKey {
        case title
        case authors
        case pageCount
        case description
        case imageLinks
    }
    
    enum ImageLinksCodingKeys: CodingKey {
        case thumbnail
    }
    enum SaleInfoCodingKeys: CodingKey {
        case buyLink
    }
    enum AccessInfoCodingKeys: CodingKey {
        case pdf
    }
    enum SearchInfoCodingKeys: CodingKey {
        case textSnippet
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = try container.decode(String.self, forKey: .identifier)
        let volumeInfoContainer = try container.nestedContainer(keyedBy: VolumeInfoCodingKeys.self, forKey: .volumeInfo)
        self.title = try volumeInfoContainer.decode(String.self, forKey: .title)
        self.authors = try volumeInfoContainer.decodeIfPresent([String].self, forKey: .authors) ?? []
        self.pageCount = try volumeInfoContainer.decodeIfPresent(Int.self, forKey: .pageCount)
        self.description = try volumeInfoContainer.decodeIfPresent(String.self, forKey: .description)
        
        if let imageContainer = try? volumeInfoContainer.nestedContainer(keyedBy: ImageLinksCodingKeys.self, forKey: .imageLinks) {
            self.thumbnail = try imageContainer.decode(String.self, forKey: .thumbnail)
        } else {
            self.thumbnail = nil
        }
        let saleInfoContainer = try container.nestedContainer(keyedBy: SaleInfoCodingKeys.self, forKey: .saleInfo)
        self.buyLink = try saleInfoContainer.decode(String.self, forKey: .buyLink)

        if let accessInfoContainer = try? container.nestedContainer(keyedBy: AccessInfoCodingKeys.self, forKey: .accessInfo) {
            self.pdf = try accessInfoContainer.decodeIfPresent(PDFData.self, forKey: .pdf)
        } else {
            self.pdf = nil
        }
        
       
        

    }
}

public struct PDFData: Decodable {
    let isAvailable: Bool
    let downloadLink: String?
}
