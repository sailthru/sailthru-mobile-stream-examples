//
//  GraphicalCardTableViewCell.swift
//  MarigoldSwiftStreamExamples
//
//  Created by Sam Jarman on 14/09/15.
//  Copyright (c) 2015 Marigold Mobile. All rights reserved.
//

import UIKit

class GraphicalCardTableViewCell: TextCardTableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var timeBackground: UIView!
    
    override class func cellIdentifier() -> String {
        return "GraphicalCardTableViewCell"
    }
    
    override func configureCell(message: MARMessage) {
        super.configureCell(message: message)
        if message.imageURL != nil {
            self.imgView.sd_setImage(with: message.imageURL, placeholderImage: UIImage(named: "placeholder_image"))
            self.imgView.contentMode = UIView.ContentMode.scaleAspectFill
            self.imgView.clipsToBounds = true
        }
        self.timeBackground.layer.cornerRadius = 4.0
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
}
