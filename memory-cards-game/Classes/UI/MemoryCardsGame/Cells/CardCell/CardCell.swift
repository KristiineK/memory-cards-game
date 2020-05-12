//
//  CardCell.swift
//  MemoryCardsGame
//
//  Created by Kristīne Kazakēviča on 03/04/2020.
//  Copyright © 2020 Kristīne Kazakēviča. All rights reserved.
//

import UIKit
import RxSwift
import RxAnimated
import RxCocoa

final class CardCell: UICollectionViewCell {
    @IBOutlet weak var cardImageView: UIImageView!

    private var viewModel: CardCellVM?

    private var bag = DisposeBag()

    func configure(viewModel: CardCellVM) {
        self.viewModel = viewModel

        addHandlers()
    }

    private func addHandlers() {
        guard let viewModel = viewModel else { return }

        let sharedFlipCard = viewModel.flipCard.share(replay: 1)

        sharedFlipCard
            .filter { $0 }
            .map { _ in viewModel.cardImage.image }
            .bind(animated: cardImageView.rx.animated.flip(.right, duration: 0.5).image)
            .disposed(by: bag)

        sharedFlipCard
            .filter { $0 }
            .map { _ in UIColor.white }
            .bind(animated: cardImageView.rx.animated.flip(.left, duration: 0.5).backgroundColor)
            .disposed(by: bag)

        sharedFlipCard
            .take(1)
            .filter { !$0 }
            .map { _ in UIImage(named: "closed_card") }
            .bind(to: cardImageView.rx.image)
            .disposed(by: bag)

        sharedFlipCard
            .skip(1)
            .filter { !$0 }
            .map { _ in UIImage(named: "closed_card") }
            .bind(animated: cardImageView.rx.animated.flip(.left, duration: 0.5).image)
            .disposed(by: bag)

        sharedFlipCard
            .take(1)
            .filter { !$0 }
            .map { _ in UIColor.blueDAF1FF }
            .bind(to: cardImageView.rx.backgroundColor)
            .disposed(by: bag)

        sharedFlipCard
            .skip(1)
            .filter { !$0 }
            .map { _ in UIColor.blueDAF1FF }
            .bind(animated: cardImageView.rx.animated.flip(.left, duration: 0.5).backgroundColor)
            .disposed(by: bag)

        viewModel.pairFound
            .filter { $0 }
            .map { _ in true }
            .bind(animated: cardImageView.rx.animated.fade(duration: 0.5).isHidden)
            .disposed(by: bag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
        cardImageView.image = nil
        cardImageView.isHidden = false
    }
}
