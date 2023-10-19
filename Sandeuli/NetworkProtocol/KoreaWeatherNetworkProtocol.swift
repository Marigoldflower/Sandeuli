//
//  KoreaWeatherNetworkProtocol.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/10/18.
//

import Foundation
import Combine

protocol KoreaWeatherNetworkProtocol {
    func getNetworkDatas(regionURL: String) -> AnyPublisher<KoreaWeather, Error>
}
