//
//  GraphicalCardsViewController.swift
//  CarnivalSwiftStreamExamples
//
//  Created by Sam Jarman on 14/09/15.
//  Copyright (c) 2015 Carnival Mobile. All rights reserved.
//

import UIKit

class GraphicalCardsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIBarPositioningDelegate  {
    
    @IBOutlet weak var emptyDataLabel: UILabel!
    var messages: NSMutableArray = []
    var refreshControl: UIRefreshControl?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpRefreshControl()
    
        if self.tableView.respondsToSelector("setSeparatorInset") {
            self.tableView.separatorInset = UIEdgeInsetsZero
        }
        self.navigationBar.topItem?.title = NSLocalizedString("Messages", comment:"")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshTableView()
    }
    
    func refreshTableView () {
        self.tableView!.setContentOffset(CGPointMake(0, -self.refreshControl!.frame.size.height), animated: true)
        self.refreshControl!.beginRefreshing()
        self.fetchMessages()
    }
    
    //MARK: TableView Data Source Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let message = self.messages.objectAtIndex(indexPath.row) as! CarnivalMessage
        
        if(message.imageURL != nil || message.videoURL != nil) {
            return self.heightForImageCell(indexPath)
        }
        else {
            return self.heightForTextCell(indexPath)
        }
    }
    
    func heightForImageCell(indexPath: NSIndexPath) -> CGFloat {
        let width = CGRectGetWidth(self.view.bounds)
        return width * (3.0/5.0) + 1 //Add 1 for the cell separator
    }
    
    func heightForTextCell(indexPath: NSIndexPath) -> CGFloat {
        var sizingCell = TextCardTableViewCell()
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) { () -> Void in
          sizingCell = self.tableView.dequeueReusableCellWithIdentifier(TextCardTableViewCell.cellIdentifier()) as! TextCardTableViewCell
        }
        
        sizingCell.configureCell(self.messages.objectAtIndex(indexPath.row) as! CarnivalMessage)
        return self.calculateHeightForConfiguredSizingCell(sizingCell)
    }
    
    func calculateHeightForConfiguredSizingCell(sizingCell:UITableViewCell) -> CGFloat {
        sizingCell.bounds = CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.bounds))
        
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        
        let size:CGSize = sizingCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        return size.height + 1 //Add 1 for the cell separator
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Get the message
        let message  = self.messages.objectAtIndex(indexPath.row) as! CarnivalMessage
        
        CarnivalMessageStream.registerImpressionWithType(CarnivalImpressionType.StreamView, forMessage: message)
        
        if(message.imageURL != nil || message.videoURL != nil) {
            let cell = tableView.dequeueReusableCellWithIdentifier(GraphicalCardTableViewCell.cellIdentifier(), forIndexPath: indexPath) as! GraphicalCardTableViewCell
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(TextCardTableViewCell.cellIdentifier(), forIndexPath: indexPath) as! TextCardTableViewCell
            return cell
        }
        
    }
    
    //MARK: TableView Delegate Methods
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //Get the message
        let message  = self.messages.objectAtIndex(indexPath.row) as! CarnivalMessage
        let aCell = cell as! TextCardTableViewCell
        aCell.configureCell(message)
        CarnivalMessageStream.registerImpressionWithType(CarnivalImpressionType.StreamView, forMessage: message)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Get the Carnival Message
        let message = self.messages.objectAtIndex(indexPath.row) as! CarnivalMessage
        
        //Present the full screen message
        CarnivalMessageStream.presentMessageDetailForMessage(message)
        
        //Mark the message as read
        CarnivalMessageStream.markMessageAsRead(message, withResponse: nil)
        
        //Deselect the row that is selected
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: UI
    
    func setUpRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "fetchMessages", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl!)
    }
    
    @IBAction func closeStream(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Bar Position Delegate
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    // MARK: Get Messages
    
    func fetchMessages() {
        CarnivalMessageStream.messages { (theMessages, anError) -> Void in
            self.refreshControl?.endRefreshing()
            
            if let error = anError {
                print(error, terminator: "")
                self.tableView.hidden = true
                self.emptyDataLabel.text = NSLocalizedString("Failed to get messages", comment:"")
                
            }
            if let messages = theMessages {
                self.messages = NSMutableArray(array:messages)
                self.tableView.reloadData()
                self.tableView.hidden = self.messages.count == 0
                self.emptyDataLabel.text = NSLocalizedString("You have no messages", comment:"")

            }
        }
    }
    
}