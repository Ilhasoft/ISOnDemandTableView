//
//  ISOnDemandTableView.swift
//  ISOnDemandTableView
//
//  Created by Yves Bastos on 05/11/2017.
//  Copyright © 2017 Ilhasoft. All rights reserved.
//

import UIKit

class ISOnDemandTableView: UITableView {
    var onDemandDelegate: ISOnDemandTableViewDelegate?
    var interactor: ISOnDemandTableViewInteractor! {
        didSet {
            interactor?.delegate = self
        }
    }
    var isLoadingContent = false
    
    //MARK: Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        initialize()
    }
    
    fileprivate func initialize() {
        if #available(iOS 10.0, *) {
            refreshControl = UIRefreshControl()
            refreshControl?.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        } 
        self.dataSource = self
        self.delegate = self
    }
    
    //MARK: Class Methods
    @objc fileprivate func onPullToRefresh() {
        onDemandDelegate?.onDemandWasPulled(toRefresh: self)
        interactor?.refreshAllContent()
    }
    
    /**
     Loads the contents in the on demand tableView.
     */
    func loadContent() {
        guard let _ = onDemandDelegate, let interactor = interactor else {
            fatalError("You must set both ISOnDemandColectionViewDelegate and ISOnDemandCollectionViewInteractor before calling loadContent")
        }
        
        if !interactor.isFetching {
            interactor.loadItems()
            setFooterSpinner(to: true)//interactor.hasMoreItems)
        }
    }
    
    //MARK: Util
    func setFooterSpinner(to show: Bool) {
        //TODO:
    }
}

extension ISOnDemandTableView: ISOnDemandTableViewInteractorDelegate {
    func onObjectsFetched(_ objects: [Any]?, _ error: Error?) {
        self.setFooterSpinner(to: false)
        if #available(iOS 10.0, *) {
            self.refreshControl?.endRefreshing()
        }
        
        self.onDemandDelegate?.onDemandTableView(self, onContentLoad: objects, withError: error)
        
        if error == nil {
            self.reloadData()
        }
    }
}

extension ISOnDemandTableView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = onDemandDelegate?.onDemandTableView(self, reuseIdentifierForCellAt: indexPath) ?? ""
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        (cell as? ISOnDemandTableViewCell)?.setup(with: interactor.objects[indexPath.row], at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return onDemandDelegate?.onDemandTableView(self, heightForRowAt: indexPath) ?? UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onDemandDelegate?.onDemandTableView(self, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        onDemandDelegate?.onDemandTableView(self, cell: cell, willAppearAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        onDemandDelegate?.onDemandTableView(self, cell: cell, willDisappearAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return onDemandDelegate?.onDemandTableView(self, heightForHeaderAtSection: section) ?? UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return onDemandDelegate?.onDemandTableView(self, viewForHeaderAtSection: section)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onDemandDelegate?.onDemandTableViewDidScroll(self)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentYOffset = self.contentOffset.y + self.frame.size.height
        if contentYOffset >= self.contentSize.height {
            NSLog("Reached end of tableview")
            setFooterSpinner(to: true)
            loadContent()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else {return}
      
        let contentYOffset = self.contentOffset.y + self.frame.size.height
        if contentYOffset >= self.contentSize.height {
            NSLog("Reached end of tableview")
            setFooterSpinner(to: true)
            loadContent()
        }
    }
}

