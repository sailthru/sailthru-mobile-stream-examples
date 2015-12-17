//
//  HomeViewController.swift
//  CarnivalSwiftStreamExamples
//
//  Created by Sam Jarman on 12/14/15.
//  Copyright © 2015 Carnival Mobile. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
}