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
                // 바람, 습도
                print("오늘의 습도는 \(weather.currentWeather.humidity.description)")
                print("오늘의 이슬점은 \(weather.currentWeather.dewPoint.value)")
                
                self.dailyForecast = weather.dailyForecast.forecast
                
            } catch {
                print(String(describing: error))
            }
        }
    }
}


