//
//  RulerView.swift
//  Today
//
//  Created by Scottie Biddle on 11/11/17.
//  Copyright © 2017 Scottie Biddle. All rights reserved.
//

import Foundation
import UIKit

class RulerView : UIView {
  
  let CORNER_RADII = CGSize(width:2, height: 2)
  let TICK_HEIGHT = CGFloat(4)
  
  override func draw(_ rect: CGRect) {
    let path = UIBezierPath()
    for i in 0...24 {
      path.append(getPathForHour(hour: i))
    }
    path.append(positionNow())
  }
  
  func getPathForHour(hour: Int) -> UIBezierPath {
    let height = self.frame.height
    let spacing = height / 24
    let tickSize = getTickSize(hour: hour)
    let origin = CGPoint(x: self.frame.width  - tickSize.width, y: spacing * CGFloat(hour))
    let path = UIBezierPath(roundedRect: CGRect(origin: origin, size: tickSize), byRoundingCorners: .allCorners, cornerRadii: CORNER_RADII)
    UIColor.white.setFill()
    path.fill()
    return path
  }
  
  func getTickSize(hour: Int) -> CGSize {
    var scalingFactor = 0.25
    if hour % 12 == 0 {
      scalingFactor = 1
    } else if hour % 6 == 0 {
      scalingFactor = 0.75
    } else if hour % 3 == 0 {
      scalingFactor = 0.5
    }
    return CGSize(width: self.frame.width * CGFloat(scalingFactor), height: TICK_HEIGHT)
  }
  
  func positionNow() -> UIBezierPath {
    let rightNow = Date()
    let components = Calendar.autoupdatingCurrent.dateComponents(in: TimeZone.current, from: rightNow)
    let seconds  = components.hour! * 3600 + components.minute! * 60
    let fractionOfDay = Double(seconds) / 86400
    let origin = CGPoint(x: 0, y: CGFloat(fractionOfDay) * self.frame.height)
    let size = CGSize(width: self.frame.width, height: TICK_HEIGHT / 2)
    let path = UIBezierPath(roundedRect: CGRect(origin: origin, size: size), byRoundingCorners: .allCorners,
                            cornerRadii: CORNER_RADII)
    UIColor.red.setFill()
    path.fill()
    return path
  }
  
}
