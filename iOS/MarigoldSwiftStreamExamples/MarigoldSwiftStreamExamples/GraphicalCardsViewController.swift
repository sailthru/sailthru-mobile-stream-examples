//
//  GraphicalCardsViewController.swift
//  MarigoldSwiftStreamExamples
//
//  Created by Sam Jarman on 14/09/15.
//  Copyright (c) 2015 Marigold Mobile. All rights reserved.
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
    
        if self.tableView.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            self.tableView.separatorInset = UIEdgeInsets.zero
        }
        self.navigationBar.topItem?.title = NSLocalizedString("Messages", comment:"")
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = self.messages.object(at: indexPath.row) as! MARMessage
        
        if(message.imageURL != nil || message.videoURL != nil) {
            return self.heightForImageCell(indexPath: indexPath as NSIndexPath)
        }
        else {
            return self.heightForTextCell(indexPath: indexPath as NSIndexPath)
        }
    }
    
    func heightForImageCell(indexPath: NSIndexPath) -> CGFloat {
        let width = self.view.bounds.width
        
        return width * (3.0 / 5.0) + 1 //Add 1 for the cell separator
    }
    
    func heightForTextCell(indexPath: NSIndexPath) -> CGFloat {
        let sizingCell = self.tableView.dequeueReusableCell(withIdentifier: TextCardTableViewCell.cellIdentifier()) as! TextCardTableViewCell
        sizingCell.configureCell(message: self.messages.object(at: indexPath.row) as! MARMessage)
        
        return self.calculateHeightForConfiguredSizingCell(sizingCell: sizingCell)
    }
    
    func calculateHeightForConfiguredSizingCell(sizingCell: UITableViewCell) -> CGFloat {
        sizingCell.bounds = CGRect(x: 0.0, y: 0.0, width: self.tableView.frame.width, height: sizingCell.bounds.height)
        
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        
        let size: CGSize = sizingCell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        return size.height + 1 //Add 1 for the cell separator
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Get the message
        let message  = self.messages.object(at: indexPath.row) as! MARMessage
        
        MARMessageStream().registerImpression(with: .streamView, for: message)
        
        if(message.imageURL != nil || message.videoURL != nil) {
            let cell = tableView.dequeueReusableCell(withIdentifier: GraphicalCardTableViewCell.cellIdentifier(), for: indexPath as IndexPath) as! GraphicalCardTableViewCell
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TextCardTableViewCell.cellIdentifier(), for: indexPath as IndexPath) as! TextCardTableViewCell
            
            return cell
        }
    }
    
    //MARK: TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Get the message
        let message  = self.messages.object(at: indexPath.row) as! MARMessage
        let aCell = cell as! TextCardTableViewCell
        aCell.configureCell(message: message)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Get the Marigold Message
        let message = self.messages.object(at: indexPath.row) as! MARMessage
        
        //Present the full screen message
        MARMessageStream().presentMessageDetail(for: message)
        
        //Mark the message as read
        MARMessageStream().markMessage(asRead: message, withResponse: nil)
        
        //Deselect the row that is selected
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    //MARK: UI
    
    func setUpRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(GraphicalCardsViewController.fetchMessages), for: UIControl.Event.valueChanged)
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
        MARMessageStream().messages { (theMessages, anError) -> Void in
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
