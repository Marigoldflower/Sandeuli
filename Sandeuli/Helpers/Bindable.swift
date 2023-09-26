//
//  Bindable.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/26.
//

import Foundation
import CombineReactor

protocol Bindable {
    associatedtype Reactor: CombineReactor.Reactor
    func bindState(_ reactor: Reactor)
    func bindAction(_ reactor: Reactor)
}
