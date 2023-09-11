//
//  ViewController.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/06.
//

import UIKit
import WeatherKit
import CoreLocation
import SnapKit
import Combine

final class WeatherController: UIViewController {
    
    // MARK: - Cancellables
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - ViewModel
    private let mainInformationViewModel = MainInformationViewModel()
    private let hourlyForecastViewModel = HourlyForecastViewModel()
    
    // MARK: - CLLocationManager
    private let locationManager = CLLocationManager()
    
    // MARK: - UI Components
    private let mainInformationView: MainInformationView = {
        let view = MainInformationView()
        view.backgroundColor = .dayBackground
        return view
    }()

    private let hourlyForecastView: HourlyForecastView = {
        let view = HourlyForecastView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()

    private let tenDaysForecastView: TenDaysForecastView = {
        let view = TenDaysForecastView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: - 스택 뷰
    private let stackView: UIStackView = {
        let stack = UIStackView() // arrangedSubview를 이용해서 바로 할당하지 말 것
        stack.axis = .vertical // 가로로 스크롤하고 싶으면 horizontal로 맞추기
        stack.spacing = 15
        stack.distribution = .fill
        return stack
    }()

    // MARK: - 스크롤 뷰
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    // MARK: - SearchController
    private lazy var searchController: UISearchController = {
        let searchResult = UISearchController(searchResultsController: SearchResultViewController())
        searchResult.searchResultsUpdater = self
        searchResult.searchBar.autocapitalizationType = .none
        searchResult.searchBar.searchTextField.borderStyle = .none
        searchResult.searchBar.searchTextField.layer.cornerRadius = 10
        searchResult.searchBar.searchTextField.backgroundColor = .searchControllerWhite
        searchResult.searchBar.placeholder = "지역을 입력해주세요"
        searchResult.searchBar.updateHeight(height: 46)
        return searchResult
    }()
    
    // MARK: - 내 현재 위치
    private var userLocation = String()
    private var myState = String() {
        didSet {
//            self.particulateMatterLocation = searchLocation(location: myState)
//            self.ultraParticulateMatterLocation = searchLocation(location: myState)
        }
    }
    
    // MARK: - 미세먼지 & 초미세먼지 정보를 담는 변수
    private var particulateMatterLocation = String() {
        didSet {
//            mainInformationViewModel.fetchParticulateMatterNetwork(density: "PM10")
        }
    }

    private var ultraParticulateMatterLocation = String() {
        didSet {
//            mainInformationViewModel.fetchUltraParticulateMatterNetwork(density: "PM25")
        }
    }
    
    // MARK: - 미세 & 초미세가 한 번만 불릴 수 있게끔 조절해주는 저장용 변수
    var particulateMatterFetchCount = Int()
    var ultraParticulateMatterFetchCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension WeatherController: ViewDrawable {
    func configureUI() {
        view.backgroundColor = .dayBackground
        setAutolayout()
        fillStackView()
        getUsersLocation()
        setMainInformationViewData()
    }
    
    private func setMainInformationViewData() {
        Publishers.Zip(mainInformationViewModel.$todayCurrentWeather,
                        mainInformationViewModel.$dailyForecast)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentWeather, dailyForecast in
                guard let currentWeather = currentWeather else { return }
                
                // MARK: - WeatherImage에 따라 색깔을 바꾸는 영역
                self?.coloringMethod(symbolName: currentWeather.symbolName)
                
                // MARK: - Temperature 영역
                self?.mainInformationView.todayWeatherTemperature.text = String(round(currentWeather.temperature.value * 10) / 10)
                
                // MARK: - 사용자의 위치
                self?.mainInformationView.currentLocation.text = self?.userLocation
                
                // MARK: - 하늘상태
                self?.mainInformationView.currentSky.text = currentWeather.condition.description
                
                // MARK: - 미세 & 초미세
//                guard let particulateMatter = particulateMatter?.particulateMatterResponse?.body?.items else { return }
//                guard let particulateMatterLocation = self?.particulateMatterLocation else { return }
//
//                self?.particulateMatterCalculatorAccordingToLocation(location: particulateMatterLocation, particulateData: particulateMatter)
//
//                guard let ultraParticulate = ultraParticulate?.particulateMatterResponse?.body?.items else { return }
//                guard let ultraParticulateMatterLocation = self?.ultraParticulateMatterLocation else { return }
//
//                self?.particulateMatterCalculatorAccordingToLocation(location: ultraParticulateMatterLocation, particulateData: ultraParticulate)
                
                // MARK: - 최고 & 최저 온도
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let today = formatter.string(from: Date())
                
                let newFormatter = DateFormatter()
                newFormatter.dateFormat = "yyyy-MM-dd"
                let todayDate = newFormatter.date(from: today)!
                
                for dayWeather in dailyForecast {
                    if dayWeather.date == todayDate {
                        
                        let highestCelsius = String(round(dayWeather.highTemperature.value * 10) / 10) + "°"
                        self?.mainInformationView.highestCelsius.text = "최고: " + highestCelsius
                        if self?.mainInformationView.backgroundColor == .snowyBackground || self?.mainInformationView.backgroundColor == .rainyBackground ||
                            self?.mainInformationView.backgroundColor == .nightBackground ||
                            self?.mainInformationView.backgroundColor == .foggyBackground {
                            self?.mainInformationView.highestCelsius.attributedText = self?.coloringTextMethod(text: "최고", colorText: highestCelsius, color: .nightDataText)
                        } else {
                            self?.mainInformationView.highestCelsius.attributedText = self?.coloringTextMethod(text: "최고", colorText: highestCelsius, color: .dayDataText)
                        }
                        
                        let lowestCelsius = String(round(dayWeather.lowTemperature.value * 10) / 10) + "°"
                        self?.mainInformationView.lowestCelsius.text = "최저: " + lowestCelsius
                        if self?.mainInformationView.backgroundColor == .snowyBackground || self?.mainInformationView.backgroundColor == .rainyBackground ||
                            self?.mainInformationView.backgroundColor == .nightBackground ||
                            self?.mainInformationView.backgroundColor == .foggyBackground {
                            self?.mainInformationView.lowestCelsius.attributedText = self?.coloringTextMethod(text: "최저", colorText: lowestCelsius, color: .nightDataText)
                        } else {
                            self?.mainInformationView.lowestCelsius.attributedText = self?.coloringTextMethod(text: "최저", colorText: lowestCelsius, color: .dayDataText)
                        }
                        
                        // MARK: - 일출 & 일몰 데이터
                        guard let sunriseData = dayWeather.sun.sunrise else { return }
                        guard let sunsetData = dayWeather.sun.sunset else { return }
                        
                        let sunFormatter = DateFormatter()
                        sunFormatter.dateFormat = "HH:mm"
                        
                        let sunrise = sunFormatter.string(from: sunriseData)
                        let sunset = sunFormatter.string(from: sunsetData)
                        
                        self?.mainInformationView.sunrise.text = "일출: " + sunrise
                        if self?.mainInformationView.backgroundColor == .snowyBackground || self?.mainInformationView.backgroundColor == .rainyBackground ||
                            self?.mainInformationView.backgroundColor == .nightBackground ||
                            self?.mainInformationView.backgroundColor == .foggyBackground {
                            self?.mainInformationView.sunrise.attributedText = self?.coloringTextMethod(text: "일출", colorText: sunrise, color: .nightDataText)
                        } else {
                            self?.mainInformationView.sunrise.attributedText = self?.coloringTextMethod(text: "일출", colorText: sunrise, color: .dayDataText)
                        }
                        
                        self?.mainInformationView.sunset.text = "일몰: " + sunset
                        if self?.mainInformationView.backgroundColor == .snowyBackground || self?.mainInformationView.backgroundColor == .rainyBackground ||
                            self?.mainInformationView.backgroundColor == .nightBackground ||
                            self?.mainInformationView.backgroundColor == .foggyBackground {
                            self?.mainInformationView.sunset.attributedText = self?.coloringTextMethod(text: "일몰", colorText: sunset, color: .nightDataText)
                        } else {
                            self?.mainInformationView.sunset.attributedText = self?.coloringTextMethod(text: "일몰", colorText: sunset, color: .dayDataText)
                        }
                    }
                }
            }
            .store(in: &cancellables)
        setHourlyForecastViewData()
    }
    
    private func setHourlyForecastViewData() {
        Publishers.Zip(hourlyForecastViewModel.$hourlyForecast,
                       hourlyForecastViewModel.$dailyForecast)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] hourlyForecast, dailyForecast in
            for hourlyWeather in hourlyForecast {
                
                // MARK: - 현재 시간을 기점으로 후에 있는 데이터만 배열로 보내기 위해 만들어진 기준점
                let currentFormatter = DateFormatter()
                currentFormatter.dateFormat = "HH시"
                let currentHourData = currentFormatter.string(from: Date())
                
                // MARK: - 배열로 보낼 데이터 값
                let hourly = hourlyWeather.date
                let formatter = DateFormatter()
                formatter.dateFormat = "HH시"
                let hourlyData = formatter.string(from: hourly)
                print("여기엔 무슨 데이터가 들어와? \(hourlyData)")
                
                // MARK: - 현재 날짜와 같거나 뒤에 있는 날짜만 통과시키기 위한 기준 시간
                let compareFormatter = DateFormatter()
                compareFormatter.dateFormat = "yyyy-MM-dd"
                let compareDate = compareFormatter.string(from: hourly)
                
                // MARK: - 내 현재 날짜
                let userFormatter = DateFormatter()
                userFormatter.dateFormat = "yyyy-MM-dd"
                let userToday = userFormatter.string(from: Date())
                
                // MARK: - 현재 날짜보다 뒤에 있으면서 현재 시간보다 뒤에 있는 시간대만 통과시키겠다는 로직
                if userToday <= compareDate {
                    // 오늘에 해당할 경우에만 현재 시간보다 뒤에 있는 시간대만 통과시키고
                    // 오늘이 아닐 경우에는 모든 시간대를 통과시켜야 한다.
                    
                    // ⭐️ 오늘이라면
                    if compareDate.contains(userToday) {
                        if currentHourData <= hourlyData {
                            
                            // MARK: - 시간 데이터
                            self?.hourlyForecastView.timeArray.append(hourlyData)
                            
                            // MARK: - 날씨 이미지 데이터
                            switch hourlyWeather.symbolName {
                            case "sun.max":
                                guard let sunImage = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.dayImage])) else { return }
                                self?.hourlyForecastView.weatherImageArray.append(sunImage)
                            case "moon.stars":
                                guard let moonImage = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.nightImage, .white])) else { return }
                                self?.hourlyForecastView.weatherImageArray.append(moonImage)
                            case "cloud":
                                guard let cloudImage = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.cloudyImage, .white])) else { return }
                                self?.hourlyForecastView.weatherImageArray.append(cloudImage)
                            case "cloud.drizzle":
                                guard let drizzle = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) else { return }
                                self?.hourlyForecastView.weatherImageArray.append(drizzle)
                            case "cloud.rain":
                                guard let rain = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) else { return }
                                self?.hourlyForecastView.weatherImageArray.append(rain)
                            case "cloud.bolt.rain":
                                guard let thunderBolt = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) else { return }
                                self?.hourlyForecastView.weatherImageArray.append(thunderBolt)
                            default:
                                break
                            }
                            
                            // MARK: - 온도 데이터
                            let temperatureData = String(round(hourlyWeather.temperature.value * 10) / 10)
                            self?.hourlyForecastView.temperatureArray.append(temperatureData)
                        }
                    } else {
                        // ⭐️ 오늘이 아니라면
                        // MARK: - 시간 데이터
                        self?.hourlyForecastView.timeArray.append(hourlyData)
                        
                        // MARK: - 날씨 이미지 데이터
                        switch hourlyWeather.symbolName {
                        case "sun.max":
                            guard let sunImage = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.dayImage])) else { return }
                            self?.hourlyForecastView.weatherImageArray.append(sunImage)
                        case "moon.stars":
                            guard let moonImage = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.nightImage, .white])) else { return }
                            self?.hourlyForecastView.weatherImageArray.append(moonImage)
                        case "cloud":
                            guard let cloudImage = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.cloudyImage, .white])) else { return }
                            self?.hourlyForecastView.weatherImageArray.append(cloudImage)
                        case "cloud.drizzle":
                            guard let drizzle = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) else { return }
                            self?.hourlyForecastView.weatherImageArray.append(drizzle)
                        case "cloud.rain":
                            guard let rain = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) else { return }
                            self?.hourlyForecastView.weatherImageArray.append(rain)
                        case "cloud.bolt.rain":
                            guard let thunderBolt = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) else { return }
                            self?.hourlyForecastView.weatherImageArray.append(thunderBolt)
                        default:
                            break
                        }
                        
                        // MARK: - 온도 데이터
                        let temperatureData = String(round(hourlyWeather.temperature.value * 10) / 10)
                        self?.hourlyForecastView.temperatureArray.append(temperatureData)
                    }
                }
            }
            
            for dailyWeather in dailyForecast {
                // MARK: - 현재 날짜와 같거나 뒤에 있는 날짜만 통과시키기 위한 기준 시간
                let daily = dailyWeather.date
                let compareFormatter = DateFormatter()
                compareFormatter.dateFormat = "yyyy-MM-dd"
                let compareDate = compareFormatter.string(from: daily)
                
                // MARK: - 내 현재 날짜
                let userFormatter = DateFormatter()
                userFormatter.dateFormat = "yyyy-MM-dd"
                let userToday = userFormatter.string(from: Date())
                
                // MARK: - 일출 & 일몰 String으로 변형해주기
                guard let sunriseData = dailyWeather.sun.sunrise else { return }
                guard let sunsetData = dailyWeather.sun.sunset else { return }
                
                let sunFormatter = DateFormatter()
                sunFormatter.dateFormat = "HH:mm"
                
                let sunrise = sunFormatter.string(from: sunriseData)
                let sunset = sunFormatter.string(from: sunsetData)
                
                // MARK: - CollectionView와 일출, 일몰 시간을 비교할 임시 데이터
                let sunnyFormatter = DateFormatter()
                sunnyFormatter.dateFormat = "HH시"
                
                let sunriseCompareWithCollectionView = sunnyFormatter.string(from: sunriseData)
                let sunsetCompareWithCollectionView = sunnyFormatter.string(from: sunsetData)
                
                if userToday <= compareDate {
                    if compareDate.contains(userToday) {
                        self?.hourlyForecastView.sunriseCompareWithCollectionView = sunriseCompareWithCollectionView
                        self?.hourlyForecastView.sunsetCompareWithCollectionView = sunsetCompareWithCollectionView
                        self?.hourlyForecastView.sunrise = sunrise
                        self?.hourlyForecastView.sunset = sunset
                    }
                }
                
            }
        }
        .store(in: &cancellables)
    }
    
    func setAutolayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        // MARK: - 뷰 레이아웃
        mainInformationView.snp.makeConstraints { make in
            make.height.equalTo(500)
        }
        
        hourlyForecastView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        
        // MARK: - 스크롤 뷰 및 스택 뷰 레이아웃
        scrollView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(scrollView.snp.leading)
            make.top.equalTo(scrollView.snp.top)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    private func fillStackView() {
        let companyArray = [mainInformationView, hourlyForecastView, tenDaysForecastView]
        for company in companyArray {
            var elementView = UIView()
            elementView = company
            elementView.translatesAutoresizingMaskIntoConstraints = false
            // ⭐️ 스크롤 방향이 세로 방향이면 widthAnchor에 값을 할당하는 부분은 지워도 된다.
            // elementView.widthAnchor.constraint(equalToConstant: 200).isActive = true
            // ⭐️ 스크롤 방향이 가로 방향이면 heightAnchor에 값을 할당하는 부분은 지워도 된다.
            elementView.heightAnchor.constraint(equalToConstant: 1000).isActive = true
            stackView.addArrangedSubview(elementView)
        }
    }
    
    private func getUsersLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
}

