//
//  ParticulateMatter.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/07.
//

import Foundation

// MARK: - ParticulateMatter
struct ParticulateMatter: Codable {
    let particulateMatterResponse: ParticulateMatterResponse?
    
    enum CodingKeys: String, CodingKey {
        case particulateMatterResponse = "response"
    }
}

// MARK: - Response
struct ParticulateMatterResponse: Codable {
    let body: ParticulateMatterBody?
    let header: ParticulateMatterHeader
}

// MARK: - Body
struct ParticulateMatterBody: Codable {
    let items: [ParticulateMatterItem]?
}

// MARK: - Item
struct ParticulateMatterItem: Codable {
    let daegu, chungnam, incheon, daejeon: String?
    let gyeongbuk, sejong, gwangju, jeonbuk: String?
    let gangwon, ulsan, jeonnam, seoul: String?
    let busan, jeju, chungbuk, gyeongnam: String?
    let dataTime, dataGubun, gyeonggi: String?
    let itemCode: String
}


// MARK: - Header
struct ParticulateMatterHeader: Codable {
    let resultMsg, resultCode: String
}

