//
//  TimeCell.swift
//  MemoryCardsGame
//
//  Created by Kristīne Kazakēviča on 06/04/2020.
//  Copyright © 2020 Kristīne Kazakēviča. All rights reserved.
//

import UIKit
import RxSwift

final class TimeCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    
    var bag = DisposeBag()

    func configure(viewModel: TimeCellVM) {
        viewModel.leftTimeStringTrigger
            .bind(to: timeLabel.rx.text)
            .disposed(by: bag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
}
