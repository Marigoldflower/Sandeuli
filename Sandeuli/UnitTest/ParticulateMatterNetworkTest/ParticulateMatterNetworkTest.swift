//
//  ParticulateMatterNetworkTest.swift
//  ParticulateMatterNetworkTest
//
//  Created by 황홍필 on 2023/10/18.
//

import XCTest
@testable import Sandeuli
import Combine

final class ParticulateMatterNetworkTest: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []
    
    var mockNetworkManager: MockParticulateMatterNetworkManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockNetworkManager = MockParticulateMatterNetworkManager.shared
    }
    
    override func tearDownWithError() throws {
        mockNetworkManager = nil
        try super.tearDownWithError()
    }
    
    func testFetchUserData(){
        //Given
        let mockData = ParticulateMatter(particulateMatterResponse: ParticulateMatterResponse(body: ParticulateMatterBody(items: [ParticulateMatterItem(daegu: "대구", chungnam: "충남", incheon: "인천", daejeon: "대전", gyeongbuk: "경북", sejong: "세종", gwangju: "광주", jeonbuk: "전북", gangwon: "강원", ulsan: "울산", jeonnam: "전남", seoul: "서울", busan: "부산", jeju: "제주", chungbuk: "충북", gyeongnam: "경남", dataTime: "몰라", dataGubun: "몰라", gyeonggi: "경기", itemCode: "00")]), header: ParticulateMatterHeader(resultMsg: "몰라", resultCode: "몰라")))
        mockNetworkManager.particulateMockData = mockData
        
        //When - ViewModel에 진짜 네트워크나 가짜 네트워크를 할당할 수 있다.
        let viewModel = ParticulateMatterViewModel(particulateMatterNetworkProtocol: mockNetworkManager)
        
        // Expectation (비동기 처리가 끝나면 실행될 구문)
        let expectation = self.expectation(description: "Fetching Personal Info")
        
        var mockParticulate: ParticulateMatter!
        
        // 방금 들어간 mockData를 리턴하는 코드.
        // 그 mockData를 mockPersonalInfo에 할당해놓는다.
        mockNetworkManager.getNetworkDatas(density: "PM10")
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
            } receiveValue: { particulate in
                // mock 데이터를 저장
                mockParticulate = particulate
            }
            .store(in: &cancellables)
        
        // 진짜 네트워크나 가짜 네트워크를 실행한다.
        // 만일 viewModel에 진짜 네트워크 인스턴스를 찍었다면 viewModel.personalInfo가 실제 네트워크 값이 들어가 있을 것이다.
        // 만일 viewModel에 가짜 네트워크 인스턴스를 찍었다면 viewModel.personalInfo가 가짜 네트워크 값이 들어가 있을 것이다.
        viewModel.fetchParticulateMatterNetwork(density: "PM10")
        let testPersonalInfo = viewModel.particulateMatter
        
        // 네트워크 비동기 처리 결과를 5초간 기다림.
        // 5초가 지나면 실패로 간주한다.
        waitForExpectations(timeout: 10) { error in  // 비동기 작업 완료 기다림
            if let error = error {
                XCTFail("waitForExpectations 에러 : \(error)")
            }
            
            // Then
            // mockData와 viewModel에 들어간 데이터를 비교
            XCTAssertEqual(testPersonalInfo?.particulateMatterResponse?.body?.items?.first?.busan, mockParticulate.particulateMatterResponse?.body?.items?.first?.busan)
            XCTAssertEqual(testPersonalInfo?.particulateMatterResponse?.body?.items?.first?.ulsan, mockParticulate.particulateMatterResponse?.body?.items?.first?.ulsan)
            XCTAssertEqual(testPersonalInfo?.particulateMatterResponse?.body?.items?.first?.seoul, mockParticulate.particulateMatterResponse?.body?.items?.first?.seoul)
        }
    }
  
}
