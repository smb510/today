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
  
  @IBOutlet weak var nightStart: UIView!
  @IBOutlet weak var nightEnd: UIView!
  @IBOutlet weak var astroStart: UIView!
  @IBOutlet weak var astroEnd: UIView!
  @IBOutlet weak var nauticalStart: UIView!
  @IBOutlet weak var nauticalEnd: UIView!
  @IBOutlet weak var civilStart: UIView!
  @IBOutlet weak var civilEnd: UIView!
  @IBOutlet weak var daylight: UIView!
  @IBOutlet weak var now: UIView!
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
    positionNow()
    appDelegate?.sunDataController?.downloadData(completionHandler: ({(sunData) in
      DispatchQueue.main.sync {
        self.handleDate(sunData: sunData)
      }}))
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func positionNow() {
    let components = Calendar.autoupdatingCurrent.dateComponents(in: TimeZone.current, from: rightNow)
    let seconds  = components.hour! * 3600 + components.minute! * 60
    let fractionOfDay = Double(seconds) / 86400
    now.layer.cornerRadius = CGFloat(7.5)
    UIView.animate(withDuration: 3.0) {
      self.now.frame = CGRect(x: self.totalWidth! * 0.66, y: CGFloat(fractionOfDay) * self.totalHeight!, width: 15, height: 15)
    }
  }
  
  func handleDate(sunData: SunData?) {
    if let today = sunData {
      let startNightSeconds = today.astroTwilightBegin!.timeIntervalSince(today.date!)
      let nightStartSize = getProportionalSize(duration: startNightSeconds)
      let startAstroSeconds = today.nauticalTwilightBegin!.timeIntervalSince(today.astroTwilightBegin!)
      let astroStartSize = getProportionalSize(duration: startAstroSeconds)
      let startNauticalSeconds = today.civilTwilightBegin!.timeIntervalSince(today.nauticalTwilightBegin!)
      let nauticalStartSize = getProportionalSize(duration: startNauticalSeconds)
      let startCivilSeconds = today.sunrise!.timeIntervalSince(today.civilTwilightBegin!)
      let civilStartSize = getProportionalSize(duration: startCivilSeconds)
      let daylightSeconds = today.sunset!.timeIntervalSince(today.sunrise!)
      let daylightSize = getProportionalSize(duration: daylightSeconds)
      let endCivilSeconds = today.civilTwilightEnd!.timeIntervalSince(today.sunset!)
      let endCivilSize = getProportionalSize(duration: endCivilSeconds)
      let endNauticalSeconds = today.nauticalTwilightEnd!.timeIntervalSince(today.civilTwilightEnd!)
      let endAstronomicalSeconds = today.astroTwilightEnd!.timeIntervalSince(today.nauticalTwilightEnd!)
      UIView.animate(withDuration: 2.0, animations: {
        self.nightStart.frame = CGRect(x: 0, y: 0, size: nightStartSize)
        self.astroStart.frame = CGRect(x:0, y: self.nightStart.frame.maxY, size: astroStartSize)
        self.nauticalStart.frame = CGRect(x: 0, y: self.astroStart.frame.maxY, size: nauticalStartSize)
        self.civilStart.frame = CGRect(x: 0, y: self.nauticalStart.frame.maxY, size: civilStartSize)
        self.daylight.frame = CGRect(x: 0, y: self.civilStart.frame.maxY, size: daylightSize)
        self.civilEnd.frame = CGRect(x: 0, y: self.daylight.frame.maxY, size: endCivilSize)
        self.nauticalEnd.frame = CGRect(x: 0, y: self.civilEnd.frame.maxY, size: self.getProportionalSize(duration: endNauticalSeconds))
        self.astroEnd.frame = CGRect(x: 0, y: self.nauticalEnd.frame.maxY, size: self.getProportionalSize(duration: endAstronomicalSeconds))
        self.nightEnd.frame = CGRect(x: 0, y: self.astroEnd.frame.maxY, width: self.totalWidth!, height: self.totalHeight! - self.astroEnd.frame.maxY)
        
      })
    }
  }
  
  func getProportionalSize(duration: Double) -> CGSize {
    let fraction: Double = duration / 86400
    return CGSize(width: totalWidth!, height: CGFloat(fraction) * totalHeight!)
  }
}

