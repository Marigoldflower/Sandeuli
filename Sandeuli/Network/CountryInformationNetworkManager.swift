//
//  CountryInformationNetworkManager.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/25.
//

import Foundation
import Combine

final class CountryInformationNetworkManager {
    static let shared = CountryInformationNetworkManager()
    var cancellable = Set<AnyCancellable>()
    
    func getNetworkDatas(regionName: String) -> AnyPublisher<CountryInformation, Error> {
        
        // "ㄱ"과 같은 문자열을 입력해도 에러가 발생하지 않게끔 하는 방법 ⭐️⭐️
        guard let encodedRegionName = regionName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { fatalError() }
        
        let urlString = "https://nominatim.openstreetmap.org/search?format=json&q=\(encodedRegionName)"
        
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
                .decode(type: CountryInformation.self, decoder: JSONDecoder())
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("오류가 발생했습니다! \(error)")
                    case .finished:
                        print("나라 정보 네트워크가 연결되었습니다!")
                    }
                }, receiveValue: { value in
                    promise(.success(value))
                })
                .store(in: &self.cancellable)
        }
        .eraseToAnyPublisher()
        
    }
}


