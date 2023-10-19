//
//  MockParticulateMatterNetworkManager.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/10/18.
//

import Foundation
import Combine

// 가짜 네트워크
final class MockParticulateMatterNetworkManager: ParticulateMatterNetworkProtocol {
    
    static let shared = MockParticulateMatterNetworkManager()
    var cancellable = Set<AnyCancellable>()
    
    // MARK: - Mock 데이터를 담을 변수.
    var particulateMockData: ParticulateMatter!
    
    // MARK: - particulateMockData를 그냥 리턴하는 메소드
    func getNetworkDatas(density: String) -> AnyPublisher<ParticulateMatter, Error> {
        return Just(particulateMockData)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
