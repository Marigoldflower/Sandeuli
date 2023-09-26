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
import CombineReactor
import CombineCocoa

final class WeatherController: UIViewController, View {
    // MARK: - 지역 이름
    var seoul = "nx=60&ny=127"
    var incheon = "nx=55&ny=124"
    var gyeonggi = "nx=60&ny=121"
    var gangwon = "nx=92&ny=131"
    var chungbuk = "nx=69&ny=106"
    var chungnam = "nx=68&ny=100"
    var jeonbuk = "nx=63&ny=89"
    var jeonnam = "nx=50&ny=67"
    var gyeongnam = "nx=90&ny=77"
    var gyeongbuk = "nx=91&ny=106"
    var jeju = "nx=52&ny=38"
    
    lazy var korea = [seoul, incheon, gyeonggi, gangwon, chungbuk, chungnam, jeonbuk, jeonnam, gyeongnam, gyeongbuk, jeju]
    
    // MARK: - 각 지역이 한 번만 불리도록 하는 기준 변수
    var seoulCallCount = Int()
    var incheonCallCount = Int()
    var gyeonggiCallCount = Int()
    var gangwonCallCount = Int()
    var chungbukCallCount = Int()
    var chungnamCallCount = Int()
    var jeonbukCallCount = Int()
    var jeonnamCallCount = Int()
    var gyeongnamCallCount = Int()
    var gyeongbukCallCount = Int()
    var jejuCallCount = Int()
    
    // MARK: - Cancellables
    var cancellables: Set<AnyCancellable> = []

    // MARK: - ViewModel
    private let mainInformationViewModel = MainInformationViewModel()
    private let hourlyForecastViewModel = HourlyForecastViewModel()
    private let dailyForecastViewModel = DailyForecastViewModel()
    private let particulateMatterViewModel = ParticulateMatterViewModel()
    private let koreaWeatherViewModel = KoreaWeatherViewModel()
    private let otherViewModel = OtherViewModel()
    
    // MARK: - CLLocationManager
    private let locationManager = CLLocationManager()
    
    // MARK: - SearchResultController에게 전달할 데이터
    private var userLocation = String() {
        didSet {
            print("userLocation에 값이 들어왔어요! \(userLocation)")
        }
    }
    private var currentTemperature = String() {
        didSet {
            print("currentTemperature에 값이 들어왔어요! \(currentTemperature)")
        }
    }
    private var highestTemperature = String() {
        didSet {
            print("highestTemperature에 값이 들어왔어요! \(highestTemperature)")
        }
    }
    private var lowestTemperature = String() {
        didSet {
            print("lowestTemperature에 값이 들어왔어요! \(lowestTemperature)")
        }
    }
    private var currentSky = String() {
        didSet {
            print("currentSky에 값이 들어왔어요! \(currentSky)")
        }
    }
    
    // MARK: - UI Components
    private let searchMagnifyingButton: UIButton = {
        let button = UIButton(type: .system)
        if let originalImage = UIImage(systemName: "magnifyingglass") {
            let resizedImage = originalImage.resizeImage(targetSize: CGSize(width: 30, height: 30))
            button.setImage(resizedImage, for: .normal)
        }
        return button
    }()
    
    // MARK: - Page Control
    let pageControl: UIPageControl = {
        let page = UIPageControl()
        page.numberOfPages = 3
        page.backgroundColor = .searchControllerWhite
        page.pageIndicatorTintColor = .pageIndicatorGray
        page.currentPageIndicatorTintColor = .currentPageIndicatorDarkBlue
        page.layer.cornerRadius = 5
        return page
    }()
    
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

    private let dailyForecastView: DailyForecastView = {
        let view = DailyForecastView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.backgroundColor = .gradientBlue.withAlphaComponent(0.75)
        return view
    }()
    
    private let particulateMatterView: ParticulateMatterView = {
        let view = ParticulateMatterView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    private let koreaWeatherView: KoreaWeatherView = {
        let view = KoreaWeatherView()
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
    
    // MARK: - 내 현재 위치
    private var myState = String() {
        didSet {
            self.particulateMatterLocation = searchLocation(location: myState)
            self.ultraParticulateMatterLocation = searchLocation(location: myState)
        }
    }
    
    // MARK: - 미세먼지 & 초미세먼지 정보를 담는 변수
    private var particulateMatterLocation = String() {
        didSet {
            particulateMatterViewModel.fetchParticulateMatterNetwork(density: "PM10")
        }
    }

    private var ultraParticulateMatterLocation = String() {
        didSet {
            particulateMatterViewModel.fetchUltraParticulateMatterNetwork(density: "PM25")
        }
    }
    
    // MARK: - 미세 & 초미세가 한 번만 불릴 수 있게끔 조절해주는 저장용 변수
    var particulateMatterFetchCount = Int()
    var ultraParticulateMatterFetchCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = WeatherControllerViewModel()
        configureUI()
    }
}

extension WeatherController: Bindable {
    func bind(reactor: WeatherControllerViewModel) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindAction(_ reactor: Reactor) {
        searchMagnifyingButton.tapPublisher
            .eraseToAnyPublisher()
            .map { WeatherControllerViewModel.PresentType.searchResultViewController }
            .map { WeatherControllerViewModel.Action.magnifyingButtonTapped($0) }
            .subscribe(reactor.action)
            .store(in: &cancellables)
    }
    
    func bindState(_ reactor: Reactor) {
        reactor.state
            .map { $0.youAreInSearchResultController }
            .filter { $0 != nil }
            .map { reactor.getSearchResultViewController($0!) }
            .sink(receiveValue: { [weak self] viewController in
                // viewController에 보내야 하는 것들
                // 1. 유저의 위치 👏
                viewController.userLocation = self?.userLocation ?? String()
                // 2. 현재 온도
                viewController.currentTemperature = self?.currentTemperature ?? String()
                // 3. 최고, 최저 온도
                viewController.highestTemperature = self?.highestTemperature ?? String()
                viewController.lowestTemperature = self?.lowestTemperature ?? String()
                // 4. 현재 날씨 상태
                viewController.currentSky = self?.currentSky ?? String()
                
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .fullScreen
                navigationController.modalTransitionStyle = .crossDissolve
                self?.present(navigationController, animated: true)
            })
            .store(in: &cancellables)
    }
}

extension WeatherController: ViewDrawable {
    func configureUI() {
        view.backgroundColor = .dayBackground
        fetchKoreaNetwork(with: korea)
        setAutolayout()
        fillStackView()
        getUsersLocation()
        setMainInformationViewData()
    }
    
