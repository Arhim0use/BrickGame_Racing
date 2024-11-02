//
//  main.swift
//  Racing_v2
//
//  Created by Chingisbek Anvardinov on 02.11.2024.
//

import Foundation

fileprivate var loop = 0
fileprivate let input: UserAction? = nil

print("Hello, World!")

do {
    let viewModel = RacingViewModel()
    viewModel.startGame()
    while viewModel.currentState != .end && loop < 1 {
        viewModel.updateGame(with: input)
        print("loop:", loop)
        loop += 1
    }
}
