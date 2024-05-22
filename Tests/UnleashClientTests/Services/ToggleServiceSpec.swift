//
//  ToggleServiceSpec.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import Nimble
import OHHTTPStubs
import OHHTTPStubsSwift
import PromiseKit
import Quick

@testable import UnleashClient

class ToggleServiceSpec: QuickSpec {
    override func spec() {
        let appName = "test app"
        let instanceId = "123"
        var service: ToggleService {
            return ToggleService(appName: appName, instanceId: instanceId)
        }
        var urlRequest: URLRequest?

        afterEach {
            HTTPStubs.removeAllStubs()
        }

        describe("#fetchToggles") {
            let url = "https://test.com/"
            let featureUrl = "\(url)client/features"
            let toggles: Toggles = TogglesBuilder().build()

            beforeEach {
                let encoder = JSONEncoder()
                let json = try? encoder.encode(toggles)
                stub(condition: { $0.url!.absoluteString == featureUrl }, response: { request in
                    urlRequest = request
                    return HTTPStubsResponse(data: json!, statusCode: 200, headers: nil)
                })
            }

            it("sends app headers") {
                // Act
                waitUntil { done in
                    service.fetchToggles(url: URL(string: url)!)
                        .done { _ in
                            done()
                        }.catch { _ in
                            fail()
                        }
                }

                // Assert
                if let result = urlRequest {
                    expect(hasHeaderNamed("UNLEASH-APPNAME", value: appName)(result)).to(beTrue())
                    expect(hasHeaderNamed("UNLEASH-INSTANCEID", value: instanceId)(result)).to(beTrue())
                    expect(hasHeaderNamed("User-Agent", value: appName)(result)).to(beTrue())
                } else {
                    fail()
                }
            }

            it("returns toggles") {
                // Act / Assert
                waitUntil { done in
                    service.fetchToggles(url: URL(string: url)!)
                        .done { response in
                            expect(response.version).to(equal(toggles.version))
                            expect(response.features.count).to(equal(toggles.features.count))
                            done()
                        }.catch { _ in
                            fail()
                        }
                }
            }
        }
    }
}
