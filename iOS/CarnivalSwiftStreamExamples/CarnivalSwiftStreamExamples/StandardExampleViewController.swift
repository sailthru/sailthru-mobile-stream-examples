//
//  StandardExampleViewController.swift
//  CarnivalSwiftStreamExamples
//
//  Created by Sam Jarman on 12/14/15.
//  Copyright © 2015 Carnival Mobile. All rights reserved.
//

import UIKit

class StandardExampleViewController: UIViewController {
    @IBOutlet weak var emptyDataLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var messages: NSMutableArray = []
    var rowHeightCache: [CGFloat?] = []
    
    var refreshControl: UIRefreshControl?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpRefreshControl()
        
        self.navigationBar.topItem?.title = NSLocalizedString("Messages", comment:"")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshTableView()
    }
    
    func setUpRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "fetchMessages", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl!)
    }
    
    // MARK: UI Controls

    @IBAction func refreshTableView() {
        self.tableView!.setContentOffset(CGPointMake(0, -self.refreshControl!.frame.size.height), animated: true)
        self.refreshControl!.beginRefreshing()
        self.fetchMessages()
    }
    
    @IBAction func closeStream(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Navigation Bar and Status Bar
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        //Invalidate the heights cache
        self.rowHeightCache = [CGFloat?](count: self.messages.count, repeatedValue: nil)
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    //MARK: TableView Data Source Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 && self.messages.count > 0 else {
            return nil
        }
        //Define the header view
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 60))
        headerView.backgroundColor = UIColor(red: 241.0 / 255.0, green: 241.0 / 255.0, blue: 245.0 / 255.0, alpha: 1)
        
        //Define and configure the label
        let messagesLabel = UILabel(frame: CGRectMake(10, 6, tableView.frame.size.width, 30))
        if  self.messages.count == 0 {
            messagesLabel.text = NSLocalizedString("1 MESSAGE", comment:"")
        }
        else {
            messagesLabel.text =  NSLocalizedString("\(self.messages.count) MESSAGES", comment:"")
        }
        messagesLabel.font = UIFont.systemFontOfSize(12)
        messagesLabel.textColor = UIColor(red: 112.0 / 255.0, green: 107.0 / 255, blue: 107.0 / 255.0, alpha: 1)
        
        //Add the label to the header view and return it
        headerView.addSubview(messagesLabel)
        
        return headerView
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(StandardTableViewCell.cellIdentifier(), forIndexPath: indexPath) as! StandardTableViewCell
    }
    
    //MARK: TableView Delegate Methods
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //Get the message
        let message  = self.messages.objectAtIndex(indexPath.row) as! CarnivalMessage
        
        //Configure the cell
        let aCell = cell as! StandardTableViewCell
        aCell.configureCell(message)
        
        //Create a stream impression on the message
        CarnivalMessageStream.registerImpressionWithType(CarnivalImpressionType.StreamView, forMessage: message)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let size = self.rowHeightCache[indexPath.row] {
            return size;
        }
        
        let size = self.heightForCell(indexPath)
        self.rowHeightCache[indexPath.row] = size
        
        return size
    }
    
    func heightForCell(indexPath: NSIndexPath) -> CGFloat {
        let sizingCell = self.tableView.dequeueReusableCellWithIdentifier(StandardTableViewCell.cellIdentifier()) as! StandardTableViewCell
        sizingCell.configureCell(self.messages.objectAtIndex(indexPath.row) as! CarnivalMessage)
        
        return self.calculateHeightForConfiguredSizingCell(sizingCell)
    }
    
    func calculateHeightForConfiguredSizingCell(sizingCell: UITableViewCell) -> CGFloat {
        sizingCell.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.frame))
        
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        
        let size: CGSize = sizingCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        
        return size.height + 1 //Add 1 for the cell separator
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
                self.rowHeightCache = [CGFloat?](count: self.messages.count, repeatedValue: nil)
                self.tableView.reloadData()
                self.tableView.hidden = self.messages.count == 0
                self.emptyDataLabel.text = NSLocalizedString("You have no messages", comment:"")
                
            }
        }
    }
}