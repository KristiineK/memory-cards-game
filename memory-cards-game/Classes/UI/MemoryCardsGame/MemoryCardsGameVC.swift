//
//  MemoryCardsGameVC.swift
//  MemoryCardsGame
//
//  Created by Kristīne Kazakēviča on 03/04/2020.
//  Copyright © 2020 Kristīne Kazakēviča. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

final class MemoryCardsGameVC: UIViewController, StoryboardBased {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!

    var viewModel: PMemoryCardsGameVM!
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        stackView.spacing = UIScreen.main.bounds.width >= 375 ? 30 : 5
        infoView.addShadow(
            color: UIColor.blue1B2330.withAlphaComponent(0.12),
            shadowOpacity: 1,
            shadowOffset: CGSize(width: 0, height: 24),
            shadowRadius: 32)
        setupCollectionView()
        addHandlers()
        viewModel.beginTimerTrigger.accept(())
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addBackgroundGradient()
    }

    private func addHandlers() {
        viewModel.cardsVM
            .subscribe(onNext: { [weak self] _ in self?.collectionView.reloadData() })
            .disposed(by: bag)

        viewModel.round.bind(to: roundLabel.rx.text).disposed(by: bag)
        viewModel.leftTimeStringTrigger.bind(to: timeLabel.rx.text).disposed(by: bag)
        viewModel.score.bind(to: scoreLabel.rx.text).disposed(by: bag)

        viewModel
            .littleTimeLeftTrigger
            .subscribe(onNext: { [weak self] in self?.timeLabel.textColor = UIColor.redF8333C })
            .disposed(by: bag)

        backButton.rx.tap
            .subscribe(onNext: { [weak self] in self?.navigationController?.popViewController(animated: true) })
            .disposed(by: bag)
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: viewModel.kCardCell, bundle: nil), forCellWithReuseIdentifier: viewModel.kCardCell)

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = viewModel.kSpacingForCells
            layout.minimumLineSpacing = viewModel.kSpacingForCells
        }
    }
}

extension MemoryCardsGameVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.flipCardTrigger.accept(indexPath)
    }
}

extension MemoryCardsGameVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cardsVM.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.kCardCell, for: indexPath)
        (cell as? CardCell)?.configure(viewModel: viewModel.cardsVM.value[indexPath.row])
        return cell
    }
}

extension MemoryCardsGameVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalHorizontalSpacing = CGFloat(viewModel.difficultyType.value.cardsGrid.columnCount - 1) * viewModel.kSpacingForCells
        let totalVerticalSpacing = CGFloat(viewModel.difficultyType.value.cardsGrid.rowCount - 1) * viewModel.kSpacingForCells

        let width = ((collectionView.bounds.size.width - totalHorizontalSpacing) / CGFloat(viewModel.difficultyType.value.cardsGrid.columnCount)).rounded(.down)
        let height = ((collectionView.bounds.size.height - totalVerticalSpacing) / CGFloat(viewModel.difficultyType.value.cardsGrid.rowCount)).rounded(.down)

        return CGSize(width: width, height: height)
    }
}
