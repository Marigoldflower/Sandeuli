//
//  NaverWeatherNewsNetworkManager.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/19.
//

import Foundation
import Combine
import SwiftSoup

// TODO: - 지금 미세먼지 네트워크에서 시간이 엄청나게 걸리고 있음. 원인이 뭔지 파악하기 ⭐️
//final class NaverWeatherNewsNetworkManager {
//    static let shared = NaverWeatherNewsNetworkManager()
//    var cancellable = Set<AnyCancellable>()
//    
//    func getNetworkDatas(density: String) -> AnyPublisher<String, Error> {
//        
//        let urlString = "https://search.naver.com/search.naver?sm=tab_hty.top&where=news&query=날씨&oquery=날씨&tqi=idDV1wprvmsssZ236Jdssssstew-483395"
//        
//        let url = URL(string: urlString)!
//        
//        return Future {[weak self] promise in
//            guard let self = self else { return }
//            URLSession.shared.dataTaskPublisher(for: url)
//                .map { $0.data }
//                    .compactMap { String(data: $0, encoding: .utf8) }
//                    .flatMap { html -> AnyPublisher<String, Never> in
//                        do {
//                            let doc: Document = try SwiftSoup.parse(html)
//                            let elements: Elements = try doc.select("a.news_tit")
//                            return elements.array().publisher
//                                .compactMap { try? $0.text() }
//                                .eraseToAnyPublisher()
//                        } catch {
//                            return Empty().eraseToAnyPublisher()
//                        }
//                    }
//                .sink(receiveCompletion: { completion in
//                    switch completion {
//                    case .failure(let error):
//                        print("오류가 발생했습니다! \(error)")
//                    case .finished:
//                        print("미세먼지 네트워크가 연결되었습니다!")
//                    }
//                }, receiveValue: { value in
//                    promise(.success(value))
//                })
//                .store(in: &self.cancellable)
//        }
//        .eraseToAnyPublisher()
//        
//    }
//}
//
//
