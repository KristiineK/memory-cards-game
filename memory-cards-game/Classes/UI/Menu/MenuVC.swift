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

    var viewModel: MenuVM!

    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        addButtons()
    }

    private func addButtons() {
        DifficultyType.allCases.forEach { type in
            let button = UIButton(type: .system)
            button.setTitle(type.title, for: .normal)
            button.backgroundColor = .systemGreen
            button.tintColor = .white
            button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
            buttonStackView.addArrangedSubview(button)
            button.rx.tap
                .map { FlowStep.memoryCardsGame(type) }
                .bind(to: viewModel.steps)
                .disposed(by: bag)
        }
    }
}
