//
//  GameInfoCell.swift
//  MemoryCardsGame
//
//  Created by Kristīne Kazakēviča on 06/04/2020.
//  Copyright © 2020 Kristīne Kazakēviča. All rights reserved.
//

import UIKit
import RxSwift

final class GameInfoCell: UICollectionViewCell {
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!

    var bag = DisposeBag()

    func configure(viewModel: GameInfoCellVM) {
        viewModel.round.map { "Round: \($0)" }.bind(to: roundLabel.rx.text).disposed(by: bag)
        viewModel.moves.map { "Moves: \($0)" }.bind(to: movesLabel.rx.text).disposed(by: bag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
}
