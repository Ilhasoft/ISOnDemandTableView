//
//  ISonDemandDelegate.swift
//  ISOnDemandTableView
//
//  Created by Yves Bastos on 05/11/2017.
//  Copyright © 2017 Ilhasoft. All rights reserved.
//

import UIKit

public protocol ISOnDemandTableViewDelegate {
    func onDemandTableView(_ tableView: ISOnDemandTableView, onContentLoad lastData: [Any]?, withError error: Error?)
    func onDemandTableView(_ tableView: ISOnDemandTableView, reuseIdentifierForCellAt indexPath: IndexPath) -> String

    
    func onDemandWasPulled(toRefresh: ISOnDemandTableView)
    func onDemandTableView(_ tableView: ISOnDemandTableView, setupCell cell: UITableViewCell, at indexPath: IndexPath)
    func onDemandTableView(_ tableView: ISOnDemandTableView, didSelectRowAt indexPath: IndexPath)
    func onDemandTableView(_ tableView: ISOnDemandTableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    func onDemandTableViewDidScroll(_ tableView: ISOnDemandTableView)
    func onDemandTableView(_ tableView: ISOnDemandTableView, heightForHeaderAtSection section: Int) -> CGFloat?
    func onDemandTableView(_ tableView: ISOnDemandTableView, viewForHeaderAtSection section: Int) -> UIView?
}

extension ISOnDemandTableViewDelegate {
    func onDemandWasPulled(toRefresh: ISOnDemandTableView) {}
    func onDemandTableView(_ tableView: ISOnDemandTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func onDemandTableView(_ tableView: ISOnDemandTableView, setupCell cell: UITableViewCell, at indexPath: IndexPath) {}
    func onDemandTableView(_ tableView: ISOnDemandTableView, didSelectRowAt indexPath: IndexPath) {}
    func onDemandTableViewDidScroll(_ tableView: ISOnDemandTableView) {}
    func onDemandTableView(_ tableView: ISOnDemandTableView, heightForHeaderAtSection section: Int) -> CGFloat? {return nil}
    func onDemandTableView(_ tableView: ISOnDemandTableView, viewForHeaderAtSection section: Int) -> UIView? {return nil}
}

