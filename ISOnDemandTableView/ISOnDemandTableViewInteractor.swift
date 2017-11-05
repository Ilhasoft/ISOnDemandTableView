//
//  ISOnDemandTableViewInteractor.swift
//  ISOnDemandTableView
//
//  Created by Yves Bastos on 05/11/2017.
//  Copyright © 2017 Ilhasoft. All rights reserved.
//

import Foundation

protocol ISOnDemandTableViewInteractorDelegate {
    func onObjectsFetched(_ objects: [AnyObject]?, _ error: Error?)
}

class ISOnDemandTableViewInteractor {
    var delegate: ISOnDemandTableViewInteractorDelegate?
    var objects = [AnyObject]()
    var currentPage = 0
    var pagination: Int = 10
    var isFetching = false
    
    fileprivate(set) public var hasMoreItems = false
    
    init(pagination: Int) {
        self.pagination = pagination
    }
    
    func loadItems() {
        if isFetching {
            NSLog("Still fetching items, wait...")
            return
        }
        
        if !hasMoreItems {
            NSLog("All items were already fetched!")
            return
        }
        
        fetchObjects(forPage: currentPage) {
            (objects, error) in
            self.objects.append(contentsOf: objects ?? [])
            self.delegate?.onObjectsFetched(objects, error)
        }
    }
    
    /**
     * Override this method to return the new objects fetched every time a new page is loaded
     */
    open func fetchObjects(forPage page: Int, _ completion: @escaping (_ result: [AnyObject]?, _ error: Error?) -> ()) { }
    
    func onObjectsLoaded(lastObjects: [AnyObject]) {
        isFetching = false
        if lastObjects.count < pagination {
            hasMoreItems = false
        } else {
            currentPage += 1
        }
    }
    
    func refreshAllContent() {
        guard !isFetching else {
            NSLog("Still fetching items, wait...")
            return
        }
        
        currentPage = 0
        hasMoreItems = true
        objects = []
        
        fetchObjects(forPage: currentPage) {
            (objects, error) in
            self.objects = objects ?? []
            self.onObjectsLoaded(lastObjects: self.objects)
            self.delegate?.onObjectsFetched(objects, error)
        }
    }
}
