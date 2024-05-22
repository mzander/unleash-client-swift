//
//  StrategyUtils.swift
//  UnleashClient
//
//  Created by Maximilian Fischer on 21.05.24.
//

import Foundation
import MurmurHash_Swift

class StrategyUtils {
    /**
     * Takes two string inputs, concatenates them, produces a hash, and returns a normalized value between 0 and 100.
     *
     * - Parameters:
     *   - identifier: identifier id
     *   - groupId: group id
     * - Returns: normalized number
     */
    func getNormalizedNumber(identifier: String, groupId: String) -> Int {
        return getNormalizedNumber(identifier: identifier, groupId: groupId, normalizer: StrategyUtils.ONE_HUNDRED)
    }

    func getNormalizedNumber(identifier: String, groupId: String, normalizer: UInt32) -> Int {
        let value = "\(groupId):\(identifier)".data(using: .utf8)!
        let hash = MurmurHash3.x86_32.digest(value, seed: 0)
        return Int((hash % normalizer) + 1)
    }

    /**
     * Takes a numeric string value and converts it to an integer between 0 and 100.
     *
     * Returns 0 if the string is not numeric.
     *
     * - Parameter percentage: A numeric string value
     * - Returns: an integer between 0 and 100
     */
    func getPercentage(_ percentage: String?) -> Int {
        if let percentage = percentage, !percentage.isEmpty, percentage.allSatisfy({ $0.isNumber }) {
            return Int(percentage) ?? 0
        } else {
            return 0
        }
    }

    private static let ONE_HUNDRED: UInt32 = 100
}
