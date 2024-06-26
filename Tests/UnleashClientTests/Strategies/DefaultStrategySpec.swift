//
//  DefaultStrategySpec.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import UnleashClient

class DefaultStrategySpec: QuickSpec {
    override func spec() {
        var strategy: DefaultStrategy {
            return DefaultStrategy()
        }

        describe("#init") {
            context("when default initializer") {
                it("returns default for name") {
                    // Act
                    let result = strategy.name

                    // Assert
                    expect(result).to(equal("default"))
                }

                it("returns true for is enabled") {
                    // Act
                    let result = strategy.isEnabled(parameters: [:])

                    // Assert
                    expect(result).to(beTrue())
                }
            }
        }
    }
}
