//
//  MenuVC.swift
//  MemoryCardsGame
//
//  Created by Kristīne Kazakēviča on 06/04/2020.
//  Copyright © 2020 Kristīne Kazakēviča. All rights reserved.
//

import UIKit
import RxSwift
import Reusable

final class MenuVC: UIViewController, StoryboardBased {
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var levelView: UIView!

    var viewModel: MenuVM!

    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        addButtons()
        levelView.addShadow(
            color: UIColor.blue1B2330.withAlphaComponent(0.12),
            shadowOpacity: 1,
            shadowOffset: CGSize(width: 0, height: 24),
            shadowRadius: 32)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addBackgroundGradient()
    }

    private func addButtons() {
        DifficultyType.allCases.forEach { type in
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 10
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            button.setTitle(type.title, for: .normal)
            button.backgroundColor = type.buttonBackgroundColor
            button.tintColor = type.buttonTextColor
            button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
            buttonStackView.addArrangedSubview(button)
            button.rx.tap
                .map { FlowStep.memoryCardsGame(type) }
                .bind(to: viewModel.steps)
                .disposed(by: bag)
        }
    }
}
