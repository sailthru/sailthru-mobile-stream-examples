//
//  GraphicalCardsViewController.m
//  MarigoldStreamExamples
//
//  Created by Sam Jarman on 9/09/15.
//  Copyright (c) 2015 Marigold Mobile. All rights reserved.
//

#import "GraphicalCardsViewController.h"
#import "GraphicalCardTableViewCell.h"
#import "TextCardTableViewCell.h"

/* Cocoa Pod dependencies – Visit cocoapods.org to get started. */
#import <Marigold/Marigold.h>

@interface GraphicalCardsViewController ()
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UILabel *emptyDataLabel;

@end

@implementation GraphicalCardsViewController

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
    //Get the message
    MARMessage *message = [self.messages objectAtIndex:indexPath.row];
    //Create a stream impression on the message
    [[MARMessageStream new] registerImpressionWithType:MARImpressionTypeStreamView forMessage:message];
    
    if (message.imageURL || message.videoURL) {
        GraphicalCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[GraphicalCardTableViewCell cellIndentifier] forIndexPath:indexPath];
        return cell;
    }
    else {
        TextCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TextCardTableViewCell cellIndentifier] forIndexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(id)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //Get the message
    MARMessage *message = [self.messages objectAtIndex:indexPath.row];
    
    [cell configureCellWithMessage:message];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MARMessage *message = [self.messages objectAtIndex:indexPath.row];
    if (message.imageURL || message.videoURL) {
        return [self heightForImageCellAtIndexPath:indexPath];
    }
    return [self heightForTextCellAtIndexPath:indexPath];
}

- (CGFloat)heightForTextCellAtIndexPath:(NSIndexPath *)indexPath {
    TextCardTableViewCell *sizingCell = [self.tableView dequeueReusableCellWithIdentifier:[TextCardTableViewCell cellIndentifier]];
    [sizingCell configureCellWithMessage:[self.messages objectAtIndex:indexPath.row]];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)heightForImageCellAtIndexPath:(NSIndexPath *)indexPath {
    float width = self.view.bounds.size.width;
    return width * (3.0/5.0) + 1.0f; // Add 1.0f for the cell seperator height
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {

    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.bounds));

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

@end
