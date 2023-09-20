//
//  PatriculateMatterNetworkManager.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/07.
//

import Foundation
import Combine

// TODO: - 지금 미세먼지 네트워크에서 시간이 엄청나게 걸리고 있음. 원인이 뭔지 파악하기 ⭐️
final class ParticulateMatterNetworkManager {
    static let shared = ParticulateMatterNetworkManager()
    var cancellable = Set<AnyCancellable>()
    
    private let serviceKey = "MSM4hND9K%2B8DAXSj6qAZhKiu7duCchZ99loLETFFWK9w1mAksfkTEBJMByCvhWxOJp1nzcbeb5jDoNdmodxkXA%3D%3D"
    
    func getNetworkDatas(density: String) -> AnyPublisher<ParticulateMatter, Error> {
        
        let urlString = "https://apis.data.go.kr/B552584/ArpltnStatsSvc/getCtprvnMesureLIst?serviceKey=\(serviceKey)&returnType=json&numOfRows=1&pageNo=1&itemCode=\(density)&dataGubun=HOUR&searchCondition=WEEK"
        
        let url = URL(string: urlString)!
        
        return Future {[weak self] promise in
            guard let self = self else { return }
            URLSession.shared.dataTaskPublisher(for: url)
                .subscribe(on: DispatchQueue.global(qos: .default))
                .tryMap { data, response in
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return data
                }
                .receive(on: DispatchQueue.main)
                .decode(type: ParticulateMatter.self, decoder: JSONDecoder())
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("오류가 발생했습니다! \(error)")
                    case .finished:
                        print("미세먼지 네트워크가 연결되었습니다!")
                    }
                }, receiveValue: { value in
                    promise(.success(value))
                })
                .store(in: &self.cancellable)
        }
        .eraseToAnyPublisher()
        
    }
}

