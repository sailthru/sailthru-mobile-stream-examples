//
//  RoundedButton.swift
//  CarnivalSwiftStreamExamples
//
//  Created by Sam Jarman on 1/10/15.
//  Copyright (c) 2015 Carnival Mobile. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    override func drawRect(rect: CGRect) {
        let insets = UIEdgeInsetsMake(0, 22.5, 0, 22.5)
        let buttonBg = UIImage(named: "button_bg")?.resizableImageWithCapInsets(insets)
        let buttonBgPressed = UIImage(named: "button_bg_pressed")?.resizableImageWithCapInsets(insets)
        self.setBackgroundImage(buttonBg, forState: UIControlState.Normal)
        self.setBackgroundImage(buttonBgPressed, forState: UIControlState.Highlighted)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
    }
}
