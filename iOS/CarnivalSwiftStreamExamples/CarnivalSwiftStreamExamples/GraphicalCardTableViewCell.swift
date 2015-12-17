//
//  GraphicalCardTableViewCell.swift
//  CarnivalSwiftStreamExamples
//
//  Created by Sam Jarman on 14/09/15.
//  Copyright (c) 2015 Carnival Mobile. All rights reserved.
//

import UIKit

class GraphicalCardTableViewCell: TextCardTableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var timeBackground: UIView!
    
    override class func cellIdentifier() -> String {
        return "GraphicalCardTableViewCell"
    }
    
    override func configureCell(message: CarnivalMessage) {
        super.configureCell(message)
        if message.imageURL != nil {
            self.imgView.sd_setImageWithURL(message.imageURL, placeholderImage: UIImage(named: "placeholder_image"))
            self.imgView.contentMode = UIViewContentMode.ScaleAspectFill
            self.imgView.clipsToBounds = true
        }
        self.timeBackground.layer.cornerRadius = 4.0
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
}