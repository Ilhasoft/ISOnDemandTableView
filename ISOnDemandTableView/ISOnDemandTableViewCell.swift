//
//  ISOnDemandTableViewCell.swift
//  ISOnDemandTableView
//
//  Created by Yves Bastos on 05/11/2017.
//  Copyright © 2017 Ilhasoft. All rights reserved.
//

import UIKit


public protocol ISOnDemandTableViewCell {
    func setup(with object: Any, at indexPath: IndexPath)
}
