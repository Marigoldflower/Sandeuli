//
//  TodayForecastViewModel.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/07.
//

import WeatherKit
import CoreLocation
import Combine
import UIKit

final class HourlyForecastViewModel {
    
    // MARK: - Cancellables
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - 날씨 데이터
    @Published var hourlyForecast:[HourWeather] = []
    
    // MARK: - Weather Service
    private let weatherService = WeatherService()
    
    // MARK: - Fetch Weather
    func fetchWeather(location: CLLocation) {
        Task {
            do {
                let weather = try await weatherService.weather(for: location)
                self.hourlyForecast = weather.hourlyForecast.forecast
                
            } catch {
                print(String(describing: error))
            }
        }
    }
}
