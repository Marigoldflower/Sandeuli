//
//  CountryInformationViewModel.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/25.
//

import Foundation
import Combine
import UIKit

final class CountryInformationViewModel {
    
    // MARK: - Cancellables
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - 나라 정보
    @Published var countryInformation: CountryInformation = []
    
    // MARK: - 미세 & 초미세 네트워크 패칭
    func fetchCountryInformationNetwork(regionName: String) {
        CountryInformationNetworkManager.shared.getNetworkDatas(regionName: regionName)
            .sink { completion in
                switch completion {
                case .failure:
                    print("오류 발생 ㅠㅠ")
                case .finished:
                    print("나라 정보 네트워크 끝!")
                }
            } receiveValue: { [weak self] countryInformation in
                self?.countryInformation = countryInformation
            }
            .store(in: &cancellables)
    }
}
