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
    case bird
    case cat
    case cow
    case dog
    case duckling
    case hedgehog
    case horse
    case sheep
    case squirrel
    case leopard
    case bear
    case deer
    case giraffe
    case gorilla
    case lion
    case zebra

    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}

final class CardCellVM: Equatable {
    let cardImage: BehaviorRelay<CardImage>
    let flipCard = BehaviorRelay<Bool>(value: false)
    let pairFound = BehaviorRelay<Bool>(value: false)

    let bag = DisposeBag()

    init(cardImage: CardImage) {
        self.cardImage = BehaviorRelay<CardImage>(value: cardImage)
    }

    static func == (lhs: CardCellVM, rhs: CardCellVM) -> Bool {
        return lhs.cardImage.value == rhs.cardImage.value
    }
}
