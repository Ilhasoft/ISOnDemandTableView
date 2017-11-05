//
//  ISOnDemandTableViewInteractor.swift
//  ISOnDemandTableView
//
//  Created by Yves Bastos on 05/11/2017.
//  Copyright © 2017 Ilhasoft. All rights reserved.
//

import Foundation

protocol ISOnDemandTableViewInteractorDelegate {
    func onObjectsFetched(_ objects: [Any]?, _ error: Error?)
}

class ISOnDemandTableViewInteractor {
    var delegate: ISOnDemandTableViewInteractorDelegate?
    var objects = [Any]()
    var currentPage = 0
    var pagination: Int = 10
    var isFetching = false
    
    fileprivate(set) public var hasMoreItems = true
    
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
            self.objects = self.objects + (objects ?? [])
            self.onObjectsLoaded(lastObjects: objects ?? [])
            self.delegate?.onObjectsFetched(objects, error)
        }
    }
    
    /**
     * Override this method to return the new objects fetched every time a new page is loaded
     */
    open func fetchObjects(forPage page: Int, _ completion: @escaping (_ result: [Any]?, _ error: Error?) -> ()) { }
    
    func onObjectsLoaded(lastObjects: [Any]) {
        isFetching = false
        currentPage += 1
        hasMoreItems = lastObjects.count >= pagination
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
