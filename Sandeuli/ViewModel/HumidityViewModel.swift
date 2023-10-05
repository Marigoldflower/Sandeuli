//
//  HumidityViewModel.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/10/05.
//

import WeatherKit
import CoreLocation
import Combine
import UIKit

final class HumidityViewModel {
    
    // MARK: - Cancellables
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - 날씨 데이터
    @Published var currentWeather: CurrentWeather!
    
    // MARK: - Weather Service
    private let weatherService = WeatherService()
    
    // MARK: - Fetch Weather
    func fetchWeather(location: CLLocation) {
        Task {
            do {
                let weather = try await weatherService.weather(for: location)
                self.currentWeather = weather.currentWeather
                
            } catch {
                print(String(describing: error))
            }
        }
    }
}

