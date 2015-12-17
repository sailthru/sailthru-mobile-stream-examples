//
//  StandardExampleViewController.m
//  CarnivalStreamExamples
//
//  Created by Sam Jarman on 27/10/15.
//  Copyright © 2015 Carnival Mobile. All rights reserved.
//

#import "CardExampleViewController.h"
#import "CardExampleTableViewCell.h"

/* Cocoa Pod dependencies – Visit cocoapods.org to get started. */
#import <Carnival/Carnival.h>

@interface CardExampleViewController ()
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UILabel *emptyDataLabel;
@property (strong, nonatomic) NSMutableArray *rowHeightCache;

@end

@implementation CardExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpRefreshControl];
    
    self.navigationBar.topItem.title = NSLocalizedString(@"Messages", nil);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshTableView];
}

- (void)setUpRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(fetchLatestMessages)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (IBAction)refreshTableView {
    [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated: true];
    [self.refreshControl beginRefreshing];
    [self fetchLatestMessages];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardExampleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CardExampleTableViewCell cellIndentifier] forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(id)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //Get the message
    CarnivalMessage *message = [self.messages objectAtIndex:indexPath.row];
    [cell configureCellWithMessage:message atIndexPath:indexPath];
    
    //Create a stream impression on the message
    [CarnivalMessageStream registerImpressionWithType:CarnivalImpressionTypeStreamView forMessage:message];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.rowHeightCache objectAtIndex:indexPath.row] != [NSNull null]) {
        return [[self.rowHeightCache objectAtIndex:indexPath.row] floatValue];
    }
    
    CGFloat height = [self heightForCellAtIndexPath:indexPath];
    
   [self.rowHeightCache setObject:@(height) atIndexedSubscript:indexPath.row];
    
    return height;
}

- (CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath {
    CardExampleTableViewCell *sizingCell = [self.tableView dequeueReusableCellWithIdentifier:[CardExampleTableViewCell cellIndentifier]];
    [sizingCell configureCellWithMessage:[self.messages objectAtIndex:indexPath.row] atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    sizingCell.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.frame));
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

#pragma mark - UI

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Messages

- (void)fetchLatestMessages {
    [CarnivalMessageStream messages:^(NSArray *messages, NSError *error) {
        
        if (error) {
            NSLog(@"Error getting messages - %@", error.localizedDescription);
            self.emptyDataLabel.text = NSLocalizedString(@"Failed to get messages", nil);
            self.tableView.hidden = YES;
        }
        else {
            self.messages = [NSMutableArray arrayWithArray:messages];
            self.emptyDataLabel.text = NSLocalizedString(@"You have no messages", nil);
            self.tableView.hidden = self.messages.count == 0;
            self.rowHeightCache = [self emptyArrayOfSize:self.messages.count];
            [self.tableView reloadData];
        }
        
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Get the Carnival Message
    CarnivalMessage *message = [self.messages objectAtIndex:indexPath.row];
    
    //Present the full screen message
    [CarnivalMessageStream presentMessageDetailForMessage:message];
    
    //Mark the message as read
    [CarnivalMessageStream markMessageAsRead:message withResponse:NULL];
    
    //Deselect the row that is selected
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Navigation Bar & Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    //Invalidate the heights cache
    self.rowHeightCache = [self emptyArrayOfSize:self.messages.count];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - Empty Array Helper

- (NSMutableArray *)emptyArrayOfSize:(NSInteger)size {
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:size];
    
    for (int i = 0; i < size; i ++) {
        [newArray addObject:[NSNull null]];
    }
    
    return newArray;
}

@end