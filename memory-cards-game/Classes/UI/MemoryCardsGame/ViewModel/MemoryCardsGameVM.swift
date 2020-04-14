//
//  MemoryCardsGameVM.swift
//  MemoryCardsGame
//
//  Created by Kristīne Kazakēviča on 03/04/2020.
//  Copyright © 2020 Kristīne Kazakēviča. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt
import RxFlow

enum SectionType: String, CaseIterable {
    case time = "TimeCell"
    case cards = "CardCell"
    case info = "GameInfoCell"
}

protocol PMemoryCardsGameVM: Stepper {
    var kSpacingForCells: CGFloat { get }
    var cardsVM: BehaviorRelay<[CardCellVM]> { get }
    var timeVM: TimeCellVM { get }
    var infoVM: GameInfoCellVM { get }
    var difficultyType: BehaviorRelay<DifficultyType> { get }
    var flipCardTrigger: PublishRelay<IndexPath> { get }
    var beginTimerTrigger: PublishRelay<Void> { get }
}

final class MemoryCardsGameVM: PMemoryCardsGameVM {
    let steps = PublishRelay<Step>()

    let kSpacingForCells: CGFloat = 10
    private let kDelay = 1
    private let kTimeInSeconds = BehaviorRelay<Int>(value: 120)

    let cardsVM = BehaviorRelay<[CardCellVM]>(value: [])
    let timeVM = TimeCellVM()
    let infoVM = GameInfoCellVM()
    let flipCardTrigger = PublishRelay<IndexPath>()
    let beginTimerTrigger = PublishRelay<Void>()
    let difficultyType: BehaviorRelay<DifficultyType>
    
    private let foundIdenticalCards = BehaviorRelay<[CardCellVM]>(value: [])
    private let firstFlippedCard = BehaviorRelay<IndexPath?>(value: nil)
    private let secondFlippedCard = BehaviorRelay<IndexPath?>(value: nil)
    private let timeLeft = BehaviorRelay<Int?>(value: nil)
    private let movesCount = BehaviorRelay<Int>(value: 0)
    private let rounds = BehaviorRelay<[GameRoundDO]>(value: [])
    
    private let bag = DisposeBag()

    init(difficultyType: DifficultyType) {
        self.difficultyType = BehaviorRelay<DifficultyType>(value: difficultyType)
        cardsVM.accept(prepareCards())
        addHandlers()
    }

