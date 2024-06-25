//
//  MarigoldLabel.swift
//  MarigoldSwiftStreamExamples
//
//  Created by Sam Jarman on 14/09/15.
//  Copyright (c) 2015 Marigold Mobile. All rights reserved.
//

import UIKit

class MarigoldLabel: UILabel {
    
    override var bounds: CGRect {
        didSet  {
            if (self.numberOfLines == 0 && bounds.size.width != self.preferredMaxLayoutWidth) {
                self.preferredMaxLayoutWidth = self.bounds.size.width
                self.invalidateIntrinsicContentSize()
            }
        }
    }
}
