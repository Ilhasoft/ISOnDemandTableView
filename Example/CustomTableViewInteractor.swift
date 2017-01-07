//
//  CustomTableViewInteractor.swift
//  ISOnDemandTableView
//
//  Created by Dielson Sales on 07/01/17.
//  Copyright © 2017 Ilhasoft. All rights reserved.
//

import UIKit

class CustomTableViewInteractor: ISOnDemandTableViewInteractor {
    override init() {
        super.init(paginationCount: 20)
    }

    override func fetchObjects(forPage page: UInt, with handler: (([Any]?, Error?) -> Void)!) {
        var objectsList: [Any] = []
        let lowerBound = page * paginationCount
        let upperBound = (page + 1) * paginationCount
        for index in lowerBound..<upperBound {
            if index > 100 {
                break
            }
            objectsList.append("\(index)")
        }
        handler(objectsList, nil)
    }
}
