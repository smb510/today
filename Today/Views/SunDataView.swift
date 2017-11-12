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
    for i in 0...8 {
      let path = UIBezierPath(rect: CGRect(origin: origin, size: sizes[i]))
      colors[i].setFill()
      path.fill()
      origin.y += sizes[i].height
    }
  }
  
  func getHeights() -> [CGSize]? {
    if sunData != nil {
      return sunData?.getSizes(width: self.frame.width, height: self.frame.height)
    }
    return Array(repeating:CGSize(width: self.frame.width, height: self.frame.height / 9), count:9)
  }
  
  
  
}
