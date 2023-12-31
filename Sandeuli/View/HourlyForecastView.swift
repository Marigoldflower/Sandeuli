//
//  TodayForecastView.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/06.
//

import UIKit
import SnapKit

final class HourlyForecastView: UIView {
    
    // MARK: - UI Components
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal // 가로로 컬렉션 뷰 생성
        flowLayout.minimumInteritemSpacing = 0 // 아이템 사이 간격 설정
        flowLayout.minimumLineSpacing = 0 // 아이템 위 아래 간격 설정
        // ⭐️ 코드로 컬렉션 뷰를 생성할 때에는 반드시 파라미터가 존재해야 한다. ⭐️
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HourlyForecastCell.self, forCellWithReuseIdentifier: HourlyForecastCell.identifier)
        collectionView.backgroundColor = UIColor.gradientBlue.withAlphaComponent(0.75)
        return collectionView
    }()
    
    // MARK: - 일출 & 일몰 한 번만 didSet이 불리도록 하는 변수
    var sunriseDidSetCallCount = Int()
    var sunsetDidSetCallCount = Int()
    
    // MARK: - Data Components
    var timeArray: [String] = [] {
        didSet {
            timeArray[0] = "지금"
            if let indexTomorrow = timeArray.firstIndex(of: "00시") {
                timeArray[indexTomorrow] = "내일"
            }

            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var weatherImageArray: [UIImage] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var temperatureArray: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var sunrise: String = String() {
        didSet {
            sunriseDidSetCallCount += 1
            
            if sunsetDidSetCallCount == 1 {
                print("Sunrise에 값이 들어왔습니다 \(sunrise)")
                if let sunriseIndex = timeArray.firstIndex(of: sunriseCompareWithCollectionView) {
                    
                    self.timeArray.insert(sunrise, at: sunriseIndex + 1)
                    self.temperatureArray.insert("일출", at: sunriseIndex + 1)
                    self.weatherImageArray.insert(UIImage(systemName: "sunrise.fill")?.withRenderingMode(.alwaysOriginal) ?? UIImage(), at: sunriseIndex + 1)
                }
            }
        }
    }
    var sunset: String = String() {
        didSet {
            sunsetDidSetCallCount += 1
            
            if sunsetDidSetCallCount == 1 {
                print("Sunset에 값이 들어왔습니다 \(sunset)")
                if let sunsetIndex = timeArray.firstIndex(of: sunsetCompareWithCollectionView) {
                    
                    self.timeArray.insert(sunset, at: sunsetIndex + 1)
                    self.temperatureArray.insert("일몰", at: sunsetIndex + 1)
                    self.weatherImageArray.insert(UIImage(systemName: "sunset.fill")?.withRenderingMode(.alwaysOriginal) ?? UIImage(), at: sunsetIndex + 1)
                }
            }
        }
    }
    var sunriseCompareWithCollectionView: String = String()
    var sunsetCompareWithCollectionView: String = String()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        addGradientToCollectionView(self.collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension HourlyForecastView: ViewDrawable {
    func configureUI() {
        setAutolayout()
    }
    
    func setAutolayout() {
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    // MARK: - Gradient 적용 메소드
    private func addGradientToCollectionView(_ collectionView: UICollectionView) {

        let gradientContainerView = GradientContainerView(frame: collectionView.bounds)
        gradientContainerView.setGradientLayer(colors: [UIColor.gradientBlue.cgColor, UIColor.gradientWhite.cgColor],
                                               startPoint: CGPoint(x: 0, y: 0),
                                               endPoint: CGPoint(x: 1, y: 1))

        collectionView.backgroundView = gradientContainerView
    }
}

extension HourlyForecastView: UICollectionViewDataSource, UICollectionViewDelegate {
    // 셀의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if timeArray.count > 26 {
            return 26
        }
        
        return timeArray.count
    }

    // 각 셀에 들어가게 될 객체 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCell.identifier, for: indexPath) as! HourlyForecastCell
        
        cell.time.text = timeArray[indexPath.item]
        cell.weatherImage.image = weatherImageArray[indexPath.item]
        cell.temperature.text = temperatureArray[indexPath.item]

        return cell
    }
}

// ⭐️ 이 Protocol 내에서만 각각의 아이템 사이즈를 정해줄 수 있다. 반드시 기억하기! ⭐️
// 다른 Protocol 내에서는 각각의 아이템 사이즈를 정해줄 수 없다.
extension HourlyForecastView: UICollectionViewDelegateFlowLayout {
    // ⭐️ 컬렉션 뷰 각각의 아이템 사이즈 크기를 정하는 곳 ⭐️
    // 컬렉션 뷰는 각각의 아이템 사이즈를 반드시 정해줘야 한다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 180)
    }
}

