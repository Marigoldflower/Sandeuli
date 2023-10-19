//
//  MockKoreaWeatherNetworkManager.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/10/18.
//

import Foundation
import Combine

// 가짜 네트워크
final class MockKoreaWeatherNetworkManager: KoreaWeatherNetworkProtocol {
    
    static let shared = MockKoreaWeatherNetworkManager()
    var cancellable = Set<AnyCancellable>()
    
    // MARK: - Mock 데이터를 담을 변수.
    var koreaMockData: KoreaWeather!
    
    // MARK: - koreaMockData를 그냥 리턴하는 메소드
    func getNetworkDatas(regionURL: String) -> AnyPublisher<KoreaWeather, Error> {
        return Just(koreaMockData)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
