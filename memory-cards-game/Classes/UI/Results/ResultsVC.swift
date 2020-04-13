//
//  ResultsVC.swift
//  MemoryCardsGame
//
//  Created by Kristīne Kazakēviča on 07/04/2020.
//  Copyright © 2020 Kristīne Kazakēviča. All rights reserved.
//

import UIKit
import Reusable

final class ResultsVC: UIViewController, StoryboardBased {

    @IBOutlet weak var tableView: UITableView!

    var viewModel: ResultsVM!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "ResultCell", bundle: nil), forCellReuseIdentifier: "ResultCell")
    }
}

extension ResultsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rounds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        (cell as? ResultCell)?.configure(round: viewModel.rounds[indexPath.row], number: indexPath.row + 1)
        return cell
    }
}
