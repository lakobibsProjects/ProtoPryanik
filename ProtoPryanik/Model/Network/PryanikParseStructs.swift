//
//  PryanikParseStructs.swift
//  ProtoPryanik
//
//  Created by user166683 on 2/3/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation

// MARK: - Pryanik
struct Pryanik: Codable {
    let data: [Datum]
    let view: [String]
}

// MARK: - Datum
struct Datum: Codable {
    let name: String
    let data: DataClass
    var type: PryanikDataType? { return PryanikDataType(rawValue: "\(self.name)")}
}

// MARK: - DataClass
struct DataClass: Codable {
    let text: String?
    let url: String?
    let selectedID: Int?
    let variants: [Variant]?

    enum CodingKeys: String, CodingKey {
        case text, url
        case selectedID = "selectedId"
        case variants
    }
}

// MARK: - Variant
struct Variant: Codable {
    let id: Int
    let text: String
}

enum PryanikDataType: String{
    case hz
    case selector
    case picture
}
