//
//  TogglesBuilder.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
@testable import UnleashClient

class TogglesBuilder {
    private var features: [Feature] = []

    func withFeature(feature: Feature) -> TogglesBuilder {
        features.append(feature)
        return self
    }

    func build() -> Toggles {
        if features.isEmpty {
            features.append(FeatureBuilder().build())
        }
        return Toggles(version: 10, features: features)
    }
}
