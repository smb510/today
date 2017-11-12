//
//  ViewController.swift
//  Today
//
//  Created by Scottie Biddle on 10/17/17.
//  Copyright © 2017 Scottie Biddle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var totalHeight: CGFloat?
  var totalWidth: CGFloat?
  
  var appDelegate : AppDelegate?
  
  @IBOutlet weak var today: SunDataView!
  @IBOutlet weak var date: UILabel!
  @IBOutlet weak var dayHeader: UILabel!
  
  let rightNow = Date()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.appDelegate = UIApplication.shared.delegate as? AppDelegate
    totalHeight = self.view.frame.size.height
    totalWidth = self.view.frame.size.width
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .none
    dateFormatter.dateFormat = "dd"
    date.text = dateFormatter.string(from: rightNow)
    dateFormatter.dateFormat = "MMM YYYY"
    dayHeader.text = dateFormatter.string(from: rightNow).uppercased()
    appDelegate?.sunDataController?.fetchToday(completionHandler: ({(sunData) in
      DispatchQueue.main.sync {
       self.today.sunData = sunData
      }}))
  }
}

