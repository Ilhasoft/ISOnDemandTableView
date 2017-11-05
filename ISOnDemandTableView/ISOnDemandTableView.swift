//
//  ISOnDemandTableView.swift
//  ISOnDemandTableView
//
//  Created by Yves Bastos on 05/11/2017.
//  Copyright © 2017 Ilhasoft. All rights reserved.
//

import UIKit

public class ISOnDemandTableView: UITableView {
    public var onDemandDelegate: ISOnDemandTableViewDelegate?
    public var interactor: ISOnDemandTableViewInteractor! {
        didSet {
            interactor?.delegate = self
        }
    }
    public var isLoadingContent = false
    
    //MARK: Init
    required public init?(coder aDecoder: NSCoder) {
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
    public func loadContent() {
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
    public func onObjectsFetched(_ objects: [Any]?, _ error: Error?) {
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
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.objects.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = onDemandDelegate?.onDemandTableView(self, reuseIdentifierForCellAt: indexPath) ?? ""
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        (cell as? ISOnDemandTableViewCell)?.setup(with: interactor.objects[indexPath.row], at: indexPath)
        return cell
    }
    
   public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return onDemandDelegate?.onDemandTableView(self, heightForRowAt: indexPath) ?? UITableViewAutomaticDimension
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onDemandDelegate?.onDemandTableView(self, didSelectRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return onDemandDelegate?.onDemandTableView(self, heightForHeaderAtSection: section) ?? UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return onDemandDelegate?.onDemandTableView(self, viewForHeaderAtSection: section)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onDemandDelegate?.onDemandTableViewDidScroll(self)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentYOffset = self.contentOffset.y + self.frame.size.height
        if contentYOffset >= self.contentSize.height {
            NSLog("Reached end of tableview")
            setFooterSpinner(to: true)
            loadContent()
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else {return}
      
        let contentYOffset = self.contentOffset.y + self.frame.size.height
        if contentYOffset >= self.contentSize.height {
            NSLog("Reached end of tableview")
            setFooterSpinner(to: true)
            loadContent()
        }
    }
}

