//
//  StandardTableViewCell.swift
//  CarnivalSwiftStreamExamples
//
//  Created by Sam Jarman on 12/14/15.
//  Copyright © 2015 Carnival Mobile. All rights reserved.
//

import UIKit

class StandardTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: CarnivalLabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var unreadLabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var backingView: UIView!
    
    class func cellIdentifier() -> String {
        return "StandardTableViewCell"
    }
    
    func configureCell(message: CarnivalMessage) {
        self.configureDateLabel(message)
        self.configureUnreadLabel(message)
        self.configureType(message)
        self.configureImage(message)
        self.configureText(message)
    }
    
    func configureImage(message: CarnivalMessage) {
        if message.imageURL != nil {
            self.imgView?.sd_setImageWithURL(message.imageURL, placeholderImage: UIImage(named: "placeholder_image"))
            self.imgView?.contentMode = UIViewContentMode.ScaleAspectFill
            self.imgView?.clipsToBounds = true
            self.imgHeight.constant = 265;
        }
        else {
            self.imgHeight.constant = 0
        }
    }
    
    func configureType(message: CarnivalMessage) {
        switch message.type {
        case .Image:
            self.typeLabel.text = NSLocalizedString("Image", comment:"")
            self.typeImage.image = UIImage(named: "image_icon")
        case .Link:
            self.typeLabel.text = NSLocalizedString("Link", comment:"")
            self.typeImage.image = UIImage(named: "link_icon")
        case .Video:
            self.typeLabel.text = NSLocalizedString("Video", comment:"")
            self.typeImage.image = UIImage(named: "video_icon")
        case .Text:
            self.typeLabel.text = NSLocalizedString("Text", comment:"")
            self.typeImage.image = UIImage(named: "text_icon")
        case .FakeCall:
            self.typeLabel.text = NSLocalizedString("Image", comment:"")
            self.typeImage.image = UIImage(named: "video_icon")
        default:
            self.typeLabel.text = NSLocalizedString("Other", comment:"")
            self.typeImage.image = UIImage(named: "text_icon")
        }
    }

    func configureUnreadLabel(message: CarnivalMessage) {
        self.unreadLabel.hidden = message.read
        self.unreadLabel.clipsToBounds = true
        self.unreadLabel.text = NSLocalizedString("Unread", comment:"")
        self.unreadLabel.layer.cornerRadius = self.unreadLabel.frame.size.height / 2
    }
    
    func configureDateLabel(message: CarnivalMessage) {
        self.timeAgoLabel.text = NSDate.timeAgoSinceDate(message.createdAt)
    }
    
    func configureText(message: CarnivalMessage) {
        self.titleLabel.text = message.title;
        self.bodyLabel.text = message.text;
        self.bodyLabel.sizeToFit()
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        if highlighted {
            self.backingView.backgroundColor = UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 241.0 / 255.0, alpha: 1)
        }
        else {
            self.backingView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsetsZero
        self.separatorInset = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false;
    }
}