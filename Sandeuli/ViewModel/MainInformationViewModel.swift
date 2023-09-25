//
//  WeatherViewModel.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/06.
//

import WeatherKit
import CoreLocation
import Combine
import UIKit

final class MainInformationViewModel {
    
    // MARK: - Cancellables
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - 미세 & 초미세 데이터 영역
    @Published var particulateMatter: ParticulateMatter?
    @Published var ultraParticulateMatter: ParticulateMatter?
    
    // MARK: - 나머지 날씨 데이터 영역
    @Published var todayCurrentWeather: CurrentWeather!
    @Published var dailyForecast: [DayWeather] = []
    
    // MARK: - Weather Service
    private let weatherService = WeatherService()
    
    // MARK: - Fetch Weather
    func fetchWeather(location: CLLocation) {
        Task {
            do {
                let weather = try await weatherService.weather(for: location)
                self.todayCurrentWeather = weather.currentWeather
                print("지금은 낮입니까? \(weather.currentWeather.isDaylight)")
                print("현재 날씨 상태는 \(weather.currentWeather.condition)")
                print("현재 날씨 symbol은 \(weather.currentWeather.symbolName)")
                self.dailyForecast = weather.dailyForecast.forecast
                
            } catch {
                print(String(describing: error))
            }
        }
    }
    
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


