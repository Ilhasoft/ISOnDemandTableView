//
//  SimpleTableViewCell.swift
//  ISOnDemandTableView
//
//  Created by Dielson Sales on 07/01/17.
//  Copyright © 2017 Ilhasoft. All rights reserved.
//

import UIKit

class SimpleTableViewCell: UITableViewCell, ISOnDemandTableViewCell {

    @IBOutlet var lbText: UILabel!

    func setup(with object: Any, at indexPath: IndexPath) {
        guard let text = object as? String else { return }
        lbText.text = text
    }
}
