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
        
        if self.tableView.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
           self.tableView.separatorInset = UIEdgeInsets.zero
        }
        self.navigationBar.topItem?.title = NSLocalizedString("Messages", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshTableView()
    }

    @IBAction func refreshTableView() {
        self.tableView!.setContentOffset(CGPoint(x: 0, y: -self.refreshControl!.frame.size.height), animated: true)
        self.refreshControl!.beginRefreshing()
        self.fetchMessages()
    }
    
    //MARK: TableView Data Source Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard self.messages.count > 0 else {
            return nil;
        }
        //Define the header view
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60))
        headerView.backgroundColor = UIColor(red: 241.0 / 255.0, green: 241.0 / 255.0, blue: 245.0 / 255.0, alpha: 1)

        //Define and configure the label
        let messagesLabel = UILabel(frame: CGRect(x: 10, y: 6, width: tableView.frame.size.width, height: 30))
        if  self.messages.count == 0 {
            messagesLabel.text = NSLocalizedString("1 MESSAGE", comment:"")
        }
        else {
            messagesLabel.text =  NSLocalizedString("\(self.messages.count) MESSAGES", comment:"")
        }
        messagesLabel.font = UIFont.systemFont(ofSize: 12)
        messagesLabel.textColor = UIColor(red: 112.0 / 255.0, green: 107.0 / 255, blue: 107.0 / 255.0, alpha: 1)
        
        //Add the label to the header view and return it
        headerView.addSubview(messagesLabel)
        
        return headerView
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenSizeHelper.isIphone5orLess() ? 90 : 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasicListStreamTableViewCell.cellIdentifier(), for: indexPath as IndexPath) as! BasicListStreamTableViewCell
        
        return cell
    }
    
    //MARK: TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Get the message
        let message  = self.messages.object(at: indexPath.row) as! CarnivalMessage
        
        //Configure the message
        let aCell = cell as! BasicListStreamTableViewCell
        aCell.configureCell(message: message)
        
        //Create a stream impression on the message
        CarnivalMessageStream.registerImpression(with: CarnivalImpressionType.streamView, for: message)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Get the Carnival Message
        let message = self.messages.object(at: indexPath.row) as! CarnivalMessage
        
        //Present the full screen message
        CarnivalMessageStream.presentMessageDetail(for: message)
        
        //Mark the message as read
        CarnivalMessageStream.markMessage(asRead: message, withResponse: nil)
        
        //Deselect the row that is selected
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            self.deleteMessage(tableView: tableView, forRowAtIndexPath: indexPath as NSIndexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let button = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: NSLocalizedString("Delete", comment:"")) { (action, indexPath) -> Void in
            self.deleteMessage(tableView: tableView, forRowAtIndexPath: indexPath as NSIndexPath)
        }
        
        button.backgroundColor = UIColor(red: 212.0 / 255.0, green: 84.0 / 255.0, blue: 140.0 / 255.0, alpha: 1)

        return [button]
    }
    
    func deleteMessage(tableView: UITableView, forRowAtIndexPath indexPath: NSIndexPath) {
        //Get the Carnival Message
        let message = self.messages.object(at: indexPath.row) as! CarnivalMessage
        
        //Register the message as deleted with Carnival
        CarnivalMessageStream.remove(message, withResponse: nil)
        
        //Remove it from the data source
        self.messages.remove(message)
        
        //Remove from Table View
        tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
    }
    
    //MARK: UI
    
    func setUpRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(ListStreamViewController.fetchMessages), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self.refreshControl!)
    }
    
    @IBAction func closeStream(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Bar Position Delegate
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    // MARK: Get Messages
    
    @objc func fetchMessages() {
        CarnivalMessageStream.messages { (theMessages, anError) -> Void in
            self.refreshControl?.endRefreshing()
            
            if let error = anError {
                print(error, terminator: "")
                self.tableView.isHidden = true
                self.emptyDataLabel.text = NSLocalizedString("Failed to get messages", comment:"")

            }
            if let messages = theMessages {
                self.messages = NSMutableArray(array:messages)
                self.tableView.reloadData()
                self.tableView.isHidden = self.messages.count == 0
                self.emptyDataLabel.text = NSLocalizedString("You have no messages", comment:"")
            }
        }
    }
}