    private func fetchKoreaNetwork(with koreaRegion: [String]) {
        for regionURL in koreaRegion {
            koreaWeatherViewModel.fetchKoreaWeatherNetwork(regionURL: regionURL)
        }
    }

    private func setMainInformationViewData() {
        Publishers.Zip(mainInformationViewModel.$todayCurrentWeather,
                        mainInformationViewModel.$dailyForecast)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentWeather, dailyForecast in
                guard let currentWeather = currentWeather else { return }
                
                // MARK: - 낮과 밤을 나누어서 처리하는 영역
                if currentWeather.isDaylight {
                    // 낮이라면
                    if currentWeather.symbolName == "snowflake" {
                        self?.searchMagnifyingButton.tintColor = .nightSideLabel
                    } else if currentWeather.symbolName == "cloud.rain" {
                        self?.searchMagnifyingButton.tintColor = .nightSideLabel
                    } else if currentWeather.symbolName == "cloud.heavyrain" {
                        self?.searchMagnifyingButton.tintColor = .nightSideLabel
                    } else if currentWeather.symbolName == "cloud.drizzle" {
                        self?.searchMagnifyingButton.tintColor = .nightSideLabel
                    } else if currentWeather.symbolName == "cloud.bolt.rain" {
                        self?.searchMagnifyingButton.tintColor = .nightSideLabel
                    } else {
                        self?.searchMagnifyingButton.tintColor = .daySideLabel
                    }
                    
                    // MARK: - WeatherImage에 따라 색깔을 바꾸는 영역
                    self?.coloringMethod(symbolName: currentWeather.symbolName)
                } else {
                    // 밤이라면
                    self?.searchMagnifyingButton.tintColor = .nightSideLabel
                    print("지금 현재 currentWeather.symbolName은 \(currentWeather.symbolName)")
                    
                    if currentWeather.symbolName == "snowflake" {
                        self?.coloringMethod(symbolName: "snowflake")
                    } else if currentWeather.symbolName == "cloud.rain" {
                        self?.coloringMethod(symbolName: "cloud.moon.rain")
                    } else if currentWeather.symbolName == "cloud.heavyrain" {
                        self?.coloringMethod(symbolName: "cloud.heavyrain")
                    } else if currentWeather.symbolName == "cloud.drizzle" {
                        self?.coloringMethod(symbolName: "cloud.drizzle")
                    } else if currentWeather.symbolName == "cloud.bolt.rain" {
                        self?.coloringMethod(symbolName: "cloud.bolt.rain")
                    } else if currentWeather.symbolName == "cloud.moon.rain" {
                        self?.coloringMethod(symbolName: "cloud.moon.rain")
                    } else {
                        self?.coloringMethod(symbolName: "moon.stars")
                    }
                    
//                    if currentWeather.condition.description == "눈옴" {
//                        self?.coloringMethod(symbolName: "snowflake")
//                    } else if currentWeather.condition.description == "비" {
//                        self?.coloringMethod(symbolName: "cloud.moon.rain")
//                    } else {
//                        self?.coloringMethod(symbolName: "moon.stars")
//                    }
                }
                
                // MARK: - Temperature 영역
                self?.mainInformationView.todayWeatherTemperature.text = String(round(currentWeather.temperature.value * 10) / 10)
                self?.currentTemperature = String(round(currentWeather.temperature.value * 10) / 10)
                
                // MARK: - 사용자의 위치
                guard let userLocation = self?.userLocation else { return }
                self?.mainInformationView.currentLocation.text = userLocation + ", "
                
                // MARK: - 하늘상태
                self?.mainInformationView.currentSky.text = currentWeather.condition.description
                self?.currentSky = currentWeather.condition.description
                
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
                        self?.highestTemperature = "최고: " + highestCelsius
                        
                        if self?.mainInformationView.backgroundColor == .snowyBackground || self?.mainInformationView.backgroundColor == .rainyBackground ||
                            self?.mainInformationView.backgroundColor == .nightBackground ||
                            self?.mainInformationView.backgroundColor == .foggyBackground {
                            self?.mainInformationView.highestCelsius.attributedText = self?.coloringTextMethod(text: "최고", colorText: highestCelsius, color: .nightDataText)
                        } else {
                            self?.mainInformationView.highestCelsius.attributedText = self?.coloringTextMethod(text: "최고", colorText: highestCelsius, color: .dayDataText)
                        }
                        
                        let lowestCelsius = String(round(dayWeather.lowTemperature.value * 10) / 10) + "°"
                        self?.mainInformationView.lowestCelsius.text = "최저: " + lowestCelsius
                        self?.lowestTemperature = "최저: " + lowestCelsius
                        
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
                            case "sun.min":
                                guard let sunMin = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.dayImage])) else { return }
                                self?.hourlyForecastView.weatherImageArray.append(sunMin)
                            case "sparkles":
                                guard let spark = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.nightImage])) else { return }
                                self?.hourlyForecastView.weatherImageArray.append(spark)
                            case "sun.max":
                                guard let sunImage = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.dayImage])) else { return }
                                self?.hourlyForecastView.weatherImageArray.append(sunImage)
                            case "moon.stars":
                                guard let moonImage = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.nightImage, .white])) else { return }
                                self?.hourlyForecastView.weatherImageArray.append(moonImage)
                            case "cloud":
                                guard let cloudImage = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.cloudyImage, .white])) else { return }
                                self?.hourlyForecastView.weatherImageArray.append(cloudImage)
                            case "cloud.sun":
                                guard let cloudSunImage = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.cloudyImage, .dayImage])) else { return }
                                self?.hourlyForecastView.weatherImageArray.append(cloudSunImage)
                            case "cloud.drizzle":
                                guard let drizzle = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) else { return }
                                self?.hourlyForecastView.weatherImageArray.append(drizzle)
                            case "cloud.rain":
                                guard let rain = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) else { return }
                                self?.hourlyForecastView.weatherImageArray.append(rain)
                            case "cloud.bolt.rain":
                                guard let thunderBolt = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) else { return }
                                self?.hourlyForecastView.weatherImageArray.append(thunderBolt)
                            case "cloud.heavyrain":
                                guard let heavyRain = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) else { return }
                                self?.hourlyForecastView.weatherImageArray.append(heavyRain)
                            case "cloud.fog":
                                guard let fog = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) else { return }
                                self?.hourlyForecastView.weatherImageArray.append(fog)
                            case "cloud.moon":
                                guard let cloudMoon = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .nightImage])) else { return }
                                self?.hourlyForecastView.weatherImageArray.append(cloudMoon)
                            case "cloud.moon.rain":
                                guard let cloudMoonRain = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .nightImage, .systemCyan])) else { return }
                                self?.hourlyForecastView.weatherImageArray.append(cloudMoonRain)
                            case "snowflake":
                                guard let snowflake = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.white])) else { return }
                                self?.hourlyForecastView.weatherImageArray.append(snowflake)
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
                        case "sun.min":
                            guard let sunMin = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.dayImage])) else { return }
                            self?.hourlyForecastView.weatherImageArray.append(sunMin)
                        case "sparkles":
                            guard let spark = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.nightImage])) else { return }
                            self?.hourlyForecastView.weatherImageArray.append(spark)
                        case "sun.max":
                            guard let sunImage = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.dayImage])) else { return }
                            self?.hourlyForecastView.weatherImageArray.append(sunImage)
                        case "moon.stars":
                            guard let moonImage = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.nightImage, .white])) else { return }
                            self?.hourlyForecastView.weatherImageArray.append(moonImage)
                        case "cloud":
                            guard let cloudImage = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.cloudyImage, .white])) else { return }
                            self?.hourlyForecastView.weatherImageArray.append(cloudImage)
                        case "cloud.sun":
                            guard let cloudSunImage = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.cloudyImage, .dayImage])) else { return }
                            self?.hourlyForecastView.weatherImageArray.append(cloudSunImage)
                        case "cloud.drizzle":
                            guard let drizzle = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) else { return }
                            self?.hourlyForecastView.weatherImageArray.append(drizzle)
                        case "cloud.rain":
                            guard let rain = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) else { return }
                            self?.hourlyForecastView.weatherImageArray.append(rain)
                        case "cloud.bolt.rain":
                            guard let thunderBolt = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) else { return }
                            self?.hourlyForecastView.weatherImageArray.append(thunderBolt)
                        case "cloud.heavyrain":
                            guard let heavyRain = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) else { return }
                            self?.hourlyForecastView.weatherImageArray.append(heavyRain)
                        case "cloud.fog":
                            guard let fog = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) else { return }
                            self?.hourlyForecastView.weatherImageArray.append(fog)
                        case "cloud.moon":
                            guard let cloudMoon = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .nightImage])) else { return }
                            self?.hourlyForecastView.weatherImageArray.append(cloudMoon)
                        case "cloud.moon.rain":
                            guard let cloudMoonRain = UIImage(systemName: "\(hourlyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .nightImage, .systemCyan])) else { return }
                            self?.hourlyForecastView.weatherImageArray.append(cloudMoonRain)
                        case "snowflake":
                            guard let snowflake = UIImage(systemName: "\(hourlyWeather.symbolName)")?.applyingSymbolConfiguration(.init(paletteColors: [.white])) else { return }
                            self?.hourlyForecastView.weatherImageArray.append(snowflake)
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
                    } else {
                        self?.hourlyForecastView.sunriseCompareWithCollectionView = sunriseCompareWithCollectionView
                        self?.hourlyForecastView.sunsetCompareWithCollectionView = sunsetCompareWithCollectionView
                        self?.hourlyForecastView.sunrise = sunrise
                        self?.hourlyForecastView.sunset = sunset
                    }
                }
                
            }
        }
        .store(in: &cancellables)
        setDailyForecastData()
    }
    
    private func setDailyForecastData() {
        dailyForecastViewModel.$dailyForecast
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dailyForecast in
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
                    
                    // MARK: - 요일 데이터
                    let weekDayFormatter = DateFormatter()
                    weekDayFormatter.dateFormat = "EEEE"
                    let weekDay = weekDayFormatter.string(from: daily)
                    print("비가 오는 요일은 \(weekDay)")
                    
                    print("비가 오는 날짜는 \(dailyWeather.date)")
                    print("비가 올 확률은 \(dailyWeather.precipitationChance.description)")
                    
                    if userToday <= compareDate {
                        // MARK: - 요일 데이터
                        self?.dailyForecastView.weekDayArray.append(weekDay)
                        
                        // MARK: - 날씨 이미지 데이터
                        switch dailyWeather.symbolName {
                        case "sun.min":
                            guard let sunMin = UIImage(systemName: "\(dailyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.dayImage])) else { return }
                            self?.dailyForecastView.weatherImageArray.append(sunMin)
                        case "sun.max":
                            guard let sunImage = UIImage(systemName: "\(dailyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.dayImage])) else { return }
                            self?.dailyForecastView.weatherImageArray.append(sunImage)
                        case "moon":
                            guard let moon = UIImage(systemName: "\(dailyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.nightImage, .white])) else { return }
                            self?.dailyForecastView.weatherImageArray.append(moon)
                        case "sparkles":
                            guard let spark = UIImage(systemName: "\(dailyWeather.symbolName)")?.applyingSymbolConfiguration(.init(paletteColors: [.nightImage])) else { return }
                            self?.dailyForecastView.weatherImageArray.append(spark)
                        case "moon.stars":
                            guard let moonImage = UIImage(systemName: "\(dailyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.nightImage, .white])) else { return }
                            self?.dailyForecastView.weatherImageArray.append(moonImage)
                        case "cloud":
                            guard let cloudImage = UIImage(systemName: "\(dailyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.cloudyImage])) else { return }
                            self?.dailyForecastView.weatherImageArray.append(cloudImage)
                        case "cloud.sun":
                            guard let cloudSunImage = UIImage(systemName: "\(dailyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.cloudyImage, .dayImage])) else { return }
                            self?.dailyForecastView.weatherImageArray.append(cloudSunImage)
                        case "cloud.drizzle":
                            guard let drizzle = UIImage(systemName: "\(dailyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) else { return }
                            self?.dailyForecastView.weatherImageArray.append(drizzle)
                        case "cloud.rain":
                            guard let rain = UIImage(systemName: "\(dailyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) else { return }
                            self?.dailyForecastView.weatherImageArray.append(rain)
                        case "cloud.bolt.rain":
                            guard let thunderBolt = UIImage(systemName: "\(dailyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) else { return }
                            self?.dailyForecastView.weatherImageArray.append(thunderBolt)
                        case "cloud.heavyrain":
                            guard let heavyRain = UIImage(systemName: "\(dailyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .systemCyan])) else { return }
                            self?.dailyForecastView.weatherImageArray.append(heavyRain)
                        case "cloud.fog":
                            guard let fog = UIImage(systemName: "\(dailyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .white])) else { return }
                            self?.dailyForecastView.weatherImageArray.append(fog)
                        case "cloud.moon":
                            guard let cloudMoon = UIImage(systemName: "\(dailyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.white, .nightImage])) else { return }
                            self?.dailyForecastView.weatherImageArray.append(cloudMoon)
                        case "cloud.moon.rain":
                            guard let cloudMoonRain = UIImage(systemName: "\(dailyWeather.symbolName).fill")?.applyingSymbolConfiguration(.init(paletteColors: [.rainyImage, .nightImage, .systemCyan])) else { return }
                            self?.dailyForecastView.weatherImageArray.append(cloudMoonRain)
                        case "snowflake":
                            guard let snowflake = UIImage(systemName: "\(dailyWeather.symbolName)")?.applyingSymbolConfiguration(.init(paletteColors: [.white])) else { return }
                            self?.dailyForecastView.weatherImageArray.append(snowflake)
                        default:
                            break
                        }
                        
                        // MARK: - 최고 온도
                        let highestTemperature = String(round(dailyWeather.highTemperature.value * 10) / 10)
                        print("최고 온도는 \(highestTemperature)")
                        self?.dailyForecastView.highestCelsiusArray.append(highestTemperature)
                        
                        // MARK: - 최저 온도
                        let lowestTemperature = String(round(dailyWeather.lowTemperature.value * 10) / 10)
                        print("최저 온도는 \(lowestTemperature)")
                        self?.dailyForecastView.lowestCelsiusArray.append(lowestTemperature)
                        
                    }
                }
            }
            .store(in: &cancellables)
        setParticulateMatterViewData()
    }
    
    private func setParticulateMatterViewData() {
        Publishers.Zip3(particulateMatterViewModel.$particulateMatter,
                        particulateMatterViewModel.$ultraParticulateMatter,
                        particulateMatterViewModel.$todayCurrentWeather)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] particulate, ultraParticulate, currentWeather in
            
            guard let currentWeather = currentWeather else { return }
            
            // MARK: - 미세 & 초미세
            guard let particulateMatter = particulate?.particulateMatterResponse?.body?.items else { return }
            guard let particulateMatterLocation = self?.particulateMatterLocation else { return }
            
            self?.particulateMatterCalculatorAccordingToLocation(location: particulateMatterLocation, particulateData: particulateMatter, isDayLight: currentWeather.isDaylight, symbolName: currentWeather.symbolName)
            
            guard let ultraParticulate = ultraParticulate?.particulateMatterResponse?.body?.items else { return }
            guard let ultraParticulateMatterLocation = self?.ultraParticulateMatterLocation else { return }
            
            self?.particulateMatterCalculatorAccordingToLocation(location: ultraParticulateMatterLocation, particulateData: ultraParticulate, isDayLight: currentWeather.isDaylight, symbolName: currentWeather.symbolName)
        }
        .store(in: &cancellables)
        setKoreaWeatherViewData()
    }
    
    private func setKoreaWeatherViewData() {
        Publishers.Zip4(koreaWeatherViewModel.$jeju,
                        koreaWeatherViewModel.$seoul,
                        koreaWeatherViewModel.$jejuCurrentWeather,
                        koreaWeatherViewModel.$seoulCurrentWeather)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] jeju, seoul, jejuWeather, seoulWeather in
            
            guard let jejuCollect = jeju?.response?.body?.items?.item else { return }
            guard let seoulCollect = seoul?.response?.body?.items?.item else { return }
            
            // MARK: - 현재 날짜에 해당
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let today = dateFormatter.string(from: Date())
            
            // MARK: - 현재 시간에 해당
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH"
            let currentTime = timeFormatter.string(from: Date())
            print("현재 시간은 \(currentTime)")
            
            // MARK: - 제주
            for jeju in jejuCollect {
                if jeju.fcstDate == today {
                    // 현재 시간과 비교하기 위한 시간
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HHmm"
                    let date = dateFormatter.date(from: jeju.fcstTime)!

                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH"
                    let jejuTime = formatter.string(from: date)
                    
                    // 현재 시간과 JSON 시간대가 같다면
                    if currentTime == jejuTime {
                        if jeju.category.rawValue == "TMP" {
                            print("제주에 오게 될 날짜값은 \(jeju.fcstDate)")
                            print("제주에 오게 될 시간값은 \(jejuTime)")
                            print("제주에 오게 될 단 하나의 값은 \(jeju.fcstValue)")
                            self?.koreaWeatherView.koreaMap.jeju.locationLabel.text = "제주"
                            self?.koreaWeatherView.koreaMap.jeju.temperatureLabel.text = jeju.fcstValue + "°"
                        }
                    }
                }
            }
            self?.koreaWeatherView.koreaMap.jeju.weatherImageView.image = UIImage(systemName: jejuWeather)?.withRenderingMode(.alwaysTemplate)
            
            // MARK: - 서울
            for seoul in seoulCollect {
                if seoul.fcstDate == today {
                    // 현재 시간과 비교하기 위한 시간
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HHmm"
                    let date = dateFormatter.date(from: seoul.fcstTime)!

                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH"
                    let seoulTime = formatter.string(from: date)
                    
                    // 현재 시간과 JSON 시간대가 같다면
                    if currentTime == seoulTime {
                        if seoul.category.rawValue == "TMP" {
                            print("서울에 오게 될 날짜값은 \(seoul.fcstDate)")
                            print("서울에 오게 될 시간값은 \(seoulTime)")
                            print("서울에 오게 될 단 하나의 값은 \(seoul.fcstValue)")
                            self?.koreaWeatherView.koreaMap.seoul.locationLabel.text = "서울"
                            self?.koreaWeatherView.koreaMap.seoul.temperatureLabel.text = seoul.fcstValue + "°"
                        }
                    }
                }
            }
            self?.koreaWeatherView.koreaMap.seoul.weatherImageView.image = UIImage(systemName: seoulWeather)?.withRenderingMode(.alwaysTemplate)
        }
        .store(in: &cancellables)
        
        Publishers.Zip4(koreaWeatherViewModel.$gangwon,
                        koreaWeatherViewModel.$incheon,
                        koreaWeatherViewModel.$gangwonCurrentWeather,
                        koreaWeatherViewModel.$incheonCurrentWeather)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] gangwon, incheon, gangwonWeather, incheonWeather in
            guard let gangwonCollect = gangwon?.response?.body?.items?.item else { return }
            guard let incheonCollect = incheon?.response?.body?.items?.item else { return }
            
            // MARK: - 현재 날짜에 해당
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let today = dateFormatter.string(from: Date())
            
            // MARK: - 현재 시간에 해당
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH"
            let currentTime = timeFormatter.string(from: Date())
            print("현재 시간은 \(currentTime)")
            
            // MARK: - 강원
            for gangwon in gangwonCollect {
                if gangwon.fcstDate == today {
                    // 현재 시간과 비교하기 위한 시간
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HHmm"
                    let date = dateFormatter.date(from: gangwon.fcstTime)!

                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH"
                    let gangwonTime = formatter.string(from: date)
                    
                    // 현재 시간과 JSON 시간대가 같다면
                    if currentTime == gangwonTime {
                        if gangwon.category.rawValue == "TMP" {
                            print("강원에 오게 될 날짜값은 \(gangwon.fcstDate)")
                            print("강원에 오게 될 시간값은 \(gangwonTime)")
                            print("강원에 오게 될 단 하나의 값은 \(gangwon.fcstValue)")
                            self?.koreaWeatherView.koreaMap.gangwon.locationLabel.text = "강원"
                            self?.koreaWeatherView.koreaMap.gangwon.temperatureLabel.text = gangwon.fcstValue + "°"
                        }
                    }
                }
            }
            self?.koreaWeatherView.koreaMap.gangwon.weatherImageView.image = UIImage(systemName: gangwonWeather)?.withRenderingMode(.alwaysTemplate)
            
            // MARK: - 인천
            for incheon in incheonCollect {
                if incheon.fcstDate == today {
                    // 현재 시간과 비교하기 위한 시간
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HHmm"
                    let date = dateFormatter.date(from: incheon.fcstTime)!

                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH"
                    let incheonTime = formatter.string(from: date)
                    
                    // 현재 시간과 JSON 시간대가 같다면
                    if currentTime == incheonTime {
                        if incheon.category.rawValue == "TMP" {
                            print("인천에 오게 될 날짜값은 \(incheon.fcstDate)")
                            print("인천에 오게 될 시간값은 \(incheonTime)")
                            print("인천에 오게 될 단 하나의 값은 \(incheon.fcstValue)")
                            self?.koreaWeatherView.koreaMap.incheon.locationLabel.text = "인천"
                            self?.koreaWeatherView.koreaMap.incheon.temperatureLabel.text = incheon.fcstValue + "°"
                        }
                    }
                }
            }
            self?.koreaWeatherView.koreaMap.incheon.weatherImageView.image = UIImage(systemName: incheonWeather)?.withRenderingMode(.alwaysTemplate)
        }
        .store(in: &cancellables)
        
        Publishers.Zip4(koreaWeatherViewModel.$jeonbuk,
                        koreaWeatherViewModel.$jeonnam,
                        koreaWeatherViewModel.$jeonbukCurrentWeather,
                        koreaWeatherViewModel.$jeonnamCurrentWeather)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] jeonbuk, jeonnam, jeonbukWeather, jeonnamWeather in
            guard let jeonbukCollect = jeonbuk?.response?.body?.items?.item else { return }
            guard let jeonnamCollect = jeonnam?.response?.body?.items?.item else { return }
            
            // MARK: - 현재 날짜에 해당
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let today = dateFormatter.string(from: Date())
            
            // MARK: - 현재 시간에 해당
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH"
            let currentTime = timeFormatter.string(from: Date())
            print("현재 시간은 \(currentTime)")
            
            // MARK: - 전라북도
            for jeonbuk in jeonbukCollect {
                if jeonbuk.fcstDate == today {
                    // 현재 시간과 비교하기 위한 시간
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HHmm"
                    let date = dateFormatter.date(from: jeonbuk.fcstTime)!

                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH"
                    let jeonbukTime = formatter.string(from: date)
                    
                    // 현재 시간과 JSON 시간대가 같다면
                    if currentTime == jeonbukTime {
                        if jeonbuk.category.rawValue == "TMP" {
                            print("전북에 오게 될 날짜값은 \(jeonbuk.fcstDate)")
                            print("전북에 오게 될 시간값은 \(jeonbukTime)")
                            print("전북에 오게 될 단 하나의 값은 \(jeonbuk.fcstValue)")
                            self?.koreaWeatherView.koreaMap.jeonbuk.locationLabel.text = "전북"
                            self?.koreaWeatherView.koreaMap.jeonbuk.temperatureLabel.text = jeonbuk.fcstValue + "°"
                        }
                    }
                }
            }
            self?.koreaWeatherView.koreaMap.jeonbuk.weatherImageView.image = UIImage(systemName: jeonbukWeather)?.withRenderingMode(.alwaysTemplate)
            
            // MARK: - 전라남도
            for jeonnam in jeonnamCollect {
                if jeonnam.fcstDate == today {
                    // 현재 시간과 비교하기 위한 시간
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HHmm"
                    let date = dateFormatter.date(from: jeonnam.fcstTime)!

                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH"
                    let jeonnamTime = formatter.string(from: date)
                    
                    // 현재 시간과 JSON 시간대가 같다면
                    if currentTime == jeonnamTime {
                        if jeonnam.category.rawValue == "TMP" {
                            print("전남에 오게 될 날짜값은 \(jeonnam.fcstDate)")
                            print("전남에 오게 될 시간값은 \(jeonnamTime)")
                            print("전남에 오게 될 단 하나의 값은 \(jeonnam.fcstValue)")
                            self?.koreaWeatherView.koreaMap.jeonnam.locationLabel.text = "전남"
                            self?.koreaWeatherView.koreaMap.jeonnam.temperatureLabel.text = jeonnam.fcstValue + "°"
                        }
                    }
                }
            }
            self?.koreaWeatherView.koreaMap.jeonnam.weatherImageView.image = UIImage(systemName: jeonnamWeather)?.withRenderingMode(.alwaysTemplate)
        }
        .store(in: &cancellables)
        
        Publishers.Zip4(koreaWeatherViewModel.$chungbuk,
                        koreaWeatherViewModel.$chungnam,
                        koreaWeatherViewModel.$chungbukCurrentWeather,
                        koreaWeatherViewModel.$chungnamCurrentWeather)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] chungbuk, chungnam, chungbukWeather, chungnamWeather in
            guard let chungbukCollect = chungbuk?.response?.body?.items?.item else { return }
            guard let chungnamCollect = chungnam?.response?.body?.items?.item else { return }
            
            // MARK: - 현재 날짜에 해당
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let today = dateFormatter.string(from: Date())
            
            // MARK: - 현재 시간에 해당
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH"
            let currentTime = timeFormatter.string(from: Date())
            print("현재 시간은 \(currentTime)")
            
            // MARK: - 충청북도
            for chungbuk in chungbukCollect {
                if chungbuk.fcstDate == today {
                    // 현재 시간과 비교하기 위한 시간
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HHmm"
                    let date = dateFormatter.date(from: chungbuk.fcstTime)!

                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH"
                    let chungbukTime = formatter.string(from: date)
                    
                    // 현재 시간과 JSON 시간대가 같다면
                    if currentTime == chungbukTime {
                        if chungbuk.category.rawValue == "TMP" {
                            print("충북에 오게 될 날짜값은 \(chungbuk.fcstDate)")
                            print("충북에 오게 될 시간값은 \(chungbukTime)")
                            print("충북에 오게 될 단 하나의 값은 \(chungbuk.fcstValue)")
                            self?.koreaWeatherView.koreaMap.chungbuk.locationLabel.text = "충북"
                            self?.koreaWeatherView.koreaMap.chungbuk.temperatureLabel.text = chungbuk.fcstValue + "°"
                        }
                    }
                }
            }
            self?.koreaWeatherView.koreaMap.chungbuk.weatherImageView.image = UIImage(systemName: chungbukWeather)?.withRenderingMode(.alwaysTemplate)
            
            // MARK: - 충청남도
            for chungnam in chungnamCollect {
                if chungnam.fcstDate == today {
                    // 현재 시간과 비교하기 위한 시간
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HHmm"
                    let date = dateFormatter.date(from: chungnam.fcstTime)!

                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH"
                    let chungnamTime = formatter.string(from: date)
                    
                    // 현재 시간과 JSON 시간대가 같다면
                    if currentTime == chungnamTime {
                        if chungnam.category.rawValue == "TMP" {
                            print("충남에 오게 될 날짜값은 \(chungnam.fcstDate)")
                            print("충남에 오게 될 시간값은 \(chungnamTime)")
                            print("충남에 오게 될 단 하나의 값은 \(chungnam.fcstValue)")
                            self?.koreaWeatherView.koreaMap.chungnam.locationLabel.text = "충남"
                            self?.koreaWeatherView.koreaMap.chungnam.temperatureLabel.text = chungnam.fcstValue + "°"
                        }
                    }
                }
            }
            self?.koreaWeatherView.koreaMap.chungnam.weatherImageView.image = UIImage(systemName: chungnamWeather)?.withRenderingMode(.alwaysTemplate)
        }
        .store(in: &cancellables)
        
        Publishers.Zip4(koreaWeatherViewModel.$gyeonggi,
                        koreaWeatherViewModel.$gyeongbuk,
                        koreaWeatherViewModel.$gyeonggiCurrentWeather,
                        koreaWeatherViewModel.$gyeongbukCurrentWeather)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] gyeonggi, gyeongbuk, gyeonggiWeather, gyeongbukWeather in
                guard let gyeonggiCollect = gyeonggi?.response?.body?.items?.item else { return }
                guard let gyeongbukCollect = gyeongbuk?.response?.body?.items?.item else { return }
                
                // MARK: - 현재 날짜에 해당
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMdd"
                let today = dateFormatter.string(from: Date())
                
                // MARK: - 현재 시간에 해당
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH"
                let currentTime = timeFormatter.string(from: Date())
                print("현재 시간은 \(currentTime)")
                
                // MARK: - 경기도
                for gyeonggi in gyeonggiCollect {
                    if gyeonggi.fcstDate == today {
                        // 현재 시간과 비교하기 위한 시간
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HHmm"
                        let date = dateFormatter.date(from: gyeonggi.fcstTime)!

                        let formatter = DateFormatter()
                        formatter.dateFormat = "HH"
                        let gyeonggiTime = formatter.string(from: date)
                        
                        // 현재 시간과 JSON 시간대가 같다면
                        if currentTime == gyeonggiTime {
                            if gyeonggi.category.rawValue == "TMP" {
                                print("경기에 오게 될 날짜값은 \(gyeonggi.fcstDate)")
                                print("경기에 오게 될 시간값은 \(gyeonggiTime)")
                                print("경기에 오게 될 단 하나의 값은 \(gyeonggi.fcstValue)")
                                self?.koreaWeatherView.koreaMap.gyeonggi.locationLabel.text = "경기"
                                self?.koreaWeatherView.koreaMap.gyeonggi.temperatureLabel.text = gyeonggi.fcstValue + "°"
                            }
                        }
                    }
                }
                self?.koreaWeatherView.koreaMap.gyeonggi.weatherImageView.image = UIImage(systemName: gyeonggiWeather)?.withRenderingMode(.alwaysTemplate)
                
                // MARK: - 경상북도
                for gyeongbuk in gyeongbukCollect {
                    if gyeongbuk.fcstDate == today {
                        // 현재 시간과 비교하기 위한 시간
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HHmm"
                        let date = dateFormatter.date(from: gyeongbuk.fcstTime)!

                        let formatter = DateFormatter()
                        formatter.dateFormat = "HH"
                        let gyeongbukTime = formatter.string(from: date)
                        
                        // 현재 시간과 JSON 시간대가 같다면
                        if currentTime == gyeongbukTime {
                            if gyeongbuk.category.rawValue == "TMP" {
                                print("경북에 오게 될 날짜값은 \(gyeongbuk.fcstDate)")
                                print("경북에 오게 될 시간값은 \(gyeongbukTime)")
                                print("경북에 오게 될 단 하나의 값은 \(gyeongbuk.fcstValue)")
                                self?.koreaWeatherView.koreaMap.gyeongbuk.locationLabel.text = "경북"
                                self?.koreaWeatherView.koreaMap.gyeongbuk.temperatureLabel.text = gyeongbuk.fcstValue + "°"
                            }
                        }
                    }
                }
                self?.koreaWeatherView.koreaMap.gyeongbuk.weatherImageView.image = UIImage(systemName: gyeongbukWeather)?.withRenderingMode(.alwaysTemplate)
            }
            .store(in: &cancellables)
        
        Publishers.Zip(koreaWeatherViewModel.$gyeongnam,
                       koreaWeatherViewModel.$gyeongnamCurrentWeather)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] gyeongnam, gyeongnamWeather in
            guard let gyeongnamCollect = gyeongnam?.response?.body?.items?.item else { return }
            
            // MARK: - 현재 날짜에 해당
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let today = dateFormatter.string(from: Date())
            
            // MARK: - 현재 시간에 해당
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH"
            let currentTime = timeFormatter.string(from: Date())
            print("현재 시간은 \(currentTime)")
            
            // MARK: - 경상남도
            for gyeongnam in gyeongnamCollect {
                if gyeongnam.fcstDate == today {
                    // 현재 시간과 비교하기 위한 시간
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HHmm"
                    let date = dateFormatter.date(from: gyeongnam.fcstTime)!

                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH"
                    let gyeongnamTime = formatter.string(from: date)
                    
                    // 현재 시간과 JSON 시간대가 같다면
                    if currentTime == gyeongnamTime {
                        if gyeongnam.category.rawValue == "TMP" {
                            print("경남에 오게 될 날짜값은 \(gyeongnam.fcstDate)")
                            print("경남에 오게 될 시간값은 \(gyeongnamTime)")
                            print("경남에 오게 될 단 하나의 값은 \(gyeongnam.fcstValue)")
                            self?.koreaWeatherView.koreaMap.gyeongnam.locationLabel.text = "경남"
                            self?.koreaWeatherView.koreaMap.gyeongnam.temperatureLabel.text = gyeongnam.fcstValue + "°"
                        }
                    }
                }
            }
            self?.koreaWeatherView.koreaMap.gyeongnam.weatherImageView.image = UIImage(systemName: gyeongnamWeather)?.withRenderingMode(.alwaysTemplate)
        }
        .store(in: &cancellables)
        
        setOtherViewData()
    }
    
    private func setOtherViewData() {
        otherViewModel.$currentWeather
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentWeather in
                
            }
            .store(in: &cancellables)
    }
    
    func setAutolayout() {
        [scrollView, searchMagnifyingButton, pageControl].forEach { view.addSubview($0) }
        scrollView.addSubview(stackView)
        
        // MARK: - 뷰 레이아웃
        searchMagnifyingButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.trailing.equalTo(view.snp.trailing).offset(-30)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70)
        }
        
        mainInformationView.snp.makeConstraints { make in
            make.height.equalTo(500)
        }
        
        hourlyForecastView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        
        dailyForecastView.snp.makeConstraints { make in
            make.height.equalTo(740)
        }
        
        particulateMatterView.snp.makeConstraints { make in
            make.height.equalTo(400)
        }
        
        koreaWeatherView.snp.makeConstraints { make in
            make.height.equalTo(500)
        }
        
        
        // MARK: - 스크롤 뷰 및 스택 뷰 레이아웃
        scrollView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.top.equalTo(pageControl.snp.bottom).offset(30)
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
        let companyArray = [mainInformationView, hourlyForecastView, dailyForecastView, particulateMatterView, koreaWeatherView]
        for company in companyArray {
            var elementView = UIView()
            elementView = company
            elementView.translatesAutoresizingMaskIntoConstraints = false
            elementView.heightAnchor.constraint(equalToConstant: 3000).isActive = true
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
        case "sun.min":
            detailColoring(mainInformationView: mainInformationView, backgroundColor: .dayBackground, mainLabelColor: .dayMainLabel, sideLabelColor: .daySideLabel, symbolName: symbolName, paletteColors1: .dayImage, paletteColors2: .clear, paletteColors3: .clear)
            
        case "moon.stars":
            detailColoring(mainInformationView: mainInformationView, backgroundColor: .nightBackground, mainLabelColor: .nightMainLabel, sideLabelColor: .nightSideLabel, symbolName: symbolName, paletteColors1: .nightImage, paletteColors2: .white, paletteColors3: .clear)
            
        case "cloud":
            detailColoring(mainInformationView: mainInformationView, backgroundColor: .cloudyBackground, mainLabelColor: .cloudyMainLabel, sideLabelColor: .cloudySideLabel, symbolName: symbolName, paletteColors1: .cloudyImage, paletteColors2: .cloudyImage, paletteColors3: .clear)
            
        case "cloud.sun":
            detailColoring(mainInformationView: mainInformationView, backgroundColor: .cloudyBackground, mainLabelColor: .cloudyMainLabel, sideLabelColor: .cloudySideLabel, symbolName: symbolName, paletteColors1: .cloudyImage, paletteColors2: .dayImage, paletteColors3: .clear)
            
        case "cloud.drizzle":
            detailColoring(mainInformationView: mainInformationView, backgroundColor: .rainyBackground, mainLabelColor: .rainyMainLabel, sideLabelColor: .rainySideLabel, symbolName: symbolName, paletteColors1: .rainyImage, paletteColors2: .systemCyan, paletteColors3: .clear)
            
        case "cloud.rain":
            detailColoring(mainInformationView: mainInformationView, backgroundColor: .rainyBackground, mainLabelColor: .rainyMainLabel, sideLabelColor: .rainySideLabel, symbolName: symbolName, paletteColors1: .rainyImage, paletteColors2: .systemCyan, paletteColors3: .clear)
            
        case "cloud.bolt.rain":
            detailColoring(mainInformationView: mainInformationView, backgroundColor: .rainyBackground, mainLabelColor: .rainyMainLabel, sideLabelColor: .rainySideLabel, symbolName: symbolName, paletteColors1: .rainyImage, paletteColors2: .systemCyan, paletteColors3: .clear)

        case "cloud.heavyrain":
            detailColoring(mainInformationView: mainInformationView, backgroundColor: .rainyBackground, mainLabelColor: .rainyMainLabel, sideLabelColor: .rainySideLabel, symbolName: symbolName, paletteColors1: .rainyImage, paletteColors2: .systemCyan, paletteColors3: .clear)
            
        case "cloud.fog":
            detailColoring(mainInformationView: mainInformationView, backgroundColor: .rainyBackground, mainLabelColor: .rainyMainLabel, sideLabelColor: .rainySideLabel, symbolName: symbolName, paletteColors1: .rainyImage, paletteColors2: .systemCyan, paletteColors3: .clear)
            
        case "cloud.moon":
            detailColoring(mainInformationView: mainInformationView, backgroundColor: .nightBackground, mainLabelColor: .nightMainLabel, sideLabelColor: .nightSideLabel, symbolName: symbolName, paletteColors1: .rainyImage, paletteColors2: .nightImage, paletteColors3: .clear)
            
        case "cloud.moon.rain":
            detailColoring(mainInformationView: mainInformationView, backgroundColor: .nightBackground, mainLabelColor: .nightMainLabel, sideLabelColor: .nightSideLabel, symbolName: symbolName, paletteColors1: .rainyImage, paletteColors2: .nightImage, paletteColors3: .systemCyan)
            
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
    private func particulateMatterCalculatorAccordingToLocation(location: String, particulateData: [ParticulateMatterItem], isDayLight: Bool, symbolName: String) {
        switch location {
        case "daegu":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].daegu!, isDayLight: isDayLight, symbolName: symbolName)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].daegu!, isDayLight: isDayLight, symbolName: symbolName)
                }
            }
        case "chungnam":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].chungnam!, isDayLight: isDayLight, symbolName: symbolName)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].chungnam!, isDayLight: isDayLight, symbolName: symbolName)
                }
            }
        case "incheon":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].incheon!, isDayLight: isDayLight, symbolName: symbolName)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].incheon!, isDayLight: isDayLight, symbolName: symbolName)
                }
            }
        case "daejeon":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].daejeon!, isDayLight: isDayLight, symbolName: symbolName)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].daejeon!, isDayLight: isDayLight, symbolName: symbolName)
                }
            }
        case "gyeongbuk":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].gyeongbuk!, isDayLight: isDayLight, symbolName: symbolName)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].gyeongbuk!, isDayLight: isDayLight, symbolName: symbolName)
                }
            }
        case "sejong":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].sejong!, isDayLight: isDayLight, symbolName: symbolName)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].sejong!, isDayLight: isDayLight, symbolName: symbolName)
                }
            }
        case "gwangju":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].gwangju!, isDayLight: isDayLight, symbolName: symbolName)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].gwangju!, isDayLight: isDayLight, symbolName: symbolName)
                }
            }
        case "jeonbuk":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].jeonbuk!, isDayLight: isDayLight, symbolName: symbolName)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].jeonbuk!, isDayLight: isDayLight, symbolName: symbolName)
                }
            }
        case "gangwon":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].gangwon!, isDayLight: isDayLight, symbolName: symbolName)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].gangwon!, isDayLight: isDayLight, symbolName: symbolName)
                }
            }
        case "ulsan":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].ulsan!, isDayLight: isDayLight, symbolName: symbolName)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].ulsan!, isDayLight: isDayLight, symbolName: symbolName)
                }
            }
        case "jeonnam":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].jeonnam!, isDayLight: isDayLight, symbolName: symbolName)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].jeonnam!, isDayLight: isDayLight, symbolName: symbolName)
                }
            }
        case "seoul":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].seoul!, isDayLight: isDayLight, symbolName: symbolName)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].seoul!, isDayLight: isDayLight, symbolName: symbolName)
                }
            }
        case "busan":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].busan!, isDayLight: isDayLight, symbolName: symbolName)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].busan!, isDayLight: isDayLight, symbolName: symbolName)
                }
            }
        case "jeju":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].jeju!, isDayLight: isDayLight, symbolName: symbolName)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].jeju!, isDayLight: isDayLight, symbolName: symbolName)
                }
            }
        case "chungbuk":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].chungbuk!, isDayLight: isDayLight, symbolName: symbolName)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].chungbuk!, isDayLight: isDayLight, symbolName: symbolName)
                }
            }
        case "gyeongnam":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].gyeongnam!, isDayLight: isDayLight, symbolName: symbolName)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].gyeongnam!, isDayLight: isDayLight, symbolName: symbolName)
                }
            }
        case "gyeonggi":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].gyeonggi!, isDayLight: isDayLight, symbolName: symbolName)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].gyeonggi!, isDayLight: isDayLight, symbolName: symbolName)
                }
            }
        default: return

        }
    }

    // MARK: - 미세먼지 농도에 따라 좋음, 보통, 나쁨, 매우나쁨으로 나누는 메소드
    private func distributeParticulateMatter(density: String, isDayLight: Bool, symbolName: String) {
        particulateMatterFetchCount += 1
        if particulateMatterFetchCount == 1 {
            guard let myCurrentLocation = Int(density) else { return }
            print("미세먼지의 값은 \(myCurrentLocation)")
            
            particulateMatterView.particulateMatterData.particulateDataReceiver = density
            particulateMatterView.particulateMatterData.dayOrNightDistributor = isDayLight
            particulateMatterView.particulateMatterData.symbolName = symbolName
        }
    }

    private func distributeUltraParticulateMatter(density: String, isDayLight: Bool, symbolName: String) {
        ultraParticulateMatterFetchCount += 1
        if ultraParticulateMatterFetchCount == 1 {
            guard let myCurrentLocation = Int(density) else { return }
            print("초미세먼지의 값은 \(myCurrentLocation)")
            
            particulateMatterView.ultraParticulateMatterData.ultraParticulateDataReceiver = density
            particulateMatterView.ultraParticulateMatterData.dayOrNightDistributor = isDayLight
            particulateMatterView.ultraParticulateMatterData.symbolName = symbolName
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
        dailyForecastViewModel.fetchWeather(location: location)
        particulateMatterViewModel.fetchWeather(location: location)
        koreaWeatherViewModel.fetchWeather()
        otherViewModel.fetchWeather(location: location)
    }
}

