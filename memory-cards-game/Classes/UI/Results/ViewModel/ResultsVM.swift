//
//  ResultsVM.swift
//  MemoryCardsGame
//
//  Created by Kristīne Kazakēviča on 07/04/2020.
//  Copyright © 2020 Kristīne Kazakēviča. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow

final class ResultsVM: Stepper {
    let steps = PublishRelay<Step>()

    let rounds: [GameRoundDO]

    init(rounds: [GameRoundDO]) {
        self.rounds = rounds
    }
}
