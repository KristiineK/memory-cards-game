//
//  CardCellVM.swift
//  MemoryCardsGame
//
//  Created by Kristīne Kazakēviča on 03/04/2020.
//  Copyright © 2020 Kristīne Kazakēviča. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum CardImage: String, CaseIterable {
    case alexanderNevskyCathedralBlack = "alexander_nevsky_cathedral_1"
    case alexanderNevskyCathedralYellow = "alexander_nevsky_cathedral_2"
    case burjAlArab = "burj_al_arab"
    case christTheRedeemer = "christ_the_redeemer"
    case colosseum
    case egyptianPyramids = "egyptian_pyramids"
    case eiffelTower = "eiffel_tower"
    case goldenGate = "golden_gate"
    case londonBridge = "london_bridge"
    case osaka
    case petronasTowers = "petronas_towers"
    case sydneyOperaHouse = "sydney_opera_house"
    case spaceNeedle = "space_needle"
    case statueOfLiberty = "statue_of_liberty"
    case toriiGate = "torii_gate"
    case vilniusGediminas = "vilnius_gediminas"

    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}

final class CardCellVM: Equatable {
    let cardImage: CardImage
    let flipCard = BehaviorRelay<Bool>(value: false)
    let pairFound = BehaviorRelay<Bool>(value: false)

    let bag = DisposeBag()

    init(cardImage: CardImage) {
        self.cardImage = cardImage
    }

    static func == (lhs: CardCellVM, rhs: CardCellVM) -> Bool {
        return lhs.cardImage == rhs.cardImage
    }
}
