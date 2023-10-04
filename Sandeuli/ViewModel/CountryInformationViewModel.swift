//
//  CountryInformationViewModel.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/25.
//

import CombineReactor
import WeatherKit
import Combine
import UIKit
import CoreLocation

final class CountryInformationViewModel {
    
    // MARK: - Cancellables
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - 나라 정보
    @Published var countryInformation: CountryInformation = []
    
    // MARK: - 나머지 날씨 데이터 영역
    @Published var currentWeather: CurrentWeather!
    @Published var dailyForecast: [DayWeather] = []
    
    // MARK: - Weather Service
    private let weatherService = WeatherService()
    
    // MARK: - Fetch Weather
    func fetchWeather(location: CLLocation) {
        Task {
            do {
                let weather = try await weatherService.weather(for: location)
                self.currentWeather = weather.currentWeather
                self.dailyForecast = weather.dailyForecast.forecast
                
            } catch {
                print(String(describing: error))
            }
        }
    }
    
    // MARK: - 지역 네트워크 패칭
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
