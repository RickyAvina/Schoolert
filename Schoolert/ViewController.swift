//
//  ViewController.swift
//  Schoolert
//
//  Created by Ricky Avina on 6/16/17.
//  Copyright © 2017 InternTeam. All rights reserved.
//

import UIKit
import SwiftSoup
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        returnHomePage(username: "788120", password: "ea091900")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
