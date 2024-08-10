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
        items = try container.decode([BookListItem].self, forKey: CodingKeys.items)
    }
   
}

public struct BookListItem: Decodable {
    let identifier: String
    let title: String
    let authors: [String]
    let thumbnail: String?
    let pageCount: Int
    let buyLink: String
    let pdf: PDFData?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case volumeInfo
        case saleInfo
        case accessInfo
    }
    enum VolumeInfoCodingKeys: String, CodingKey {
        case title
        case authors
        case pageCount
        case imageLinks
    }
    
    enum ImageLinksCodingKeys: String, CodingKey {
        case thumbnail
    }
    enum SaleInfoCodingKeys: CodingKey {
        case buyLink
    }
    enum AccessInfoCodingKeys: CodingKey {
        case pdf
    }
//    public init(from decoder: any Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.identifier = try container.decode(String.self, forKey: .identifier)
//        let infoContainer = try container.nestedContainer(keyedBy: InfoCodingKeys.self, forKey: .volumeInfo)
//        self.title = try infoContainer.decode(String.self, forKey: .title)
//        self.authors = try infoContainer.decodeIfPresent([String].self, forKey: .authors) ?? []
//        if let imageContainer = try? infoContainer.nestedContainer(keyedBy: ImageLinksCodingKeys.self, forKey: .imageLinks) {
//            self.thumbnail = try imageContainer.decode(String.self, forKey: .thumbnail)
//        } else {
//            self.thumbnail = nil
//        }
//    }
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = try container.decode(String.self, forKey: .identifier)
        let volumeInfoContainer = try container.nestedContainer(keyedBy: VolumeInfoCodingKeys.self, forKey: .volumeInfo)
        self.title = try volumeInfoContainer.decode(String.self, forKey: .title)
        self.authors = try volumeInfoContainer.decodeIfPresent([String].self, forKey: .authors) ?? []
        self.pageCount = try volumeInfoContainer.decode(Int.self, forKey: .pageCount
        )
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
