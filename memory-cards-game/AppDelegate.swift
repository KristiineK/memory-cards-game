//
//  AppDelegate.swift
//  memory-cards-game
//
//  Created by Kristīne Kazakēviča on 14/04/2020.
//  Copyright © 2020 Kristīne Kazakēviča. All rights reserved.
//

import UIKit
import RxFlow

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var coordinator = FlowCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)

        let appFlow = AppFlow(withWindow: window)
        coordinator.coordinate(flow: appFlow, with: OneStepper(withSingleStep: FlowStep.menu))

        return true
    }
}

