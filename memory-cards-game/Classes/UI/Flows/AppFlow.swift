//
//  FlowSteps.swift
//  MemoryCardsGame
//
//  Created by Kristīne Kazakēviča on 06/04/2020.
//  Copyright © 2020 Kristīne Kazakēviča. All rights reserved.
//

import Foundation
import RxFlow

final class AppFlow: Flow {

    var root: Presentable {
        return self.rootWindow
    }

    private let rootWindow: UIWindow

    init(withWindow window: UIWindow) {
        self.rootWindow = window
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FlowStep else { return .none }

        switch step {
        case .menu:
            return navigateToMenu()
        case .memoryCardsGame(let difficulty):
            return navigateToMemoryCardsGame(difficultyType: difficulty)
        case .results(let rounds):
            return navigateToResults(rounds: rounds)
        }
    }

    private func navigateToMenu() -> FlowContributors {
        let vc = MenuVC.instantiate()
        vc.viewModel = MenuVM()
        let nc = UINavigationController(rootViewController: vc)
        nc.clear()
        rootWindow.rootViewController = nc
        rootWindow.makeKeyAndVisible()
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }

    private func navigateToMemoryCardsGame(difficultyType: DifficultyType) -> FlowContributors {
        let vc = MemoryCardsGameVC.instantiate()
        vc.viewModel = MemoryCardsGameVM(difficultyType: difficultyType)
        (rootWindow.rootViewController as? UINavigationController)?.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }

    private func navigateToResults(rounds: [GameRoundDO]) -> FlowContributors {
        (rootWindow.rootViewController as? UINavigationController)?.popViewController(animated: true)
        let vc = ResultsVC.instantiate()
        vc.viewModel = ResultsVM(rounds: rounds)
        (rootWindow.rootViewController as? UINavigationController)?.present(vc, animated: true, completion: nil)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
}
