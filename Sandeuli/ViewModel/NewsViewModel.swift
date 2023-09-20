//
//  NewsViewModel.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/19.
//

import Combine
import UIKit

//final class NewsViewModel {
//    
//    // MARK: - Cancellables
//    private var cancellables: Set<AnyCancellable> = []
//    
//    // MARK: - 네이버 날씨 뉴스
//    @Published var weatherNews = String()
//    
//    // MARK: - 미세 & 초미세 네트워크 패칭
//    func fetchNewsNetwork() {
//        NaverWeatherNewsNetworkManager.shared.getNetworkDatas()
//            .sink { completion in
//                switch completion {
//                case .failure:
//                    print("네이버 날씨 뉴스 오류 발생 ㅠㅠ")
//                case .finished:
//                    print("네이버 날씨 뉴스 완료!")
//                }
//            } receiveValue: { [weak self] news in
//                self?.weatherNews = news
//            }.store(in: &cancellables)
//    }
//}



