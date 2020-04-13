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

    var viewModel: PMemoryCardsGameVM!
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        addHandlers()
        viewModel.beginTimerTrigger.accept(())
    }

    private func addHandlers() {
        viewModel.cardsVM
            .subscribe(onNext: { [weak self] _ in self?.collectionView.reloadData() })
            .disposed(by: bag)
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: SectionType.cards.rawValue, bundle: nil), forCellWithReuseIdentifier: SectionType.cards.rawValue)
        collectionView.register(UINib(nibName: SectionType.time.rawValue, bundle: nil), forCellWithReuseIdentifier: SectionType.time.rawValue)
        collectionView.register(UINib(nibName: SectionType.info.rawValue, bundle: nil), forCellWithReuseIdentifier: SectionType.info.rawValue)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: viewModel.kSpacingForCells, bottom: 0, right: viewModel.kSpacingForCells)

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = viewModel.kSpacingForCells
            layout.minimumLineSpacing = viewModel.kSpacingForCells
        }
    }
}

extension MemoryCardsGameVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard SectionType.allCases[indexPath.section] == .cards else { return }
        viewModel.flipCardTrigger.accept(indexPath)
    }
}

extension MemoryCardsGameVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch SectionType.allCases[section] {
        case .time:
            return 1
        case .cards:
            return viewModel.cardsVM.value.count
        case .info:
            return 1
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionType.allCases[indexPath.section].rawValue, for: indexPath)
        switch SectionType.allCases[indexPath.section] {
        case .time:
            (cell as? TimeCell)?.configure(viewModel: viewModel.timeVM)
        case .cards:
            (cell as? CardCell)?.configure(viewModel: viewModel.cardsVM.value[indexPath.row])
        case .info:
            (cell as? GameInfoCell)?.configure(viewModel: viewModel.infoVM)
        }
        return cell
    }
}

extension MemoryCardsGameVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let oneColumnCellWidth = collectionView.bounds.width - 2 * viewModel.kSpacingForCells
        switch SectionType.allCases[indexPath.section] {
        case .time:
            return CGSize(width: oneColumnCellWidth, height: 50)
        case .cards:
            let totalSpacing = CGFloat(viewModel.difficultyType.value.cardsGrid.columnCount + 1) * viewModel.kSpacingForCells
            let width = ((collectionView.bounds.size.width - totalSpacing) / CGFloat(viewModel.difficultyType.value.cardsGrid.columnCount)).rounded(.down)
            return CGSize(width: width, height: width)
        case .info:
            return CGSize(width: oneColumnCellWidth, height: 50)
        }
    }
}
