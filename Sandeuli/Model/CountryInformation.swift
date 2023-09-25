//
//  CountryInformation.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/25.
//

import Foundation

// MARK: - CountryInformationElement
struct CountryInformationElement: Codable {
    let placeID: Int?
    let licence, osmType: String?
    let osmID: Int?
    let lat, lon, countryInformationClass, type: String?
    let placeRank: Int?
    let importance: Double?
    let addresstype, name, displayName: String?
    let boundingbox: [String]?

    enum CodingKeys: String, CodingKey {
        case placeID = "place_id"
        case licence
        case osmType = "osm_type"
        case osmID = "osm_id"
        case lat, lon
        case countryInformationClass = "class"
        case type
        case placeRank = "place_rank"
        case importance, addresstype, name
        case displayName = "display_name"
        case boundingbox
    }
}

typealias CountryInformation = [CountryInformationElement]
