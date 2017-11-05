//
//  ISOnDemandTableViewInteractor.swift
//  ISOnDemandTableView
//
//  Created by Yves Bastos on 05/11/2017.
//  Copyright © 2017 Ilhasoft. All rights reserved.
//

import Foundation

public protocol ISOnDemandTableViewInteractorDelegate {
    func onObjectsFetched(_ objects: [Any]?, _ error: Error?)
}

open class ISOnDemandTableViewInteractor {
    public var delegate: ISOnDemandTableViewInteractorDelegate?
    public var objects = [Any]()
    private(set) public var currentPage = 0
    private(set) public var pagination: Int = 10
    public var isFetching = false
    
    public var hasMoreItems = true
    
    public init(pagination: Int) {
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
    open func fetchObjects(forPage page: Int, _ handler: @escaping (_ result: [Any]?, _ error: Error?) -> ()) { }
    
    func onObjectsLoaded(lastObjects: [Any]) {
        isFetching = false
        currentPage += 1
        hasMoreItems = lastObjects.count >= pagination
    }
    
    public func refreshAllContent() {
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
