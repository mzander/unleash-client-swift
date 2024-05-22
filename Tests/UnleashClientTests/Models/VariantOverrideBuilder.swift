//
//  VariantOverrideBuilder.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//
import Foundation
@testable import UnleashClient

class VariantOverrideBuilder {
    func build() -> VariantOverride {
        return VariantOverride(contextName: "userId", values: ["123"])
    }
}
