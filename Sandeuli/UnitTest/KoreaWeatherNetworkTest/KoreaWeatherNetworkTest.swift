//
//  KoreaWeatherNetworkTest.swift
//  KoreaWeatherNetworkTest
//
//  Created by 황홍필 on 2023/10/18.
//

import XCTest
@testable import Sandeuli
import Combine

final class KoreaWeatherNetworkTest: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
    
    var mockNetworkManager: MockKoreaWeatherNetworkManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockNetworkManager = MockKoreaWeatherNetworkManager.shared
    }
    
    override func tearDownWithError() throws {
        mockNetworkManager = nil
        try super.tearDownWithError()
    }
    
    func testFetchUserData(){
        //Given
        // 가짜 데이터는 테스트가 되는지 안 되는지 실험만 하는 용도이기 때문에 아무 값이나 넣어도 상관 없다.
        let mockData = KoreaWeather(response: Response(header: Header(resultCode: "00", resultMsg: "몰라"), body: Body(dataType: "몰라", items: Items(item: [Item(baseDate: "몰라", baseTime: "몰라", category: Category.pcp, fcstDate: "몰라", fcstTime: "시간", fcstValue: "값", nx: 1, ny: 2)]), pageNo: 3, numOfRows: 4, totalCount: 5)))
        mockNetworkManager.koreaMockData = mockData
        
        //When - ViewModel에 진짜 네트워크나 가짜 네트워크를 할당할 수 있다.
        let viewModel = KoreaWeatherViewModel(koreaWeatherNetworkProtocol: mockNetworkManager)
        
        // Expectation (비동기 처리가 끝나면 실행될 구문)
        let expectation = self.expectation(description: "Fetching Personal Info")
        
        var mockKoreaWeather: KoreaWeather!
        
        // 방금 들어간 mockData를 리턴하는 코드.
        // 그 mockData를 mockPersonalInfo에 할당해놓는다.
        mockNetworkManager.getNetworkDatas(regionURL: "아무값")
            .sink { completion in
                switch completion {
                case .finished:
                    print("종료됨!")
                    // 비동기 처리가 완료되면 fulfill이 실행된다.
                    // fulfill이 실행되면 expectation의 글을 코드창에 띄운다.
                    expectation.fulfill()
                case .failure(let error):
                    print("에러 발생 \(error)")
                }
            } receiveValue: { koreaWeather in
                // mock 데이터를 저장
                mockKoreaWeather = koreaWeather
            }
            .store(in: &cancellables)
        
        // 진짜 네트워크나 가짜 네트워크를 실행한다.
        // 만일 viewModel에 진짜 네트워크 인스턴스를 찍었다면 viewModel.personalInfo가 실제 네트워크 값이 들어가 있을 것이다.
        // 만일 viewModel에 가짜 네트워크 인스턴스를 찍었다면 viewModel.personalInfo가 가짜 네트워크 값이 들어가 있을 것이다.
        viewModel.fetchKoreaWeatherNetwork(regionURL: "nx=60&ny=127")
        let testPersonalInfo = viewModel.seoul
        
        // 네트워크 비동기 처리 결과를 5초간 기다림.
        // 5초가 지나면 실패로 간주한다.
        waitForExpectations(timeout: 5) { error in  // 비동기 작업 완료 기다림
            if let error = error {
                XCTFail("waitForExpectations 에러 : \(error)")
            }
            
            // Then
            // mockData와 viewModel에 들어간 데이터를 비교
            XCTAssertEqual(testPersonalInfo?.response?.body?.items?.item?.first?.baseDate, mockKoreaWeather.response?.body?.items?.item?.first?.baseDate)
            XCTAssertEqual(testPersonalInfo?.response?.body?.items?.item?.first?.fcstDate, mockKoreaWeather.response?.body?.items?.item?.first?.fcstDate)
            XCTAssertEqual(testPersonalInfo?.response?.body?.items?.item?.first?.fcstValue, mockKoreaWeather.response?.body?.items?.item?.first?.fcstValue)
        }
    }

}
