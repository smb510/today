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
  
  var touchDown: CGPoint?
  
  override func draw(_ rect: CGRect) {
    let colors = SunData.getColors()
    let sizes = getHeights()!
    var origin = CGPoint(x: 0, y:0)
    for (i, size)in sizes.enumerated() {
      let rect = CGRect(origin: origin, size: size)
      let path = UIBezierPath(rect: rect)
      colors[i].setFill()
      path.fill()
      if touchDown != nil && rect.contains(touchDown!) {
        UIColor.red.setStroke()
        path.lineCapStyle = CGLineCap.butt
        path.lineWidth = 4
        path.stroke()
      }
      origin.y += size.height
    }
  }
  
  func getHeights() -> [CGSize]? {
    if sunData != nil {
      return sunData?.getSizes(width: self.frame.width, height: self.frame.height)
    }
    return Array(repeating:CGSize(width: self.frame.width, height: self.frame.height / 9), count:9)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchDown = touches.first?.preciseLocation(in: self)
    self.setNeedsDisplay()
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchDown = touches.first?.preciseLocation(in: self)
    self.setNeedsDisplay()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchDown = nil
    self.setNeedsDisplay()
  }
}
