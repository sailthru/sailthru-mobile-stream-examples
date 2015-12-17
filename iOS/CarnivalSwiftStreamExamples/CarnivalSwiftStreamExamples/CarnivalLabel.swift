//
//  CarnivalLabel.swift
//  CarnivalSwiftStreamExamples
//
//  Created by Sam Jarman on 14/09/15.
//  Copyright (c) 2015 Carnival Mobile. All rights reserved.
//

import UIKit

class CarnivalLabel: UILabel {
    
    override var bounds: CGRect {
        didSet  {
            if (self.numberOfLines == 0 && bounds.size.width != self.preferredMaxLayoutWidth) {
                self.preferredMaxLayoutWidth = self.bounds.size.width
                self.invalidateIntrinsicContentSize()
            }
        }
    }
}