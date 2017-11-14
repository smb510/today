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
  var sunData : SunData?
  
  @IBOutlet weak var today: SunDataView!
  @IBOutlet weak var date: UILabel!
  @IBOutlet weak var dayHeader: UILabel!
  @IBOutlet weak var nextTransition: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let rightNow = Date()
    self.appDelegate = UIApplication.shared.delegate as? AppDelegate
    totalHeight = self.view.frame.size.height
    totalWidth = self.view.frame.size.width
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .none
    dateFormatter.dateFormat = "dd"
    date.text = dateFormatter.string(from: rightNow)
    dateFormatter.dateFormat = "MMM YYYY"
    dayHeader.text = dateFormatter.string(from: rightNow).uppercased()
    appDelegate?.sunDataController?.fetchToday(completionHandler: {(sunData) in
      self.sunData = sunData
      self.today.sunData = sunData
      self.setNextTransition()
    })
  }
  
  func setNextTransition() {
    let now = Date()
    if sunData?.sunrise?.compare(now) == .orderedDescending {
      let sunrise = sunData!.sunrise!
      let timeInterval = sunrise.timeIntervalSince(now)
      nextTransition.text = getTransitionString(eventString: "Sunrise", interval: timeInterval)
    } else if sunData?.sunset?.compare(now) == .orderedDescending {
      let sunset = sunData!.sunset!
      let timeInterval = sunset.timeIntervalSince(now)
      nextTransition.text = getTransitionString(eventString: "Sunset", interval: timeInterval)
    }  else if sunData?.sunset?.compare(now) == .orderedAscending
      || sunData?.sunset?.compare(now) == .orderedSame {
      nextTransition.text = "Darkness reigns until tomorrow."
    }
  }
  
  func getTransitionString(eventString: String, interval: TimeInterval) -> String {
    let hours = Int(interval / 3600)
    let minutes = Int(interval.truncatingRemainder(dividingBy: 3600) / 60)
    return String.localizedStringWithFormat("%@ approaches in %dh %dm", eventString, hours, minutes)
  }
}

