//
//  BasicListStreamTableViewCell.swift
//  CarnivalSwiftStreamExamples
//
//  Created by Sam Jarman on 14/09/15.
//  Copyright (c) 2015 Carnival Mobile. All rights reserved.
//

import Foundation
import UIKit

class BasicListStreamTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var unreadLabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var imageOffset: NSLayoutConstraint!
    
    class func cellIdentifier() -> String {
        return "BasicListStreamTableViewCell"
    }
    
    func configureCell(message: CarnivalMessage) {
        self.configureDateLabel(message)
        self.configureUnreadLabel(message)
        self.configureTitleLabel(message)
        self.configureType(message)
        self.configureImage(message)
    }
    
    func configureImage(message: CarnivalMessage) {
        if message.imageURL != nil {
            self.imgView?.sd_setImageWithURL(message.imageURL, placeholderImage: UIImage(named:"placeholder_image"))
            self.imgView?.contentMode = UIViewContentMode.ScaleAspectFill
            self.imgView?.clipsToBounds = true
            self.imageOffset.constant = 0
        }
        else {
            self.imageOffset.constant = ScreenSizeHelper.isIphone5orLess() ? -90 : -110
        }
    }
    
    func configureType(message: CarnivalMessage) {
        switch message.type {
        case .Image:
            self.typeLabel.text = NSLocalizedString("Image", comment:"")
            self.typeImage.image = UIImage(named: "camera_icon")
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
        
        var fontSize = ScreenSizeHelper.isIphone5orLess() ? ScreenSizeHelper.textSmall() : ScreenSizeHelper.textNormal()
        self.typeLabel.font = UIFont.systemFontOfSize(fontSize)
    }
    
    func configureTitleLabel(message:CarnivalMessage) {
        var fontSize: CGFloat = ScreenSizeHelper.isIphone5orLess() ? 15 : 18
        self.titleTextView.textContainerInset = UIEdgeInsetsZero
        self.titleTextView.textContainer.lineFragmentPadding = 0
        self.titleTextView.text = message.title
        self.titleTextView.textColor = UIColor(red: 26.0/255.0, green: 150.0/255.0, blue: 226.0/255.0, alpha: 1)
        self.titleTextView.font = UIFont.boldSystemFontOfSize(fontSize)
    }
    
    func configureUnreadLabel(message:CarnivalMessage) {
        self.unreadLabel.hidden = message.read
        self.unreadLabel.clipsToBounds = true
        self.unreadLabel.text = NSLocalizedString("Unread", comment:"")
        var fontSize = ScreenSizeHelper.isIphone5orLess() ? ScreenSizeHelper.textSmall() : ScreenSizeHelper.textNormal()
        self.unreadLabel.font = UIFont.systemFontOfSize(fontSize)
        self.unreadLabel.layer.cornerRadius = self.unreadLabel.frame.size.height/2

    }

    func configureDateLabel(message: CarnivalMessage) {
        self.timeAgoLabel.text = NSDate.timeAgoSinceDate(message.createdAt)
        var fontSize = ScreenSizeHelper.isIphone5orLess() ? ScreenSizeHelper.textSmall() : ScreenSizeHelper.textNormal()
        self.timeAgoLabel.font = UIFont.systemFontOfSize(fontSize)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        var backgroundColor = self.unreadLabel.backgroundColor
        super.setSelected(selected, animated: animated)
        self.unreadLabel.backgroundColor = backgroundColor
    }
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        var backgroundColor = self.unreadLabel.backgroundColor
        super.setHighlighted(selected, animated: animated)
        self.unreadLabel.backgroundColor = backgroundColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsetsZero
        self.separatorInset = UIEdgeInsetsZero
    }
}
