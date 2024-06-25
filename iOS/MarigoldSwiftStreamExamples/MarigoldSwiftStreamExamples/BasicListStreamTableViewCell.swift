//
//  BasicListStreamTableViewCell.swift
//  MarigoldSwiftStreamExamples
//
//  Created by Sam Jarman on 14/09/15.
//  Copyright (c) 2015 Marigold Mobile. All rights reserved.
//

import Foundation
import UIKit
import Marigold

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
    
    func configureCell(message: MARMessage) {
        self.configureDateLabel(message: message)
        self.configureUnreadLabel(message: message)
        self.configureTitleLabel(message: message)
        self.configureType(message: message)
        self.configureImage(message: message)
    }
    
    func configureImage(message: MARMessage) {
        if message.imageURL != nil {
            self.imgView?.sd_setImage(with: message.imageURL, placeholderImage: UIImage(named: "placeholder_image"))
            self.imgView?.contentMode = UIView.ContentMode.scaleAspectFill
            self.imgView?.clipsToBounds = true
            self.imageOffset.constant = 0
        }
        else {
            self.imageOffset.constant = ScreenSizeHelper.isIphone5orLess() ? -90 : -110
        }
    }
    
    func configureType(message: MARMessage) {
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
        case .standardPush:
            self.typeLabel.text = NSLocalizedString("Text", comment:"")
            self.typeImage.image = UIImage(named: "text_icon")
        default:
            self.typeLabel.text = NSLocalizedString("Other", comment:"")
            self.typeImage.image = UIImage(named: "text_icon")
        }
        
        let fontSize = ScreenSizeHelper.isIphone5orLess() ? ScreenSizeHelper.textSmall() : ScreenSizeHelper.textNormal()
        self.typeLabel.font = UIFont.systemFont(ofSize: fontSize)
    }
    
    func configureTitleLabel(message: MARMessage) {
        let fontSize: CGFloat = ScreenSizeHelper.isIphone5orLess() ? 15 : 18
        self.titleTextView.textContainerInset = UIEdgeInsets.zero
        self.titleTextView.textContainer.lineFragmentPadding = 0
        self.titleTextView.text = message.title
        self.titleTextView.textColor = UIColor(red: 26.0 / 255.0, green: 150.0 / 255.0, blue: 226.0 / 255.0, alpha: 1)
        self.titleTextView.font = UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    func configureUnreadLabel(message: MARMessage) {
        self.unreadLabel.isHidden = message.isRead
        self.unreadLabel.clipsToBounds = true
        self.unreadLabel.text = NSLocalizedString("Unread", comment:"")
        let fontSize = ScreenSizeHelper.isIphone5orLess() ? ScreenSizeHelper.textSmall() : ScreenSizeHelper.textNormal()
        self.unreadLabel.font = UIFont.systemFont(ofSize: fontSize)
        self.unreadLabel.layer.cornerRadius = self.unreadLabel.frame.size.height / 2

    }

    func configureDateLabel(message: MARMessage) {
        self.timeAgoLabel.text = NSDate.timeAgo(since: message.createdAt)
        let fontSize = ScreenSizeHelper.isIphone5orLess() ? ScreenSizeHelper.textSmall() : ScreenSizeHelper.textNormal()
        self.timeAgoLabel.font = UIFont.systemFont(ofSize: fontSize)
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
