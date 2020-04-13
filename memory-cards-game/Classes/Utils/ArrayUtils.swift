//
//  ArrayUtils.swift
//  MemoryCardsGame
//
//  Created by Kristīne Kazakēviča on 06/04/2020.
//  Copyright © 2020 Kristīne Kazakēviča. All rights reserved.
//

import Foundation

extension Array {
    mutating func shuffle() {
        self.forEach { _ in
            sort { _,_ in arc4random() < arc4random() }
        }
    }
}
