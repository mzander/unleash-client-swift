//
//  DefaultStrategy.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation

class DefaultStrategy: Strategy {
    var name: String {
        return "default"
    }

    func isEnabled(parameters _: [String: String]) -> Bool {
        return true
    }
}
