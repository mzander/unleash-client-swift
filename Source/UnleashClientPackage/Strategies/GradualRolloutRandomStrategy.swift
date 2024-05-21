//
//  GradualRolloutRandomStrategy.swift
//  UnleashClient
//
//  Created by Maximilian Fischer on 21.05.24.
//

import Foundation

public class GradualRolloutRandomStrategy : Strategy {
    private let randomSeed = 100
    private let randomSeedIncrement = 1

    public init() {}

    public var name: String {
        return "gradualRolloutRandom"
    }

    private let strategyUtils = StrategyUtils()


    public func isEnabled(parameters: [String : String]) -> Bool {
        let percentage = strategyUtils.getPercentage(parameters["percentage"])
        let randomNumber = Int.random(in: 0..<randomSeed)
        return randomNumber <= percentage
    }
}
