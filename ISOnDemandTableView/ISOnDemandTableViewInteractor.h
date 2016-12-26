//
//  ISOnDemandTableViewInteractor.h
//  ISOnDemandTableView
//
//  Created by Dielson Sales on 21/12/16.
//  Copyright © 2016 Ilhasoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISOnDemandTableViewInteractorDelegate <NSObject>

- (void)onObjectsFetched:(NSArray *)lastObjects error:(NSError *)error;

@end

@interface ISOnDemandTableViewInteractor : NSObject

@property id<ISOnDemandTableViewInteractorDelegate> delegate;
@property NSMutableArray *objects;
@property NSUInteger currentPage;
@property NSUInteger paginationCount;
@property BOOL hasMoreItems;
@property BOOL isFetching;

- (instancetype)initWithPaginationCount:(NSUInteger)paginationCount;
- (void)loadItems;
- (void)fetchObjectsForPage:(NSUInteger)page withBlock:(void(^)(NSArray *result, NSError *error))handler;
- (void)refreshAllContent;
- (void)onObjectsLoaded:(NSArray *)lastObjects;

@end
