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
    
    private func returnHomePage(username: String, password: String) {
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
                                let document = try SwiftSoup.parse(html!)
                                self.useDocument(document: document)
                            } catch { print("Error") }
                        }
                    })
                } catch { print("Error") }
            }
        }
    }
    
    func useDocument(document: Document){
        var courses = [Course]()
        
        do {
            let srcs: Elements = try document.select("a[data-track-link='Academic Classroom']")
            for src in srcs {
                let course = Course()
                course.name = try? src.text()
                
                let href: String = try! src.attr("href")
                course.periodId = Int(href.components(separatedBy: "period_id=")[1].components(separatedBy: "&").first!)
                course.groupId = Int(href.components(separatedBy: "group_id=")[1])
                courses.append(course)
            }
        } catch { print("Can't find classes!")  }
        
        for course in courses {
            if course.isValid() {
                print("\(course.name!)\nPeriod Id: \(course.periodId!)\nGroup Id: \(course.groupId!)\n\n")
                getGrades(course: course)
            }
        }
    }
    
    func getGrades(course: Course){
        Alamofire.request("https://whs-seq-ca.schoolloop.com/progress_report/progress_chart_data?id=1406781206449&period_id=\(course.periodId!)", method: .get).responseJSON { response in
            
            if let data = response.data {
                let grades = [Grade]()
                
                let json = JSON(data: data)
                for item in json.arrayValue {
                    let grade = Grade()
                    grade.percentage = item["percentage"].doubleValue
                    grade.trendScore = item["trendScore"].doubleValue
                    grade.date = item["date"].stringValue.detectDates?.first
                }
            }
        }
    }
    
    //    func useText(text: String){
    //        do {
    //
    //        } catch { print("Can't find classes") }
    //
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
