//
//  ClientRegistrationBuilder.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
@testable import UnleashClient

class ClientRegistrationBuilder {
    func build() -> ClientRegistration {
        return ClientRegistration(appName: "Test app", strategies: [])
    }
}
