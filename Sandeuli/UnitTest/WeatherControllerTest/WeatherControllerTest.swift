//
//  WeatherControllerTest.swift
//  WeatherControllerTest
//
//  Created by 황홍필 on 2023/10/19.
//

import XCTest
@testable import Sandeuli

final class WeatherControllerTest: XCTestCase {
    
    var weatherController: WeatherController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        weatherController = WeatherController()
    }
    
    override func tearDownWithError() throws {
        weatherController = nil
        try super.tearDownWithError()
    }
    
    func testColoringMethodWorks() {
        // Given
        let mockSymbolName = "cloud.rain"
        
        // When
        weatherController.coloringMethod(symbolName: mockSymbolName)
        
        // Then
        XCTAssertEqual(weatherController.mainInformationView.backgroundColor, .rainyBackground)
        XCTAssertEqual(weatherController.mainInformationView.currentSky.textColor, .rainyMainLabel)
    }
    
    func testparticulateMatterCalculatorWorks() {
        // Given
        let particulateViewModel = ParticulateMatterViewModel(particulateMatterNetworkProtocol: MockParticulateMatterNetworkManager.shared)
        let mockLocation = "daegu"
        guard let mockParticulateData = particulateViewModel.particulateMatter?.particulateMatterResponse?.body?.items else { return }
        let mockSymbolName = "cloud.rain"
        
        // When
        weatherController.particulateMatterCalculatorAccordingToLocation(location: mockLocation, particulateData: mockParticulateData, isDayLight: true, symbolName: mockSymbolName)
        
        // Then
        XCTAssertEqual(weatherController.particulateMatterView.ultraParticulateMatterData.symbolName, mockLocation)
    }

}

