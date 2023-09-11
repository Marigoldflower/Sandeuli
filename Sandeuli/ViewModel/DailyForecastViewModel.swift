//
//  DailyForecastViewModel.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/11.
//

import WeatherKit
import CoreLocation
import Combine
import UIKit

final class DailyForecastViewModel {
    
    // MARK: - Cancellables
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - 날씨 데이터
    @Published var dailyForecast: [DayWeather] = []
    
    // MARK: - Weather Service
    private let weatherService = WeatherService()
    
    // MARK: - Fetch Weather
    func fetchWeather(location: CLLocation) {
        Task {
            do {
                let weather = try await weatherService.weather(for: location)
                self.dailyForecast = weather.dailyForecast.forecast
                print("데일리 forecast 시류행된거 맞아? \(dailyForecast)")
                
            } catch {
                print(String(describing: error))
            }
        }
    }
}

