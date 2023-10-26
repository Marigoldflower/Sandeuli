//
//  ParticulateMatterViewModel.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/18.
//

import Combine
import UIKit
import CoreLocation
import WeatherKit

final class ParticulateMatterViewModel {
    
    // MARK: - Cancellables
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - 미세 & 초미세 데이터 영역
    @Published var particulateMatter: ParticulateMatter?
    @Published var ultraParticulateMatter: ParticulateMatter?
    @Published var todayCurrentWeather: CurrentWeather!
    
    // MARK: - Weather Service
    private let weatherService = WeatherService()
    
    // MARK: - ParticulateMatterNetworkProtocol을 채택한 진짜 네트워크와 가짜 네트워크가 모두 이 자리에 들어올 수 있다. (의존성 주입)
    private let particulateMatterNetworkProtocol: ParticulateMatterNetworkProtocol!
    
    init(particulateMatterNetworkProtocol: ParticulateMatterNetworkProtocol) {
        self.particulateMatterNetworkProtocol = particulateMatterNetworkProtocol
    }
    
    // MARK: - Fetch Weather
    func fetchWeather(location: CLLocation) {
        Task {
            do {
                let weather = try await weatherService.weather(for: location)
                self.todayCurrentWeather = weather.currentWeather
                
            } catch {
                print(String(describing: error))
            }
        }
    }
    
    // MARK: - 미세 & 초미세 네트워크 패칭
    func fetchParticulateMatterNetwork(density: String) {
        // ParticulateMatterNetworkProtocol로 인해서 진짜 네트워크 통신 코드와 가짜 네트워크 통신 코드를 모두 사용할 수 있다.
        particulateMatterNetworkProtocol.getNetworkDatas(density: density)
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
        // particulateMatterNetworkProtocol로 교체해서 getNetworkDatas 메소드를 실행해야 진짜 네트워크와 가짜 네트워크를 둘 다 실행할 수 있게 된다.
        particulateMatterNetworkProtocol.getNetworkDatas(density: density)
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


