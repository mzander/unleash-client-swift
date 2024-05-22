//
//  ToggleRespositoryMock.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import PromiseKit
@testable import UnleashClient

class ToggleRepositoryMock: ToggleRepositoryProtocol {
    var toggles: Toggles?

    init(toggles: Toggles?) {
        self.toggles = toggles
    }

    func get(url _: URL) -> Promise<Toggles> {
        if let toggles = toggles {
            return Promise.value(toggles)
        }
        return Promise(error: TestError.error)
    }
}
