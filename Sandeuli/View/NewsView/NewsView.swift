//
//  NewsView.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/18.
//

import UIKit
import SnapKit
import SwiftSoup

final class NewsView: UIView {
    // MARK: - Header 영역
    private let headerViewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "newspaper")?.applyingSymbolConfiguration(.init(paletteColors: [.white]))
        return imageView
    }()
    
    private let headerViewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 15)
        label.text = "날씨 뉴스"
        label.textColor = .white
        return label
    }()
    
    // MARK: - StackView
    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headerViewImage, headerViewLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    
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
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - Cell에 보낼 데이터
    var weatherNewsImage = UIImage()
    var weatherNewsTitle = String()
    var weatherNewsText = String()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension NewsView: ViewDrawable {
    func configureUI() {
        setAutolayout()
        addGradientToView(self)
        backgroundColor = UIColor.gradientBlue.withAlphaComponent(0.65)
    }
    
    func setAutolayout() {
        [headerStackView, collectionView].forEach { addSubview($0) }
        
        headerStackView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(15)
            make.top.equalTo(snp.top).offset(12)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading)
            make.trailing.equalTo(snp.trailing)
            make.top.equalTo(snp.top).offset(25)
            make.bottom.equalTo(snp.bottom)
        }
    }
    
    // MARK: - Gradient 적용 메소드
    private func addGradientToView(_ view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.gradientBlue.cgColor, UIColor.gradientWhite.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

// MARK: - DataSource & Delegate
extension NewsView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.identifier, for: indexPath) as! NewsCell
        
        return cell
    }
}

extension NewsView: UICollectionViewDelegateFlowLayout {
    // ⭐️ 컬렉션 뷰 각각의 아이템 사이즈 크기를 정하는 곳 ⭐️
    // 컬렉션 뷰는 각각의 아이템 사이즈를 반드시 정해줘야 한다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 180)
    }
}
