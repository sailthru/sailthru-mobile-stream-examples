//
//  GraphicalCardsViewController.m
//  CarnivalStreamExamples
//
//  Created by Sam Jarman on 9/09/15.
//  Copyright (c) 2015 Carnival Mobile. All rights reserved.
//

#import "GraphicalCardsViewController.h"
#import "GraphicalCardTableViewCell.h"
#import "TextCardTableViewCell.h"

/* Cocoa Pod dependencies – Visit cocoapods.org to get started. */
#import <Carnival/Carnival.h>

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
    [self.refreshControl beginRefreshing];
    [self fetchLatestMessages];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Get the message
    CarnivalMessage *message = [self.messages objectAtIndex:indexPath.row];
    
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
    CarnivalMessage *message = [self.messages objectAtIndex:indexPath.row];
    
    [cell configureCellWithMessage:message];
    
    //Create a stream impression on the message
    [CarnivalMessageStream registerImpressionWithType:CarnivalImpressionTypeStreamView forMessage:message];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarnivalMessage *message = [self.messages objectAtIndex:indexPath.row];
    if (message.imageURL || message.videoURL) {
        return [self heightForImageCellAtIndexPath:indexPath];
    }
    return [self heightForTextCellAtIndexPath:indexPath];
}

- (CGFloat)heightForTextCellAtIndexPath:(NSIndexPath *)indexPath {
    static TextCardTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:[TextCardTableViewCell cellIndentifier]];
    });

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

@end