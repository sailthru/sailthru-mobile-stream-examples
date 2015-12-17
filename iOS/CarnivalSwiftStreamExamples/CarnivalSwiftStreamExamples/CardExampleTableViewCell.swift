//
//  CardExampleTableViewCell.swift
//  CarnivalSwiftStreamExamples
//
//  Created by Sam Jarman on 12/15/15.
//  Copyright © 2015 Carnival Mobile. All rights reserved.
//

import UIKit

class CardExampleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: CarnivalLabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var unreadLabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var backingView: UIView!
    @IBOutlet weak var imageToTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backingViewToTopConstraint: NSLayoutConstraint!

    
    class func cellIdentifier() -> String {
        return "CardExampleTableViewCell"
    }
    
    func configureCell(message: CarnivalMessage, indexPath: NSIndexPath) {
        self.configureDateLabel(message)
        self.configureUnreadLabel(message)
        self.configureType(message)
        self.configureImage(message)
        self.configureText(message)
        self.configureBackingView(message, indexPath: indexPath)
    }
    
    func configureImage(message: CarnivalMessage) {
        guard let _ = message.imageURL else {
            self.imgHeight.constant = 0
            
            return
        }
        self.imgView?.sd_setImageWithURL(message.imageURL, placeholderImage: UIImage(named: "placeholder_image"))
        self.imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        self.imgView?.clipsToBounds = true
        self.imgHeight.constant = 265;
        
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
    
    func configureBackingView(message: CarnivalMessage, indexPath: NSIndexPath) {
        self.backingView?.layer.shadowColor = UIColor.grayColor().CGColor
        self.backingView?.layer.shadowOffset = CGSizeMake(0, 1)
        self.backingView.layer.shadowRadius = 1.0;
        self.backingView.layer.shadowOpacity = 0.5;

        if indexPath.row == 0 {
            self.imageToTopConstraint.constant = 0;
            self.backingViewToTopConstraint.constant = 0;
        }
        else {
            self.imageToTopConstraint.constant = -8;
            self.backingViewToTopConstraint.constant = -8;
        }
        
        self.setNeedsUpdateConstraints();
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsetsZero
        self.separatorInset = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false;
    }
}