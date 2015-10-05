//
//  CustomStreamTableViewController.m
//  ExampleProject
//
//  Created by Sam Jarman on 7/08/15.
//  Copyright (c) 2015 Carnival Labs. All rights reserved.
//

#import "ListStreamViewController.h"
#import "ListStreamTableViewCell.h"
#import "ScreenSizeHelper.h"

/* Cocoa Pod dependencies – Visit cocoapods.org to get started. */
#import <Carnival/Carnival.h>

@interface ListStreamViewController ()
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UILabel *emptyDataLabel;

@end

@implementation ListStreamViewController

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return IS_IPHONE_5_OR_LESS ? 90 : 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListStreamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ListStreamTableViewCell cellIndentifier] forIndexPath:indexPath];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ListStreamTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Get the message
    CarnivalMessage *message = [self.messages objectAtIndex:indexPath.row];
    
    [cell configureCellWithMessage:message];
    
    //Create a stream impression on the message
    [CarnivalMessageStream registerImpressionWithType:CarnivalImpressionTypeStreamView forMessage:message];
}

#pragma mark - UI

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)refreshTableView {
    [self.refreshControl beginRefreshing];
    [self fetchLatestMessages];
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
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Get the Carnival Message
        CarnivalMessage *message = [self.messages objectAtIndex:indexPath.row];

        //Register the message as deleted with Carnival
        //[CarnivalMessageStream removeMessage:message withResponse:NULL]; //TODO: Uncomment this when you're happy with how the stream deletion looks and works.
        
        //Remove it from the data source
        [self.messages removeObject:message];
        
        //Remove from Table View
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //Optionally re-request the messages.
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"Delete", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
    }];
    
    button.backgroundColor = [UIColor colorWithRed:212.0/255.0 green:84.0/255.0 blue:140.0/255.0 alpha:1];
    
    return @[button];
}

#pragma mark - Navigation Bar Delegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

@end
