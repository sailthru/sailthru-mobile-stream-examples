//
//  RoundedButton.swift
//  CarnivalSwiftStreamExamples
//
//  Created by Sam Jarman on 1/10/15.
//  Copyright (c) 2015 Carnival Mobile. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    override func draw(_ rect: CGRect) {
        let insets = UIEdgeInsetsMake(0, 22.5, 0, 22.5)
        let buttonBg = UIImage(named: "button_bg")?.resizableImage(withCapInsets: insets)
        let buttonBgPressed = UIImage(named: "button_bg_pressed")?.resizableImage(withCapInsets: insets)
        self.setBackgroundImage(buttonBg, for: [])
        self.setBackgroundImage(buttonBgPressed, for: UIControlState.highlighted)
        self.setTitleColor(UIColor.white, for: UIControlState.highlighted)
    }
}
