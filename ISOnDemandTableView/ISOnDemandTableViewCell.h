//
//  ISOnDemandTableViewCell.h
//  ISOnDemandTableView
//
//  Created by Dielson Sales on 24/12/16.
//  Copyright © 2016 Ilhasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ISOnDemandTableViewCell <NSObject>

- (void)setupCellWithObject:(id _Nonnull)object atIndexPath:(NSIndexPath * _Nonnull)indexPath;

@end
