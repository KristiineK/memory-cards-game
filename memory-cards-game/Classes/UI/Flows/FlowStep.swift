//
//  FlowStep.swift
//  MemoryCardsGame
//
//  Created by Kristīne Kazakēviča on 06/04/2020.
//  Copyright © 2020 Kristīne Kazakēviča. All rights reserved.
//

import Foundation
import RxFlow

enum FlowStep: Step {
    case menu
    case memoryCardsGame(DifficultyType)
    case results([GameRoundDO])
}
