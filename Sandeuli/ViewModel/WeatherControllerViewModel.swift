//
//  WeatherControllerViewModel.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/26.
//

import Combine
import UIKit
import CombineReactor

final class WeatherControllerViewModel: Reactor {
    
    enum Action {
        case magnifyingButtonTapped(PresentType)
    }
    
    enum Mutation {
        case moveToSearchResultController(PresentType?)
    }
    
    // 3. State
    // 상태 데이터를 기록하고 있으며, initialState는 State를 사용하여 UI 상태를 업데이트 한다.
    struct State {
        var youAreInSearchResultController: PresentType?
    }
    
    // 4. initialState
    // "현재 UI 상태"를 나타내는 영역. State를 이용하여 UI를 업데이트한다.
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> AnyPublisher<Mutation, Never> {
        switch action {
        case .magnifyingButtonTapped(let vc): 
            return Just(Mutation.moveToSearchResultController(vc))
                .eraseToAnyPublisher()
        }
    }
   
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .moveToSearchResultController(let vc):
            newState.youAreInSearchResultController = vc
        }
        
        return newState
    }
    
    // MARK: - Controller를 가져오는 메소드
    func getSearchResultViewController(_ type: PresentType) -> SearchResultViewController {
        var shouldPresent = SearchResultViewController()
        
        switch type {
        case .searchResultViewController:
            let getSearchResult = SearchResultViewController()
            getSearchResult.reactor = SearchResultViewModel()
            shouldPresent = getSearchResult
        }
        
        return shouldPresent
    }
    
    enum PresentType {
        case searchResultViewController
    }
}



