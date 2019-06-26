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
        
        if let bodyText = message.htmlText  {
            if  self.bodyLabel != nil {
                self.bodyLabel.setHtmlFromString(html: bodyText);
            }
        }
        
        self.configureDateLabel(message: message)
        self.configureUnreadLabel(message: message)
        
        if message.imageURL == nil {
            self.configureGradient()
        }
    }
    
    func configureUnreadLabel(message: CarnivalMessage) {
        let fontSize = ScreenSizeHelper.isIphone5orLess() ? ScreenSizeHelper.textSmall() : ScreenSizeHelper.textNormal()
        self.unreadLabel.font = UIFont.systemFont(ofSize: fontSize)
        self.unreadLabel.isHidden = message.isRead
        self.unreadLabel.layer.cornerRadius = self.unreadLabel.frame.size.height / 2
        self.unreadLabel.clipsToBounds = true
        self.unreadLabel.text = NSLocalizedString("Unread", comment:"")
    }
    
    func configureDateLabel(message: CarnivalMessage) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM YYYY"
        self.timeAgoLabel.text = dateFormatter.string(from: message.createdAt)
    }
    
    func configureGradient() {
        self.gradient.frame = self.contentView.bounds
        self.gradient.startPoint = CGPoint(x: 0.1, y: 0.0)
        self.gradient.endPoint = CGPoint(x: 0.9, y: 1)
        self.gradient.colors = [UIColor(red: 106.0 / 255.0, green: 106.0 / 255.0, blue: 106.0 / 255.0, alpha: 1).cgColor,
                                UIColor(red: 147.0 / 255.0, green: 147.0 / 255.0, blue: 147.0 / 255.0, alpha: 1).cgColor]
        self.contentView.layer.insertSublayer(self.gradient, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradient.frame = self.contentView.bounds
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let backgroundColor = self.unreadLabel.backgroundColor
        super.setSelected(selected, animated: animated)
        self.unreadLabel.backgroundColor = backgroundColor
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let backgroundColor = self.unreadLabel.backgroundColor
        super.setHighlighted(isSelected, animated: animated)
        self.unreadLabel.backgroundColor = backgroundColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutMargins = UIEdgeInsets.zero
        self.separatorInset = UIEdgeInsets.zero
    }
}
