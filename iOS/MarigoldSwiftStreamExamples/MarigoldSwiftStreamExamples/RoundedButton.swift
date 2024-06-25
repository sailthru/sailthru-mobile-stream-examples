//
//  RoundedButton.swift
//  MarigoldSwiftStreamExamples
//
//  Created by Sam Jarman on 1/10/15.
//  Copyright (c) 2015 Marigold Mobile. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    override func draw(_ rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 22.5, bottom: 0, right: 22.5)
        let buttonBg = UIImage(named: "button_bg")?.resizableImage(withCapInsets: insets)
        let buttonBgPressed = UIImage(named: "button_bg_pressed")?.resizableImage(withCapInsets: insets)
        self.setBackgroundImage(buttonBg, for: [])
        self.setBackgroundImage(buttonBgPressed, for: UIControl.State.highlighted)
        self.setTitleColor(UIColor.white, for: UIControl.State.highlighted)
    }
}
