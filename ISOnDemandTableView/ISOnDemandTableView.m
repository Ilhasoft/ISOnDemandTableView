//
//  ISOnDemandTableView.m
//  ISOnDemandTableView
//
//  Created by Dielson Sales on 21/12/16.
//  Copyright © 2016 Ilhasoft. All rights reserved.
//

#import "ISOnDemandTableView.h"
#import "ISOnDemandTableViewCell.h"

@implementation ISOnDemandTableView {
    UIRefreshControl *compatRefreshControl;
}

@synthesize interactor;

# pragma mark - Constructors

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    compatRefreshControl = [[UIRefreshControl alloc] init];
    if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber10_0) {
        self.refreshControl = compatRefreshControl;
    } else {
        // Fallback on earlier versions
        [self insertSubview:compatRefreshControl atIndex:0];
    }
    [compatRefreshControl addTarget:self action:@selector(onPullToRefresh) forControlEvents:UIControlEventValueChanged];
    self.dataSource = self;
    self.delegate = self;
}

- (void)setInteractor:(ISOnDemandTableViewInteractor *)newInteractor
{
    self->interactor = newInteractor;
    self->interactor.delegate = self;
}

- (void)onPullToRefresh
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 30.0)];
    [spinner startAnimating];
    spinner.color = [UIColor grayColor];
    self.tableFooterView = spinner;
    [self.interactor refreshAllContent];
}

- (void)loadContent
{
    if (self.onDemandTableViewDelegate == nil) {
        [NSException raise:@"ISOnDemandTableViewDelegateNotSet" format:@"You must set the ISOnDemandTableViewDelegate before calling loadContent"];
    }
    [self.interactor loadItems];

    if (self.interactor.hasMoreItems && self.tableFooterView == nil) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 30.0)];
        [spinner startAnimating];
        spinner.color = [UIColor grayColor];
        self.tableFooterView = spinner;
    }
}

# pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.interactor.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = [self.onDemandTableViewDelegate reuseIdentifierForCellAtIndexPath:indexPath];
    id<ISOnDemandTableViewCell> cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setupCellWithObject:[self.interactor.objects objectAtIndex:indexPath.row]];
    return (UITableViewCell *)cell;
}

# pragma mark - UITableViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat contentYOffset = self.contentOffset.y + self.frame.size.height;
    if (contentYOffset >= self.contentSize.height) {
        NSLog(@"Reached end of tableview");
        [self loadContent];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO) {
        CGFloat contentYOffset = self.contentOffset.y + self.frame.size.height;
        if (contentYOffset >= self.contentSize.height) {
            NSLog(@"Reached end of tableview");
            [self loadContent];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.onDemandTableViewDelegate respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
        [self.onDemandTableViewDelegate didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.onDemandTableViewDelegate respondsToSelector:@selector(cell:willAppearAtIndexPath:)]) {
        [self.onDemandTableViewDelegate cell:cell willAppearAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.onDemandTableViewDelegate respondsToSelector:@selector(cell:willDisappearAtIndexPath:)]) {
        [self.onDemandTableViewDelegate cell:cell willDisappearAtIndexPath:indexPath];
    }
}

# pragma mark - ISOnDemandTableViewInteractorDelegate

- (void)onObjectsFetched:(NSArray *)lastObjects error:(NSError *)error
{
    if (compatRefreshControl.isRefreshing) {
        [compatRefreshControl endRefreshing];
    }
    if (lastObjects.count < self.interactor.paginationCount) {
        self.tableFooterView = nil;
    }
    [self.onDemandTableViewDelegate onContentLoadFinishedWithError:error];
    if (error == nil) {
        [self reloadData];
    }

}

@end