// MARK: - Coloring 영역
extension WeatherController {
    
    // MARK: - 날씨 이미지에 따라 색깔을 바꾸는 메소드
    private func coloringMethod(symbolName: String) {
        switch symbolName {
        case "sun.max":
            detailColoring(mainInformationView: mainInformationView, backgroundColor: .dayBackground, mainLabelColor: .dayMainLabel, sideLabelColor: .daySideLabel, symbolName: symbolName, paletteColors1: .dayImage, paletteColors2: .clear, paletteColors3: .clear)
            
        case "moon.stars":
            detailColoring(mainInformationView: mainInformationView, backgroundColor: .nightBackground, mainLabelColor: .nightMainLabel, sideLabelColor: .nightSideLabel, symbolName: symbolName, paletteColors1: .nightImage, paletteColors2: .white, paletteColors3: .clear)
            
        case "cloud":
            detailColoring(mainInformationView: mainInformationView, backgroundColor: .cloudyBackground, mainLabelColor: .cloudyMainLabel, sideLabelColor: .cloudySideLabel, symbolName: symbolName, paletteColors1: .cloudyImage, paletteColors2: .white, paletteColors3: .clear)
            
        case "cloud.drizzle":
            detailColoring(mainInformationView: mainInformationView, backgroundColor: .rainyBackground, mainLabelColor: .rainyMainLabel, sideLabelColor: .rainySideLabel, symbolName: symbolName, paletteColors1: .rainyImage, paletteColors2: .systemCyan, paletteColors3: .clear)
            
        case "cloud.rain":
            detailColoring(mainInformationView: mainInformationView, backgroundColor: .rainyBackground, mainLabelColor: .rainyMainLabel, sideLabelColor: .rainySideLabel, symbolName: symbolName, paletteColors1: .rainyImage, paletteColors2: .systemCyan, paletteColors3: .clear)
            
        case "cloud.bolt.rain":
            detailColoring(mainInformationView: mainInformationView, backgroundColor: .rainyBackground, mainLabelColor: .rainyMainLabel, sideLabelColor: .rainySideLabel, symbolName: symbolName, paletteColors1: .rainyImage, paletteColors2: .systemCyan, paletteColors3: .clear)
            
        default:
            break
        }
    }
    
