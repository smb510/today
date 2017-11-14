//
//  SunDataView.swift
//  Today
//
//  Created by Scottie Biddle on 11/11/17.
//  Copyright © 2017 Scottie Biddle. All rights reserved.
//

import Foundation
import UIKit

class SunDataView : UIView {
  
  var sunData: SunData? {
    didSet{
      self.setNeedsDisplay()
    }
  }
  
  
  override func draw(_ rect: CGRect) {
    let colors = SunData.getColors()
    let sizes = getHeights()!
    var origin = CGPoint(x: 0, y:0)
    for (i, size)in sizes.enumerated() {
      let rect = CGRect(origin: origin, size: size)
      let path = UIBezierPath(rect: rect)
      colors[i].setFill()
      path.fill()
      origin.y += size.height
    }
  }
  
  func getGradients() -> CAGradientLayer? {
    let intervals = sunData!.getIntervals()
    let colors = SunData.getColors()
    let gradient = CAGradientLayer()
    gradient.frame = self.frame
    gradient.colors = colors.map({$0.cgColor})
    gradient.locations = intervals as [NSNumber]
    return gradient
  }
  
  func getHeights() -> [CGSize]? {
    if sunData != nil {
      return sunData!.getSizes(width: self.frame.width, height: self.frame.height)
    }
    return Array(repeating:CGSize(width: self.frame.width, height: self.frame.height / 9), count:9)
  }
}
