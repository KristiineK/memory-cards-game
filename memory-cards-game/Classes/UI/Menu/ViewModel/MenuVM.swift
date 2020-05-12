//
//  MenuVM.swift
//  MemoryCardsGame
//
//  Created by Kristīne Kazakēviča on 06/04/2020.
//  Copyright © 2020 Kristīne Kazakēviča. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxFlow

enum DifficultyType: CaseIterable {
    case easy
    case medium
    case hard

    var title: String {
        switch self {
        case .easy:
            return "Easy"
        case .medium:
            return "Medium"
        case .hard:
            return "Hard"
        }
    }

    var cardsGrid: (rowCount: Int, columnCount: Int) {
        switch self {
        case .easy:
            return (4,3)
        case .medium:
            return (6,4)
        case .hard:
            return (8,4)
        }
    }

    var cardsCount: Int {
        return cardsGrid.columnCount * cardsGrid.rowCount
    }

    var buttonBackgroundColor: UIColor {
        switch self {
        case .easy:
            return UIColor.greenEFF6F5
        case .medium:
            return UIColor.blueEDF4FD
        case .hard:
            return UIColor.redFEEBEC
        }
    }

    var buttonTextColor: UIColor {
        switch self {
        case .easy:
            return UIColor.green60A699
        case .medium:
            return UIColor.blue4A90E2
        case .hard:
            return UIColor.redF8343D
        }
    }
}

final class MenuVM: Stepper {
    let steps = PublishRelay<Step>()
}
