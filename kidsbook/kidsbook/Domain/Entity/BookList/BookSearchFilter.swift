//
//  BookSearchFilter.swift
//  kidsbook
//
//  Created by paytalab on 8/9/24.
//

import Foundation

public enum BookSearchFilter: String {
    case freeEbook = "free-ebooks"
    case paidEbook = "paid-ebooks"
    
    var title: String {
        switch self {
        case .freeEbook: "무료 eBook"
        case .paidEbook: "유료 eBook"
        }
    }
}

