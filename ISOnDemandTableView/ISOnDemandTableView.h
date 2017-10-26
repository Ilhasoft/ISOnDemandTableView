//
//  ISOnDemandTableView.h
//  ISOnDemandTableView
//
//  Created by Dielson Sales on 21/12/16.
//  Copyright © 2016 Ilhasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISOnDemandTableViewInteractor.h"

@class ISOnDemandTableView;

@protocol ISOnDemandTableViewDelegate <NSObject>

@optional - (void)onDemandTableView:(ISOnDemandTableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
@optional - (void)onDemandTableView:(ISOnDemandTableView * _Nonnull)tableView setupCell:(UITableViewCell * _Nonnull)cell atIndexPath:(NSIndexPath * _Nonnull)indexPath;
@optional - (void)onDemandTableView:(ISOnDemandTableView * _Nonnull)tableView cell:(UITableViewCell * _Nonnull)cell willAppearAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
@optional - (void)onDemandWillStartLoading:(ISOnDemandTableView * _Nonnull)tableView;
@optional - (void)onDemandWasPulledToRefresh:(ISOnDemandTableView * _Nonnull)tableView;
@optional - (void)onDemandTableView:(ISOnDemandTableView * _Nonnull)tableView cell:(UITableViewCell * _Nonnull)cell willDisappearAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
@optional - (void)onDemandTableView:(ISOnDemandTableView * _Nonnull)tableView scrollViewDidScroll:(UIScrollView * _Nonnull)scrollView;
@optional - (CGFloat)onDemandTableView:(ISOnDemandTableView * _Nonnull)tableView heightForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
@optional - (CGFloat)onDemandTableView:(ISOnDemandTableView * _Nonnull)tableView heightForHeaderAtSection:(NSInteger *)section;
@optional - (UIView * _Nullable)onDemandTableView:(ISOnDemandTableView * _Nonnull)tableView viewForHeaderInSection:(NSInteger *)section;

- (void)onDemandTableView:(ISOnDemandTableView * _Nonnull)tableView onContentLoad:(NSArray * _Nullable)lastData withError:(NSError * _Nullable)error;
- (NSString * _Nonnull)onDemandTableView:(ISOnDemandTableView * _Nonnull)tableView reuseIdentifierForCellAtIndexPath:(NSIndexPath * _Nonnull)indexPath;

@end

@interface ISOnDemandTableView : UITableView <UITableViewDataSource, UITableViewDelegate, ISOnDemandTableViewInteractorDelegate>

@property(nonatomic) ISOnDemandTableViewInteractor * _Nullable interactor;
@property(nonatomic) BOOL showFooterSpinner;
@property(nonatomic) BOOL ignoreLoadRequests;
@property(nonatomic) id<ISOnDemandTableViewDelegate> _Nullable onDemandTableViewDelegate;

- (void)setInteractor:(ISOnDemandTableViewInteractor * _Nonnull)newInteractor;
- (void)loadContent;
- (void)setFooterSpinner;

@end
