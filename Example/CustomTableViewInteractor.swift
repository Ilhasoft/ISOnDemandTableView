//
//  CustomTableViewInteractor.swift
//  ISOnDemandTableView
//
//  Created by Dielson Sales on 07/01/17.
//  Copyright © 2017 Ilhasoft. All rights reserved.
//

import UIKit

class CustomTableViewInteractor: ISOnDemandTableViewInteractor {
    init() {
        super.init(pagination: 20)
    }

    override func fetchObjects(forPage page: Int, _ completion: @escaping ([Any]?, Error?) -> ()) {
        var objectsList: [Any] = []
        let lowerBound = page * pagination
        let upperBound = (page + 1) * pagination
        for index in lowerBound..<upperBound {
            if index > 100 {
                break
            }
            objectsList.append("\(index)")
        }
        completion(objectsList, nil)
    }
}
