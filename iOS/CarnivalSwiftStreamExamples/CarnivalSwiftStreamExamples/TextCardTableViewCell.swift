//
//  TextCardTableViewCell.swift
//  CarnivalSwiftStreamExamples
//
//  Created by Sam Jarman on 14/09/15.
//  Copyright (c) 2015 Carnival Mobile. All rights reserved.
//

import UIKit

class TextCardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: CarnivalLabel!
    @IBOutlet weak var unreadLabel: UILabel!
    var gradient = CAGradientLayer()

    class func cellIdentifier() -> String {
        return "TextCardTableViewCell"
    }
    
    func configureCell(message: CarnivalMessage) {
        self.titleLabel.text = message.title
        
        if let bodyText = message.text  {
            if  self.bodyLabel != nil {
                self.bodyLabel.text = bodyText
            }
        }
        
        self.configureDateLabel(message)
        self.configureUnreadLabel(message)
        
        if message.imageURL == nil {
            self.configureGradient()
        }
    }
    
    func configureUnreadLabel(message: CarnivalMessage) {
        let fontSize = ScreenSizeHelper.isIphone5orLess() ? ScreenSizeHelper.textSmall() : ScreenSizeHelper.textNormal()
        self.unreadLabel.font = UIFont.systemFontOfSize(fontSize)
        self.unreadLabel.hidden = message.read
        self.unreadLabel.layer.cornerRadius = self.unreadLabel.frame.size.height / 2
        self.unreadLabel.clipsToBounds = true
        self.unreadLabel.text = NSLocalizedString("Unread", comment:"")
    }
    
    func configureDateLabel(message: CarnivalMessage) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d MMM YYYY"
        self.timeAgoLabel.text = dateFormatter.stringFromDate(message.createdAt)
    }
    
    func configureGradient() {
        self.gradient.frame = self.contentView.bounds
        self.gradient.startPoint = CGPointMake(0.1, 0.0)
        self.gradient.endPoint = CGPointMake(0.9, 1)
        self.gradient.colors = [UIColor(red: 106.0 / 255.0, green: 106.0 / 255.0, blue: 106.0 / 255.0, alpha: 1).CGColor,
            UIColor(red: 147.0 / 255.0, green: 147.0 / 255.0, blue: 147.0 / 255.0, alpha: 1).CGColor]
        self.contentView.layer.insertSublayer(self.gradient, atIndex: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradient.frame = self.contentView.bounds
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        let backgroundColor = self.unreadLabel.backgroundColor
        super.setSelected(selected, animated: animated)
        self.unreadLabel.backgroundColor = backgroundColor
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        let backgroundColor = self.unreadLabel.backgroundColor
        super.setHighlighted(selected, animated: animated)
        self.unreadLabel.backgroundColor = backgroundColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutMargins = UIEdgeInsetsZero
        self.separatorInset = UIEdgeInsetsZero
    }
}