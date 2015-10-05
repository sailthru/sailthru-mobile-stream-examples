//
//  ListStreamViewController.swift
//  CarnivalSwiftStreamExamples
//
//  Created by Sam Jarman on 11/09/15.
//  Copyright (c) 2015 Carnival Mobile. All rights reserved.
//

import Foundation
import UIKit


class ListStreamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIBarPositioningDelegate  {
    
    var messages: NSMutableArray = []
    var refreshControl: UIRefreshControl?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var emptyDataLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpRefreshControl()
        
        if self.tableView.respondsToSelector("setSeparatorInset") {
           self.tableView.separatorInset = UIEdgeInsetsZero
        }
        self.navigationBar.topItem?.title = NSLocalizedString("Messages", comment: "")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshTableView()
    }

    @IBAction func refreshTableView () {
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Define the header view
        var headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 60))
        headerView.backgroundColor = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 245.0/255.0, alpha: 1)

        //Define and configure the label
        var messagesLabel = UILabel(frame: CGRectMake(10, 6, tableView.frame.size.width, 30))
        if  self.messages.count == 0 {
            messagesLabel.text = NSLocalizedString("1 MESSAGE", comment:"")
        }
        else {
            messagesLabel.text =  NSLocalizedString("\(self.messages.count) MESSAGES", comment:"")
        }
        messagesLabel.font = UIFont.systemFontOfSize(12)
        messagesLabel.textColor = UIColor(red: 112.0/255.0, green: 107.0/255, blue: 107.0/255.0, alpha: 1)
        
        //Add the label to the header view and return it
        headerView.addSubview(messagesLabel)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ScreenSizeHelper.isIphone5orLess() ? 90 : 110
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(BasicListStreamTableViewCell.cellIdentifier(), forIndexPath: indexPath) as! BasicListStreamTableViewCell
        return cell
    }
    
    
    //MARK: TableView Delegate Methods
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //Get the message
        let message  = self.messages.objectAtIndex(indexPath.row) as! CarnivalMessage
        let aCell = cell as! BasicListStreamTableViewCell
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
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            //Get the Carnival Message
            let message = self.messages.objectAtIndex(indexPath.row) as! CarnivalMessage
            
            //Register the message as deleted with Carnival
            CarnivalMessageStream.removeMessage(message, withResponse: nil)
            
            //Remove it from the data source
            self.messages.removeObject(message)
            
            //Remove from Table View
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var button = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: NSLocalizedString("Delete", comment:"")) { (action, indexPath) -> Void in
            self.tableView(tableView, commitEditingStyle: UITableViewCellEditingStyle.Delete, forRowAtIndexPath: indexPath)
        }
        
        button.backgroundColor = UIColor(red: 212.0/255.0, green: 84.0/255.0, blue: 140.0/255.0, alpha: 1)
        
        return [button]
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
                print(error)
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