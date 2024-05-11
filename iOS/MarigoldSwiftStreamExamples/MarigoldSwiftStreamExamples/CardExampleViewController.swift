//
//  CardExampleViewController.swift
//  MarigoldSwiftStreamExamples
//
//  Created by Sam Jarman on 12/15/15.
//  Copyright © 2015 Marigold Mobile. All rights reserved.
//

import UIKit

class CardExampleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var emptyDataLabel: UILabel!
    var messages: NSMutableArray = []
    var refreshControl: UIRefreshControl?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    var rowHeightCache: [CGFloat?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpRefreshControl()
        
        self.navigationBar.topItem?.title = NSLocalizedString("Messages", comment:"")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshTableView()
    }
    
    func setUpRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(CardExampleViewController.fetchMessages), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(self.refreshControl!)
    }
    
    // MARK: UI Controls
    
    @IBAction func refreshTableView() {
        self.tableView!.setContentOffset(CGPoint(x: 0, y: -self.refreshControl!.frame.size.height), animated: true)
        self.refreshControl!.beginRefreshing()
        self.fetchMessages()
    }
    
    @IBAction func closeStream(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Navigation Bar and Status Bar
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //Invalidate the heights cache
        self.rowHeightCache = [CGFloat?](repeating: nil, count: self.messages.count)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    //MARK: TableView Data Source Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: CardExampleTableViewCell.cellIdentifier(), for: indexPath as IndexPath) as! CardExampleTableViewCell
    }
    
    //MARK: TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Get the message
        let message = self.messages.object(at: indexPath.row) as! MARMessage
        
        //Configure the cell
        let aCell = cell as! CardExampleTableViewCell
        aCell.configureCell(message: message, indexPath: indexPath as NSIndexPath)
        
        //Create a stream impression on the message
        MARMessageStream().registerImpression(with: .streamView, for: message)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let size = self.rowHeightCache[indexPath.row] {
            return size;
        }
        
        let size = self.heightForCell(indexPath: indexPath as NSIndexPath)
        self.rowHeightCache[indexPath.row] = size

        return size
    }
    
    func heightForCell(indexPath: NSIndexPath) -> CGFloat {
        let sizingCell = self.tableView.dequeueReusableCell(withIdentifier: CardExampleTableViewCell.cellIdentifier()) as! CardExampleTableViewCell
        sizingCell.configureCell(message: self.messages.object(at: indexPath.row) as! MARMessage, indexPath: indexPath)
        
        return self.calculateHeightForConfiguredSizingCell(sizingCell: sizingCell)
    }
    
    func calculateHeightForConfiguredSizingCell(sizingCell: UITableViewCell) -> CGFloat {
        sizingCell.frame = CGRect(x: 0.0, y: 0.0, width: self.tableView.frame.width, height: sizingCell.frame.height)
        
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        
        let size: CGSize = sizingCell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        return size.height + 1 //Add 1 for the cell separator
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
                self.rowHeightCache = [CGFloat?](repeating: nil, count: self.messages.count)
                self.tableView.reloadData()
                self.tableView.isHidden = self.messages.count == 0
                self.emptyDataLabel.text = NSLocalizedString("You have no messages", comment:"")
            }
        }
    }
}
