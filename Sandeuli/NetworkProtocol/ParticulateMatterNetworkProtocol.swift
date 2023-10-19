//
//  ParticulateMatterNetworkProtocol.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/10/18.
//

import Foundation
import Combine

protocol ParticulateMatterNetworkProtocol {
    func getNetworkDatas(density: String) -> AnyPublisher<ParticulateMatter, Error>
}
