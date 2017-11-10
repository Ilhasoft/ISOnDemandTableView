//
//  ISOnDemandTableViewInteractor.m
//  ISOnDemandTableView
//
//  Created by Dielson Sales on 21/12/16.
//  Copyright © 2016 Ilhasoft. All rights reserved.
//

#import "ISOnDemandTableViewInteractor.h"

@implementation ISOnDemandTableViewInteractor

- (instancetype)initWithPaginationCount:(NSUInteger)paginationCount
{
    self = [super init];
    if (self) {
        self.objects = [[NSMutableArray alloc] init];
        self.currentPage = 0;
        self.paginationCount = paginationCount;
        self.hasMoreItems = YES;
        self.isFetching = NO;
    }
    return self;
}

- (void)loadItems
{
    if (self.isFetching) {
        NSLog(@"Still fetching items, wait...");
        return;
    }
    if (!self.hasMoreItems) {
        NSLog(@"All items were already fetched");
        return;
    }
    self.isFetching = YES;
    [self fetchObjectsForPage:self.currentPage withBlock: ^(NSArray *result, NSError *error) {
        for (NSUInteger i = 0; i < result.count; ++i) {
            NSObject *object = [result objectAtIndex:i];
            [self.objects addObject:object];
        }
        [self onObjectsLoaded:result];
        [self.delegate onObjectsFetched:result error:error];
    }];
}

/**
 * Override this method to return the new objects fetched every time a new page is loaded
 */
- (void)fetchObjectsForPage:(NSUInteger)page withBlock:(void(^)(NSArray *result, NSError *error))handler
{
    // Override to implementn this
}

- (void)refreshAllContent
{
    if (self.isFetching) {
        NSLog(@"Still fetching items, wait...");
        return;
    }
    self.currentPage = 0;
    self.hasMoreItems = YES;
    self.isFetching = YES;
    [self fetchObjectsForPage:self.currentPage withBlock: ^(NSArray *result, NSError *error) {
        [self.objects removeAllObjects];
        for (NSUInteger i = 0; i < result.count; ++i) {
            NSObject *object = [result objectAtIndex:i];
            [self.objects addObject:object];
        }
        [self onObjectsLoaded:result];
        [self.delegate onObjectsFetched:result error:error];
    }];
}

- (void)onObjectsLoaded:(NSArray *)lastObjects
{
    self.isFetching = NO;
    self.currentPage++;
    if (lastObjects.count < self.paginationCount) {
        self.hasMoreItems = NO;
    }
}

@end

