//
//  KoreaWeatherViewModel.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/20.
//

import Combine
import WeatherKit
import CoreLocation
import UIKit

final class KoreaWeatherViewModel {
    
    // MARK: - Cancellables
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - 날씨 데이터
    @Published var dailyForecast: [DayWeather] = []
    
    // MARK: - Weather Service
    private let weatherService = WeatherService()
    
    // MARK: - 전국 날씨 저장 변수
    @Published var seoul: KoreaWeather?
    @Published var incheon: KoreaWeather?
    @Published var gyeonggi: KoreaWeather?
    @Published var gangwon: KoreaWeather?
    @Published var chungbuk: KoreaWeather?
    @Published var chungnam: KoreaWeather?
    @Published var jeonbuk: KoreaWeather?
    @Published var jeonnam: KoreaWeather?
    @Published var gyeongnam: KoreaWeather?
    @Published var gyeongbuk: KoreaWeather?
    @Published var jeju: KoreaWeather?
    
    // MARK: - 현재 날씨
    @Published var seoulCurrentWeather = String()
    @Published var incheonCurrentWeather = String()
    @Published var gyeonggiCurrentWeather = String()
    @Published var gangwonCurrentWeather = String()
    @Published var chungbukCurrentWeather = String()
    @Published var chungnamCurrentWeather = String()
    @Published var jeonbukCurrentWeather = String()
    @Published var jeonnamCurrentWeather = String()
    @Published var gyeongnamCurrentWeather = String()
    @Published var gyeongbukCurrentWeather = String()
    @Published var jejuCurrentWeather = String()
    
    // MARK: - Fetch Weather
    func fetchWeather() {
        Task {
            do {
                let seoulWeather = try await weatherService.weather(for: CLLocation(latitude: 37.5665, longitude: 126.9780))
                self.seoulCurrentWeather = seoulWeather.currentWeather.symbolName
                                             
                let incheonWeather = try await weatherService.weather(for: CLLocation(latitude: 37.4563, longitude: 126.7052))
                self.incheonCurrentWeather = incheonWeather.currentWeather.symbolName
                
                let gyeonggiWeather = try await weatherService.weather(for: CLLocation(latitude: 37.4138, longitude: 127.5183))
                self.gyeonggiCurrentWeather = gyeonggiWeather.currentWeather.symbolName
                
                let gangwonWeather = try await weatherService.weather(for: CLLocation(latitude: 37.8228, longitude: 128.1555))
                self.gangwonCurrentWeather = gangwonWeather.currentWeather.symbolName
                
                let chungbukWeather = try await weatherService.weather(for: CLLocation(latitude: 36.6356, longitude: 127.4913))
                self.chungbukCurrentWeather = chungbukWeather.currentWeather.symbolName
                
                let chungnamWeather = try await weatherService.weather(for: CLLocation(latitude: 36.5184, longitude: 126.8000))
                self.chungnamCurrentWeather = chungnamWeather.currentWeather.symbolName
                
                let jeonbukWeather = try await weatherService.weather(for: CLLocation(latitude: 35.7175, longitude: 127.1530))
                self.jeonbukCurrentWeather = jeonbukWeather.currentWeather.symbolName
                
                let jeonnamWeather = try await weatherService.weather(for: CLLocation(latitude: 34.8161, longitude: 126.4629))
                self.jeonnamCurrentWeather = jeonnamWeather.currentWeather.symbolName
                
                let gyeongnamWeather = try await weatherService.weather(for: CLLocation(latitude: 35.2383, longitude: 128.6924))
                self.gyeongnamCurrentWeather = gyeongnamWeather.currentWeather.symbolName
                
                let gyeongbukWeather = try await weatherService.weather(for: CLLocation(latitude: 36.4919, longitude: 128.8889))
                self.gyeongbukCurrentWeather = gyeongbukWeather.currentWeather.symbolName
                
                let jejuWeather = try await weatherService.weather(for: CLLocation(latitude: 33.489011, longitude: 126.498302))
                self.jejuCurrentWeather = jejuWeather.currentWeather.symbolName
                
            } catch {
                print(String(describing: error))
            }
        }
    }
    
    // MARK: - 전국 날씨 네트워크 패칭
    func fetchKoreaWeatherNetwork(regionURL: String) {
        KoreaWeatherNetworkManager.shared.getNetworkDatas(regionURL: regionURL)
            .sink { completion in
                switch completion {
                case .failure:
                    print("오류 발생 ㅠㅠ")
                case .finished:
                    print("미세먼지 네트워크 끝!")
                }
            } receiveValue: { [weak self] koreaWeather in
                switch regionURL {
                case "nx=60&ny=127":
                    self?.seoul = koreaWeather
                case "nx=55&ny=124":
                    self?.incheon = koreaWeather
                case "nx=60&ny=121":
                    self?.gyeonggi = koreaWeather
                case "nx=92&ny=131":
                    self?.gangwon = koreaWeather
                case "nx=69&ny=106":
                    self?.chungbuk = koreaWeather
                case "nx=68&ny=100":
                    self?.chungnam = koreaWeather
                case "nx=63&ny=89":
                    self?.jeonbuk = koreaWeather
                case "nx=50&ny=67":
                    self?.jeonnam = koreaWeather
                case "nx=90&ny=77":
                    self?.gyeongnam = koreaWeather
                case "nx=91&ny=106":
                    self?.gyeongbuk = koreaWeather
                case "nx=52&ny=38":
                    self?.jeju = koreaWeather
                    
                default: break
                }
                
            }.store(in: &cancellables)
    }
    
}