    private func addHandlers() {
        let sharedFlipCardTrigger = flipCardTrigger
            .withLatestFrom(Observable.combineLatest(cardsVM, timeLeft)) { (indexPath: $0, items: $1.0, time: $1.1) }
            .filter { !$0.items[$0.indexPath.row].pairFound.value && $0.time != 0 }
            .map { $0.indexPath }
            .share(replay: 1)

        sharedFlipCardTrigger
            .withLatestFrom(firstFlippedCard) { (newFlippedCard: $0, firstFlippedCard: $1) }
            .filter { $0.firstFlippedCard == nil }
            .map { $0.newFlippedCard }
            .bind(to: firstFlippedCard)
            .disposed(by: bag)

        sharedFlipCardTrigger
            .withLatestFrom(Observable.combineLatest(firstFlippedCard.unwrap(), secondFlippedCard)) { (newFlippedCard: $0, firstFlippedCard: $1.0, secondFlippedCard: $1.1) }
            .filter { $0.newFlippedCard != $0.firstFlippedCard && $0.secondFlippedCard == nil }
            .map { $0.newFlippedCard }
            .bind(to: secondFlippedCard)
            .disposed(by: bag)

        firstFlippedCard
            .unwrap()
            .withLatestFrom(cardsVM) { (indexPath: $0, items: $1) }
            .map { $0.items[$0.indexPath.row] }
            .subscribe(onNext: { $0.flipCard.accept(true) })
            .disposed(by: bag)

        secondFlippedCard
            .unwrap()
            .withLatestFrom(cardsVM) { (indexPath: $0, items: $1) }
            .map { $0.items[$0.indexPath.row] }
            .do(onNext: { $0.flipCard.accept(true) })
            .delay(.seconds(kDelay), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(firstFlippedCard.unwrap(), cardsVM)) { (firstFlippedCard: $1.1[$1.0.row], secondFlippedCard: $0) }
            .subscribe(onNext: { [weak self] in self?.compareCards(firstFlippedCard: $0.firstFlippedCard, secondFlippedCard: $0.secondFlippedCard) })
            .disposed(by: bag)

        let kTimeInSeconds = self.kTimeInSeconds
        beginTimerTrigger
            .flatMapLatest {
                Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                    .withLatestFrom(kTimeInSeconds) { (seconds: $0, maxSeconds: $1) }
                .map { $0.maxSeconds - $0.seconds }
                .takeWhile { $0 >= 0 }
            }
            .bind(to: timeLeft)
            .disposed(by: bag)

        let sharedTimeLeft = timeLeft.unwrap().share(replay: 1)

        sharedTimeLeft
            .map { TimeUtils.timeLeftString(seconds: $0) }
            .unwrap()
            .bind(to: timeVM.leftTimeStringTrigger)
            .disposed(by: bag)

        let sharedTimeIsUp = sharedTimeLeft.filter { $0 == 0 }.share(replay: 1)

        sharedTimeIsUp
            .withLatestFrom(Observable.combineLatest(kTimeInSeconds, rounds, movesCount,foundIdenticalCards, cardsVM))
            .map {
                let otherRoundsTime = $0.1.map { $0.spentTimeInSeconds }.reduce(0, +)
                let spentTimeInSeconds = $0.0 - otherRoundsTime
                let gameRound = GameRoundDO(spentTimeInSeconds: spentTimeInSeconds, movesCount: $0.2, isFinished: $0.3.count == $0.4.count, pairsFoundCount: $0.3.count / 2)
                var rounds = $0.1
                rounds.append(gameRound)
                return rounds
            }
            .bind(to: rounds)
            .disposed(by: bag)

        sharedTimeIsUp
            .withLatestFrom(rounds)
            .map { FlowStep.results($0) }
            .bind(to: steps)
            .disposed(by: bag)

        let sharedAllCardsOpened = foundIdenticalCards
                                        .withLatestFrom(cardsVM) { ($0, $1) }
                                        .filter { $0.0.count == $0.1.count }
                                        .map { $0.0 }
                                        .delay(.seconds(kDelay), scheduler: MainScheduler.instance)
                                        .share(replay: 1)

        sharedAllCardsOpened
            .withLatestFrom(Observable.combineLatest(kTimeInSeconds, timeLeft.unwrap(), rounds, movesCount))
            { (foundIdenticalCards: $0, time: $1.0, timeLeft: $1.1, rounds: $1.2, movesCount: $1.3) }
            .filter { $0.timeLeft != 0 }
            .map {
                let otherRoundsTime = $0.rounds.map { $0.spentTimeInSeconds }.reduce(0, +)
                let spentTimeInSeconds = $0.time - $0.timeLeft - otherRoundsTime
                let gameRound = GameRoundDO(spentTimeInSeconds: spentTimeInSeconds, movesCount: $0.movesCount, isFinished: true, pairsFoundCount: $0.foundIdenticalCards.count / 2)
                var rounds = $0.rounds
                rounds.append(gameRound)
                return rounds
            }
            .bind(to: rounds)
            .disposed(by: bag)


        sharedAllCardsOpened
            .map { [weak self] _ in self?.prepareCards() }
            .unwrap()
            .bind(to: cardsVM)
            .disposed(by: bag)

        sharedAllCardsOpened
            .map { _ in 0 }
            .bind(to: movesCount)
            .disposed(by: bag)

        sharedAllCardsOpened
            .observeOn(MainScheduler.asyncInstance)
            .map { _ in [] }
            .bind(to: foundIdenticalCards)
            .disposed(by: bag)

        rounds
            .map { $0.count + 1 }
            .bind(to: infoVM.round)
            .disposed(by: bag)

        movesCount.bind(to: infoVM.moves).disposed(by: bag)
    }

    private func compareCards(firstFlippedCard: CardCellVM, secondFlippedCard: CardCellVM) {
        movesCount.accept(movesCount.value + 1)
        
        if firstFlippedCard == secondFlippedCard {
            firstFlippedCard.pairFound.accept(true)
            secondFlippedCard.pairFound.accept(true)
            foundIdenticalCards.accept(foundIdenticalCards.value + [firstFlippedCard, secondFlippedCard])
        } else {
            firstFlippedCard.flipCard.accept(false)
            secondFlippedCard.flipCard.accept(false)
        }

        self.firstFlippedCard.accept(nil)
        self.secondFlippedCard.accept(nil)
    }

    private func prepareCards() -> [CardCellVM] {
        let cards = CardImage.allCases.prefix(difficultyType.value.cardsCount / 2)
        let viewModels = cards.map { CardCellVM(cardImage: $0) } + cards.map { CardCellVM(cardImage: $0) }
        return viewModels.shuffled()
    }
}
