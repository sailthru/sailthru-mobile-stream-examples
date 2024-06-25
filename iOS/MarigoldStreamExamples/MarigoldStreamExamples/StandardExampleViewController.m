//
//  StandardExampleViewController.m
//  MarigoldStreamExamples
//
//  Created by Sam Jarman on 27/10/15.
//  Copyright © 2015 Marigold Mobile. All rights reserved.
//

#import "StandardExampleViewController.h"
#import "StandardTableViewCell.h"

/* Cocoa Pod dependencies – Visit cocoapods.org to get started. */
#import <Marigold/Marigold.h>

@interface StandardExampleViewController ()
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UILabel *emptyDataLabel;
@property (strong, nonatomic) NSMutableArray *rowHeightCache;

@end

@implementation StandardExampleViewController

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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.messages count] > 0) {
        //Define and configure the header view
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width, 40)];
        
        //Define and configure the label
        UILabel *messagesLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, tableView.frame.size.width, 40)];
        if (self.messages.count == 1) {
            messagesLabel.text = NSLocalizedString(@"1 MESSAGE", nil);
        }
        else {
            messagesLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%lu MESSAGES", nil), (unsigned long)self.messages.count];
        }
        messagesLabel.font = [UIFont systemFontOfSize:12];
        messagesLabel.textColor = [UIColor colorWithRed:112.0/255.0 green:107.0/255.0 blue:107.0/255.0 alpha:1];
        
        //Add the label to the header view and return it
        [headerView addSubview:messagesLabel];
        return headerView;
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:[StandardTableViewCell cellIndentifier] forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(id)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //Get the message
    MARMessage *message = [self.messages objectAtIndex:indexPath.row];
    
    //Configure the Message
    [cell configureCellWithMessage:message];
    
    //Create a stream impression on the message
    [[MARMessageStream new] registerImpressionWithType:MARImpressionTypeStreamView forMessage:message];
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
    StandardTableViewCell *sizingCell = [self.tableView dequeueReusableCellWithIdentifier:[StandardTableViewCell cellIndentifier]];
    [sizingCell configureCellWithMessage:[self.messages objectAtIndex:indexPath.row]];
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
    [[MARMessageStream new] messages:^(NSArray *messages, NSError *error) {
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
    //Get the Marigold Message
    MARMessage *message = [self.messages objectAtIndex:indexPath.row];
    
    //Present the full screen message
    [[MARMessageStream new] presentMessageDetailForMessage:message];
    
    //Mark the message as read
    [[MARMessageStream new] markMessageAsRead:message withResponse:NULL];
    
    //Deselect the row that is selected
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Navigation Bar and Status Bar

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
