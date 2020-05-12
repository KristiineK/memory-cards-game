//
//  ResultCell.swift
//  MemoryCardsGame
//
//  Created by Kristīne Kazakēviča on 07/04/2020.
//  Copyright © 2020 Kristīne Kazakēviča. All rights reserved.
//

import UIKit

final class ResultCell: UITableViewCell {

    @IBOutlet weak var roundNameLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var pairsFoundLabel: UILabel!

    func configure(round: GameRoundDO, number: Int) {
        roundNameLabel.text = "Round \(number)"
        secondsLabel.text = "\(round.spentTimeInSeconds)s"
        movesLabel.text = "\(round.movesCount) moves"
        pairsFoundLabel.text = "\(round.pairsFoundCount) found"
        statusLabel.text = round.isFinished ? "Finished" : "Unfinished"
    }
}
