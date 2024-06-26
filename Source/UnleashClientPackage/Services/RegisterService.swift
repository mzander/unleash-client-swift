//
//  RegisterService.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import PromiseKit
#if canImport(PMKFoundation)
    import PMKFoundation
#endif

struct RegisterService: RegisterServiceProtocol {}

protocol RegisterServiceProtocol {
    func register(url: URL, body: ClientRegistration) -> Promise<[String: Any]?>
}

extension RegisterService {
    func register(url: URL, body: ClientRegistration) -> Promise<[String: Any]?> {
        let registerUrl = url.appendingPathComponent("client/register")

        return firstly {
            try URLSession.shared.dataTask(.promise, with: makeUrlRequest(url: registerUrl, body: body)).validate()
        }.map {
            // Unleash will return 200 and then 202 when already registered
            $0.data.isEmpty ? [:] : try JSONSerialization.jsonObject(with: $0.data) as? [String: Any]
        }
    }

    private func makeUrlRequest(url: URL, body: ClientRegistration) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONEncoder().encode(body)
        return request
    }
}
