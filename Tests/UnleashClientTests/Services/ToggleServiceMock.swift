//
//  ToggleServiceMock.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//
import Foundation
import PromiseKit
@testable import UnleashClient

class ToggleServiceMock: ToggleServiceProtocol {
    private let promise: Promise<Toggles>

    init(promise: Promise<Toggles>) {
        self.promise = promise
    }

    func fetchToggles(url _: URL) -> Promise<Toggles> {
        return promise
    }
}