    private func detailColoring(mainInformationView: MainInformationView, backgroundColor: UIColor, mainLabelColor: UIColor, sideLabelColor: UIColor, symbolName: String, paletteColors1: UIColor, paletteColors2: UIColor, paletteColors3: UIColor) {
        mainInformationView.backgroundColor = backgroundColor
        view.backgroundColor = backgroundColor
        mainInformationView.todayWeatherTemperature.textColor = mainLabelColor
        mainInformationView.celsiusLabel.textColor = mainLabelColor
        mainInformationView.currentLocation.textColor = mainLabelColor
        mainInformationView.currentSky.textColor = mainLabelColor
        mainInformationView.particulateMatter.textColor = sideLabelColor
        mainInformationView.ultraParticulateMatter.textColor = sideLabelColor
        mainInformationView.highestCelsius.textColor = sideLabelColor
        mainInformationView.lowestCelsius.textColor = sideLabelColor
        mainInformationView.sunrise.textColor = sideLabelColor
        mainInformationView.sunset.textColor = sideLabelColor
        mainInformationView.todayWeatherImage.image = UIImage(systemName: "\(symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [paletteColors1, paletteColors2, paletteColors3]))
    }
    
    // MARK: - 지역에 따라 미세 & 초미세를 구하는 메소드
    private func particulateMatterCalculatorAccordingToLocation(location: String, particulateData: [ParticulateMatterItem]) {
        switch location {
        case "daegu":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].daegu!)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].daegu!)
                }
            }
        case "chungnam":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].chungnam!)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].chungnam!)
                }
            }
        case "incheon":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].incheon!)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].incheon!)
                }
            }
        case "daejeon":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].daejeon!)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].daejeon!)
                }
            }
        case "gyeongbuk":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].gyeongbuk!)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].gyeongbuk!)
                }
            }
        case "sejong":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].sejong!)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].sejong!)
                }
            }
        case "gwangju":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].gwangju!)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].gwangju!)
                }
            }
        case "jeonbuk":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].jeonbuk!)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].jeonbuk!)
                }
            }
        case "gangwon":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].gangwon!)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].gangwon!)
                }
            }
        case "ulsan":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].ulsan!)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].ulsan!)
                }
            }
        case "jeonnam":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].jeonnam!)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].jeonnam!)
                }
            }
        case "seoul":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].seoul!)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].seoul!)
                }
            }
        case "busan":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].busan!)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].busan!)
                }
            }
        case "jeju":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].jeju!)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].jeju!)
                }
            }
        case "chungbuk":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].chungbuk!)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].chungbuk!)
                }
            }
        case "gyeongnam":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].gyeongnam!)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].gyeongnam!)
                }
            }
        case "gyeonggi":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].gyeonggi!)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].gyeonggi!)
                }
            }
        default: return

        }
    }

    // MARK: - 미세먼지 농도에 따라 좋음, 보통, 나쁨, 매우나쁨으로 나누는 메소드
    private func distributeParticulateMatter(density: String) {
        particulateMatterFetchCount += 1
        if particulateMatterFetchCount == 1 {
            guard let myCurrentLocation = Int(density) else { return }
            print("미세먼지의 값은 \(myCurrentLocation)")
            
            switch myCurrentLocation {
            case ...30:
                mainInformationView.particulateMatter.text = "미세: 좋음"
                if mainInformationView.backgroundColor == .snowyBackground || mainInformationView.backgroundColor == .rainyBackground ||
                mainInformationView.backgroundColor == .nightBackground ||
                mainInformationView.backgroundColor == .foggyBackground {
                mainInformationView.particulateMatter.attributedText = coloringTextMethod(text: "미세", colorText: "좋음", color: .particulateGoodColorNight)
                } else {
                    mainInformationView.particulateMatter.attributedText = coloringTextMethod(text: "미세", colorText: "좋음", color: .particulateGoodColorDay)
                }
                
            case 31...80:
                mainInformationView.particulateMatter.text = "미세: 보통"
                if mainInformationView.backgroundColor == .snowyBackground || mainInformationView.backgroundColor == .rainyBackground ||
                mainInformationView.backgroundColor == .nightBackground ||
                mainInformationView.backgroundColor == .foggyBackground {
                mainInformationView.particulateMatter.attributedText = coloringTextMethod(text: "미세", colorText: "보통", color: .particulateNormalColorNight)
                } else {
                   mainInformationView.particulateMatter.attributedText = coloringTextMethod(text: "미세", colorText: "보통", color: .particulateNormalColorDay)
                }
                
            case 81...150:
                mainInformationView.particulateMatter.text = "미세: 나쁨"
                if mainInformationView.backgroundColor == .snowyBackground || mainInformationView.backgroundColor == .rainyBackground ||
                mainInformationView.backgroundColor == .nightBackground ||
                mainInformationView.backgroundColor == .foggyBackground {
                mainInformationView.particulateMatter.attributedText = coloringTextMethod(text: "미세", colorText: "나쁨", color: .particulateBadColorNight)
                } else {
                    mainInformationView.particulateMatter.attributedText = coloringTextMethod(text: "미세", colorText: "나쁨", color: .particulateBadColorDay)
                }
                
            case 151...:
               mainInformationView.particulateMatter.text = "미세: 매우나쁨"
                if mainInformationView.backgroundColor == .snowyBackground || mainInformationView.backgroundColor == .rainyBackground ||
                   mainInformationView.backgroundColor == .nightBackground ||
                   mainInformationView.backgroundColor == .foggyBackground {
                   mainInformationView.particulateMatter.attributedText = coloringTextMethod(text: "미세", colorText: "매우나쁨", color: .particulateVeryBadColorNight)
                } else {
                    mainInformationView.particulateMatter.attributedText = coloringTextMethod(text: "미세", colorText: "매우나쁨", color: .particulateVeryBadColorDay)
                }
                
            default: return
            }
        }
    }

    private func distributeUltraParticulateMatter(density: String) {
        ultraParticulateMatterFetchCount += 1
        if ultraParticulateMatterFetchCount == 1 {
            guard let myCurrentLocation = Int(density) else { return }
            print("초미세먼지의 값은 \(myCurrentLocation)")
            switch myCurrentLocation {
            case ...15:
                mainInformationView.ultraParticulateMatter.text = "초미세: 좋음"
                if mainInformationView.backgroundColor == .snowyBackground || mainInformationView.backgroundColor == .rainyBackground ||
                    mainInformationView.backgroundColor == .nightBackground ||
                mainInformationView.backgroundColor == .foggyBackground {
                mainInformationView.ultraParticulateMatter.attributedText = coloringTextMethod(text: "초미세", colorText: "좋음", color: .particulateGoodColorNight)
                } else {
                  mainInformationView.ultraParticulateMatter.attributedText = coloringTextMethod(text: "초미세", colorText: "좋음", color: .particulateGoodColorDay)
                }
                
            case 16...35:
                mainInformationView.ultraParticulateMatter.text = "초미세: 보통"
                if mainInformationView.backgroundColor == .snowyBackground || mainInformationView.backgroundColor == .rainyBackground ||
                mainInformationView.backgroundColor == .nightBackground ||
                mainInformationView.backgroundColor == .foggyBackground {
                mainInformationView.ultraParticulateMatter.attributedText = coloringTextMethod(text: "초미세", colorText: "보통", color: .particulateNormalColorNight)
                } else {
                    mainInformationView.ultraParticulateMatter.attributedText = coloringTextMethod(text: "초미세", colorText: "보통", color: .particulateNormalColorDay)
                }
                
            case 36...75:
                mainInformationView.ultraParticulateMatter.text = "초미세: 나쁨"
                if mainInformationView.backgroundColor == .snowyBackground || mainInformationView.backgroundColor == .rainyBackground ||
                    mainInformationView.backgroundColor == .nightBackground ||
                    mainInformationView.backgroundColor == .foggyBackground {
                    mainInformationView.ultraParticulateMatter.attributedText = coloringTextMethod(text: "초미세", colorText: "나쁨", color: .particulateBadColorNight)
                } else {
                  mainInformationView.ultraParticulateMatter.attributedText = coloringTextMethod(text: "초미세", colorText: "나쁨", color: .particulateBadColorDay)
                }
                
            case 76...:
                mainInformationView.ultraParticulateMatter.text = "초미세: 매우나쁨"
                if mainInformationView.backgroundColor == .snowyBackground || mainInformationView.backgroundColor == .rainyBackground ||
                    mainInformationView.backgroundColor == .nightBackground ||
                    mainInformationView.backgroundColor == .foggyBackground {
                    mainInformationView.ultraParticulateMatter.attributedText = coloringTextMethod(text: "초미세", colorText: "매우나음", color: .particulateVeryBadColorNight)
                } else {
                   mainInformationView.ultraParticulateMatter.attributedText = coloringTextMethod(text: "초미세", colorText: "좋음", color: .particulateVeryBadColorDay)
                }
                
            default: return
            }
        }
    }

    // MARK: - 일반 레이블과 데이터 레이블의 색깔을 구분해주는 색깔 할당 메소드
    private func coloringTextMethod(text: String, colorText: String, color: UIColor) -> NSAttributedString {
        let stringOne = "\(text): \(colorText)"
        let stringTwo = "\(colorText)"
        
        let range = (stringOne as NSString).range(of: stringTwo)
        
        let attributedText = NSMutableAttributedString.init(string: stringOne)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        
        return attributedText
    }
}

