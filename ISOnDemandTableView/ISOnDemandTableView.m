//
//  ISOnDemandTableView.m
//  ISOnDemandTableView
//
//  Created by Dielson Sales on 21/12/16.
//  Copyright © 2016 Ilhasoft. All rights reserved.
//

#import "ISOnDemandTableView.h"
#import "ISOnDemandTableViewCell.h"

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

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
    if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
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
    //[self setFooterSpinner];
    if ([self.onDemandTableViewDelegate respondsToSelector:@selector(onDemandWillStartLoading:)]) {
        [self.onDemandTableViewDelegate onDemandWillStartLoading:self];
    }
    
    if ([self.onDemandTableViewDelegate respondsToSelector:@selector(onDemandWasPulledToRefresh:)]) {
        [self.onDemandTableViewDelegate onDemandWasPulledToRefresh:self];
    }
    
    [self.interactor refreshAllContent];
}

- (void)setFooterSpinner
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 30.0)];
    [spinner startAnimating];
    spinner.color = [UIColor grayColor];
    self.tableFooterView = spinner;
}

- (void)loadContent
{
    if (self.onDemandTableViewDelegate == nil) {
        [NSException raise:@"ISOnDemandTableViewDelegateNotSet" format:@"You must set the ISOnDemandTableViewDelegate before calling loadContent"];
    }
    
    if (!self.interactor.isFetching && !_ignoreLoadRequests) {
        if ([self.onDemandTableViewDelegate respondsToSelector:@selector(onDemandWillStartLoading:)]) {
            [self.onDemandTableViewDelegate onDemandWillStartLoading:self];
        }
        [self.interactor loadItems];
        
        if (self.interactor.hasMoreItems && self.showFooterSpinner) {
            self.showFooterSpinner = NO;
            [self setFooterSpinner];
        }
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
    NSString *reuseIdentifier = [self.onDemandTableViewDelegate onDemandTableView:self reuseIdentifierForCellAtIndexPath:indexPath];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if ([cell conformsToProtocol:@protocol(ISOnDemandTableViewCell)]) {
        UITableViewCell<ISOnDemandTableViewCell> *onDemandTableViewCell = (UITableViewCell<ISOnDemandTableViewCell> *)cell;
        [onDemandTableViewCell setupCellWithObject:[self.interactor.objects objectAtIndex:indexPath.row] atIndexPath:indexPath];
    }
    if ([self.onDemandTableViewDelegate respondsToSelector:@selector(onDemandTableView:setupCell:atIndexPath:)]) {
        [self.onDemandTableViewDelegate onDemandTableView:self setupCell:cell atIndexPath:indexPath];
    }
    return (UITableViewCell *)cell;
}

# pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.onDemandTableViewDelegate respondsToSelector:@selector(onDemandTableView:scrollViewDidScroll:)]) {
        [self.onDemandTableViewDelegate onDemandTableView:self scrollViewDidScroll:scrollView];
    }
}

# pragma mark - UITableViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat contentYOffset = self.contentOffset.y + self.frame.size.height;
    if (contentYOffset >= self.contentSize.height) {
        NSLog(@"Reached end of tableview");
        self.showFooterSpinner = YES;
        [self loadContent];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO) {
        CGFloat contentYOffset = self.contentOffset.y + self.frame.size.height;
        if (contentYOffset >= self.contentSize.height) {
            NSLog(@"Reached end of tableview");
            self.showFooterSpinner = YES;
            [self loadContent];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.onDemandTableViewDelegate respondsToSelector:@selector(onDemandTableView:didSelectRowAtIndexPath:)]) {
        [self.onDemandTableViewDelegate onDemandTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.onDemandTableViewDelegate respondsToSelector:@selector(onDemandTableView:cell:willAppearAtIndexPath:)]) {
        [self.onDemandTableViewDelegate onDemandTableView:self cell:cell willAppearAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.onDemandTableViewDelegate respondsToSelector:@selector(onDemandTableView:cell:willDisappearAtIndexPath:)]) {
        [self.onDemandTableViewDelegate onDemandTableView:self cell:cell willDisappearAtIndexPath:indexPath];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.onDemandTableViewDelegate respondsToSelector:@selector(onDemandTableView:viewForHeaderInSection:)]) {
        return [self.onDemandTableViewDelegate onDemandTableView:self viewForHeaderInSection:&section];
    } else {
        return NULL;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.onDemandTableViewDelegate respondsToSelector:@selector(onDemandTableView:heightForHeaderAtSection:)]) {
        return [self.onDemandTableViewDelegate onDemandTableView:self heightForHeaderAtSection:&section];
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.onDemandTableViewDelegate respondsToSelector:@selector(onDemandTableView:heightForRowAtIndexPath:)]) {
        return [self.onDemandTableViewDelegate onDemandTableView:self heightForRowAtIndexPath:indexPath];
    } else {
        return UITableViewAutomaticDimension;
    }
}

# pragma mark - ISOnDemandTableViewInteractorDelegate

- (void)onObjectsFetched:(NSArray *)lastObjects error:(NSError *)error
{
    self.tableFooterView = nil;
    if (compatRefreshControl.isRefreshing) {
        [compatRefreshControl endRefreshing];
    }
    [self.onDemandTableViewDelegate onDemandTableView:self onContentLoad:lastObjects withError:error];
    if (error == nil) {
        [self reloadData];
    }

}

@end
