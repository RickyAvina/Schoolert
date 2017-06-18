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

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        returnHomePage(username: "788120", password: "ea091900")
    }
    
    private func returnHomePage(username: String, password: String) {
        var homePage: Document?
        
        Alamofire.request("https://whs-seq-ca.schoolloop.com/portal/login", method: .get).validate().responseData { (reponse) in
            
            if let data = reponse.result.value {
                do {
                    let html = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String
                    let doc: Document = try SwiftSoup.parse(html!)
                    let form_data_id = try! (doc.select("input[name=\"form_data_id\"]").first()?.attr("value"))!
                    
                    let parameters: Parameters = ["login_name": username, "password": password, "form_data_id": form_data_id, "redirect": "", "forward": "", "login_form_reverse": "", "sort": "", "reverse": "", "login_form_sort": "", "event_override": "login", "login_form_filter": "", "login_form_letter": "", "return_url": "", "login_form_page_index": "", "login_form_page_item_count": ""]
                    
                    Alamofire.request("https://whs-seq-ca.schoolloop.com/portal/login?etarget=login_form", method: .post, parameters: parameters).validate().responseData(completionHandler: { (reponse) in
                        
                        if let data = reponse.result.value {
                            do {
                                let html = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String
                                homePage = try SwiftSoup.parse(html!)
                                let text = try homePage?.text()
                                print("Doc:\n\n\(text)")
                            } catch { print("Error") }
                        }
                    })
                } catch { print("Error") }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
