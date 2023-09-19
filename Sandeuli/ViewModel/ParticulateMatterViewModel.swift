//
//  ParticulateMatterViewModel.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/18.
//

import Combine
import UIKit

final class ParticulateMatterViewModel {
    
    // MARK: - Cancellables
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - 미세 & 초미세 데이터 영역
    @Published var particulateMatter: ParticulateMatter?
    @Published var ultraParticulateMatter: ParticulateMatter?
    
    // MARK: - 미세 & 초미세 네트워크 패칭
    func fetchParticulateMatterNetwork(density: String) {
        ParticulateMatterNetworkManager.shared.getNetworkDatas(density: density)
            .sink { completion in
                switch completion {
                case .failure:
                    print("오류 발생 ㅠㅠ")
                case .finished:
                    print("미세먼지 네트워크 끝!")
                }
            } receiveValue: { [weak self] particulateMatter in
                self?.particulateMatter = particulateMatter
            }.store(in: &cancellables)
    }
    
    func fetchUltraParticulateMatterNetwork(density: String) {
        ParticulateMatterNetworkManager.shared.getNetworkDatas(density: density)
            .sink { completion in
                switch completion {
                case .failure:
                    print("오류 발생 ㅠㅠ")
                case .finished:
                    print("초미세먼지 네트워크 끝!")
                }
            } receiveValue: { [weak self] ultraParticulate in
                self?.ultraParticulateMatter = ultraParticulate
            }.store(in: &cancellables)
    }
}


