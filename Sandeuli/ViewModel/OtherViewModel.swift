//
//  NewsViewModel.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/19.
//

import Combine
import UIKit
import WeatherKit
import CoreLocation

final class OtherViewModel {
    
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
                
                print("현재 날씨 습도는 \(weather.currentWeather.dewPoint.value)")
                
            } catch {
                print(String(describing: error))
            }
        }
    }
}




