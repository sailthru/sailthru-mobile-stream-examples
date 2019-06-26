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
        self.configureDateLabel(message: message)
        self.configureUnreadLabel(message: message)
        self.configureType(message: message)
        self.configureImage(message: message)
        self.configureText(message: message)
        self.configureBackingView(message: message, indexPath: indexPath)
    }
    
    func configureImage(message: CarnivalMessage) {
        guard let _ = message.imageURL else {
            self.imgHeight.constant = 0
            
            return
        }
        self.imgView?.sd_setImage(with: message.imageURL, placeholderImage: UIImage(named: "placeholder_image"))
        self.imgView?.contentMode = UIViewContentMode.scaleAspectFill
        self.imgView?.clipsToBounds = true
        self.imgHeight.constant = 265;
        
    }
    
    func configureType(message: CarnivalMessage) {
        switch message.type {
        case .image:
            self.typeLabel.text = NSLocalizedString("Image", comment:"")
            self.typeImage.image = UIImage(named: "image_icon")
        case .link:
            self.typeLabel.text = NSLocalizedString("Link", comment:"")
            self.typeImage.image = UIImage(named: "link_icon")
        case .video:
            self.typeLabel.text = NSLocalizedString("Video", comment:"")
            self.typeImage.image = UIImage(named: "video_icon")
        case .text:
            self.typeLabel.text = NSLocalizedString("Text", comment:"")
            self.typeImage.image = UIImage(named: "text_icon")
        case .fakeCall:
            self.typeLabel.text = NSLocalizedString("Image", comment:"")
            self.typeImage.image = UIImage(named: "video_icon")
        default:
            self.typeLabel.text = NSLocalizedString("Other", comment:"")
            self.typeImage.image = UIImage(named: "text_icon")
        }
    }
    
    func configureUnreadLabel(message: CarnivalMessage) {
        self.unreadLabel.isHidden = message.isRead
        self.unreadLabel.clipsToBounds = true
        self.unreadLabel.text = NSLocalizedString("Unread", comment:"")
        self.unreadLabel.layer.cornerRadius = self.unreadLabel.frame.size.height / 2
    }
    
    func configureDateLabel(message: CarnivalMessage) {
        self.timeAgoLabel.text = NSDate.timeAgo(since: message.createdAt)
    }
    
    func configureText(message: CarnivalMessage) {
        self.titleLabel.text = message.title;
        
        if let bodyText = message.htmlText  {
            self.bodyLabel.setHtmlFromString(html: bodyText);
        }
        
        self.bodyLabel.sizeToFit()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.backingView.backgroundColor = UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 241.0 / 255.0, alpha: 1)
        }
        else {
            self.backingView.backgroundColor = UIColor.white
        }
    }
    
    func configureBackingView(message: CarnivalMessage, indexPath: NSIndexPath) {
        self.backingView?.layer.shadowColor = UIColor.gray.cgColor
        self.backingView?.layer.shadowOffset = CGSize(width: 0, height: 1)
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
        self.layoutMargins = UIEdgeInsets.zero
        self.separatorInset = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false;
    }
}
