//
//  GameInfoCellVM.swift
//  MemoryCardsGame
//
//  Created by Kristīne Kazakēviča on 06/04/2020.
//  Copyright © 2020 Kristīne Kazakēviča. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class GameInfoCellVM {
    let round = BehaviorRelay<Int>(value: 1)
    let moves = BehaviorRelay<Int>(value: 0)
}
