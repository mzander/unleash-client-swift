//
//  Unleash.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import PromiseKit

// MARK: - UnleashError

public enum UnleashError: Error {
    case noURLProvided
    case maxRetriesReached
}

// MARK: - Strategy

public protocol Strategy {
    var name: String { get }
    func isEnabled(parameters: [String: String]) -> Bool
}

public protocol UnleashDelegate {
    func unleashDidLoad(_ unleash: Unleash)
    func unleashDidFail(_ unleash: Unleash, withError error: Error)
}

// MARK: - Unleash

public class Unleash {
    // MARK: - Properties


    private var toggleRepository: ToggleRepositoryProtocol
    private var toggles: Toggles? { return toggleRepository.toggles }
    private var scheduler: Scheduler

    public private(set) var appName: String
    public private(set) var url: String
    public private(set) var refreshInterval: TimeInterval
    public private(set) var strategies: [Strategy]
    public var delegate: UnleashDelegate?

    // MARK: - Lifecycle - Public Init

    public convenience init(
        appName: String,
        url: String,
        refreshInterval: TimeInterval = 3600,
        strategies: [Strategy] = [],
        delegate: UnleashDelegate? = nil
    ) {
        let memory = MemoryCache(cache: Cache(), jsonDecoder: JSONDecoder(), jsonEncoder: JSONEncoder())
        let toggleService: ToggleServiceProtocol = ToggleService(appName: appName)
        let toggleRepository = ToggleRepository(memory: memory, toggleService: toggleService)
        let allStrategies: [Strategy] = [DefaultStrategy()] + strategies

        self.init(
            toggleRepository: toggleRepository,
            appName: appName,
            url: url,
            refreshInterval: refreshInterval,
            strategies: allStrategies,
            delegate: delegate
        )
    }

    // MARK: - Internal Init

    init(
        toggleRepository: ToggleRepositoryProtocol,
        appName: String,
        url: String,
        refreshInterval: TimeInterval,
        strategies: [Strategy],
        scheduler: Scheduler? = nil,
        delegate: UnleashDelegate? = nil
    ) {
        self.toggleRepository = toggleRepository
        self.appName = appName
        self.url = url
        self.refreshInterval = refreshInterval
        self.strategies = strategies
        self.delegate = delegate

        if let scheduler = scheduler {
            self.scheduler = scheduler
        } else {
            self.scheduler = UnleashScheduler.every(interval: Defaults.defaultRetryInterval)
        }
        self.scheduler.delegate = self

        start()
    }

    // MARK: Start

    private func start() {
        self.scheduler.do {
            _ = self.fetchToggles()
                .done { self.delegate?.unleashDidLoad(self) }
                .catch { self.delegate?.unleashDidFail(self, withError: $0) }
        }
        self.scheduler.resume()
    }

    // MARK: Fetch Toggles

    private func fetchToggles(completion: @escaping (Error?) -> Void) {
        guard
            let url = URL(string: url)
        else { return completion(UnleashError.noURLProvided) }

        _ = toggleRepository.get(url: url)
            .tap { result in
                switch result {
                case .success:
                    completion(nil)
                case let .failure(error):
                    completion(error)
                }
            }
    }

    @discardableResult
    private func fetchToggles() -> Promise<Void> {
        return Promise { resolver in
            self.fetchToggles { error in resolver.resolve(error) }
        }
    }

    // MARK: Is Enabled

    public func isEnabled(name: String) -> Bool {
        return isEnabled(name: name, defaultSetting: false)
    }

    public func isEnabled(name: String, defaultSetting: Bool) -> Bool {
        return isEnabled(name: name) { _ in defaultSetting }
    }

    private func isEnabled(name: String, fallbackAction: (String) -> Bool) -> Bool {
        return checkEnabled(name: name, fallbackAction: fallbackAction)
    }

    private func checkEnabled(name: String, fallbackAction: (String) -> Bool ) -> Bool {
        guard
            let feature = toggles?.features.first(where: { $0.name == name }),
            feature.enabled
        else {
            return fallbackAction(name)
        }

        for strategy in feature.strategies {
            guard
                let targetStrategy = strategies.first(where: { $0.name == strategy.name }),
                let parameters = strategy.parameters
            else { continue }

            if targetStrategy.isEnabled(parameters: parameters) {
                return true
            }
        }
        return false
    }
}

// MARK: - Scheduler Delegate

extension Unleash: SchedulerDelegate {
    func schedulerDidFail(_: Scheduler, withError error: Error) {
        delegate?.unleashDidFail(self, withError: error)
    }
}