extension WeatherController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let latitude = location.coordinate.latitude
        let longtitude = location.coordinate.longitude
        
        let myLocation = CLLocation(latitude: latitude, longitude: longtitude)
        myLocation.placemark { placemark, error in
            guard let placemark = placemark else {
                print("Error:", error ?? "nil")
                return
            }
            self.userLocation = placemark.city ?? String()
            self.myState = placemark.state ?? String()
        }
        
        locationManager.stopUpdatingLocation()
        
        // MARK: - WeatherKit 실행
        mainInformationViewModel.fetchWeather(location: location)
        hourlyForecastViewModel.fetchWeather(location: location)
        
    }
}

extension WeatherController: UISearchResultsUpdating {
    // 유저가 글자를 입력하는 순간마다 호출되는 메서드 ===> 일반적으로 다른 화면을 보여줄때 구현
    func updateSearchResults(for searchController: UISearchController) {
        print("서치바에 입력되는 단어", searchController.searchBar.text ?? "")
        // 글자를 치는 순간에 다른 화면을 보여주고 싶다면 (컬렉션뷰를 보여줌)
        let vc = searchController.searchResultsController as! SearchResultViewController
        // 컬렉션뷰에 찾으려는 단어 전달
        // SearchResultController에 반드시 searchTerm 변수가 존재해야 한다.
        vc.searchTerm = searchController.searchBar.text ?? ""
    }
}

