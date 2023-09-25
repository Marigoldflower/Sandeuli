//
//  KoreaWeather.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/20.
//


import Foundation

// MARK: - KoreaWeather
struct KoreaWeather: Codable {
    let response: Response?
}

// MARK: - Response
struct Response: Codable {
    let header: Header?
    let body: Body?
}

// MARK: - Body
struct Body: Codable {
    let dataType: String?
    let items: Items?
    let pageNo, numOfRows, totalCount: Int?
}

// MARK: - Items
struct Items: Codable {
    let item: [Item]?
}

// MARK: - Item
struct Item: Codable {
    let baseDate, baseTime: String
    let category: Category
    let fcstDate, fcstTime, fcstValue: String
    let nx, ny: Int
}

enum Category: String, Codable {
    case pcp = "PCP"
    case pop = "POP"
    case pty = "PTY"
    case reh = "REH"
    case sky = "SKY"
    case sno = "SNO"
    case tmn = "TMN"
    case tmp = "TMP"
    case tmx = "TMX"
    case uuu = "UUU"
    case vec = "VEC"
    case vvv = "VVV"
    case wav = "WAV"
    case wsd = "WSD"
}

// MARK: - Header
struct Header: Codable {
    let resultCode, resultMsg: String?
}
