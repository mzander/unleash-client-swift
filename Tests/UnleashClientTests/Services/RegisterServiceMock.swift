//
//  RegisterServiceMock.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import PromiseKit
@testable import UnleashClient

class RegisterServiceMock: RegisterServiceProtocol {
    private let promise: Promise<[String: Any]?>

    var body: ClientRegistration?

    init(promise: Promise<[String: Any]?>) {
        self.promise = promise
    }

    func register(url _: URL, body: ClientRegistration) -> Promise<[String: Any]?> {
        self.body = body
        return promise
    }
}
