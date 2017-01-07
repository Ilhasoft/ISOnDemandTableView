//
//  MainViewController.swift
//  ISOnDemandTableView
//
//  Created by Dielson Sales on 07/01/17.
//  Copyright © 2017 Ilhasoft. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var tableView: ISOnDemandTableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
    }

    private func setupTableView() {
        self.tableView.register(UINib(nibName: "SimpleTableViewCell", bundle: nil), forCellReuseIdentifier: "SimpleTableViewCell")
        self.tableView.onDemandTableViewDelegate = self
        self.tableView.interactor = CustomTableViewInteractor()
        self.tableView.loadContent()
        self.tableView.delegate = self.tableView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MainViewController: ISOnDemandTableViewDelegate {
    func reuseIdentifierForCell(at indexPath: IndexPath) -> String {
        return "SimpleTableViewCell"
    }

    func onContentLoadFinishedWithError(_ error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
}
