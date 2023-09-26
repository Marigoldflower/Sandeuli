//
//  SearchResultViewModel.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/26.
//

import Combine
import UIKit
import CombineReactor

final class SearchResultViewModel: Reactor {
    
    enum Action {
        case backButtonTapped
    }
    
    enum Mutation {
        case backToWeatherController(Bool)
    }
    
    // 3. State
    // 상태 데이터를 기록하고 있으며, initialState는 State를 사용하여 UI 상태를 업데이트 한다.
    struct State {
        var backButtonIsTapped: Bool = false
    }
    
    // 4. initialState
    // "현재 UI 상태"를 나타내는 영역. State를 이용하여 UI를 업데이트한다.
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> AnyPublisher<Mutation, Never> {
        switch action {
        case .backButtonTapped:
            return Just(Mutation.backToWeatherController(true))
                .eraseToAnyPublisher()
        }
    }
   
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .backToWeatherController(let value):
            newState.backButtonIsTapped = value
        }
        
        return newState
    }
}




