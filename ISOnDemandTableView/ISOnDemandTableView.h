//
//  ISOnDemandTableView.h
//  ISOnDemandTableView
//
//  Created by Dielson Sales on 21/12/16.
//  Copyright © 2016 Ilhasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISOnDemandTableViewInteractor.h"

@protocol ISOnDemandTableViewDelegate <NSObject>

@optional - (void)didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
@optional - (void)setupCell:(UITableViewCell * _Nonnull)cell atIndexPath:(NSIndexPath * _Nonnull)indexPath;
@optional - (void)cell:(UITableViewCell * _Nonnull)cell willAppearAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
@optional - (void)cell:(UITableViewCell * _Nonnull)cell willDisappearAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
@optional - (void)scrollViewDidScroll:(UIScrollView * _Nonnull)scrollView;
@optional - (CGFloat)heightForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;

- (void)onContentLoadFinishedWithError:(NSError * _Nullable)error;
- (NSString * _Nonnull)reuseIdentifierForCellAtIndexPath:(NSIndexPath * _Nonnull)indexPath;

@end

@interface ISOnDemandTableView : UITableView <UITableViewDataSource, UITableViewDelegate, ISOnDemandTableViewInteractorDelegate>

@property(nonatomic) ISOnDemandTableViewInteractor * _Nullable interactor;
@property(nonatomic) id<ISOnDemandTableViewDelegate> _Nullable onDemandTableViewDelegate;

- (void)setInteractor:(ISOnDemandTableViewInteractor * _Nonnull)newInteractor;
- (void)loadContent;

@end
