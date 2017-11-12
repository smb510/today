//
//  SunData+Helper.swift
//  Today
//
//  Created by Scottie Biddle on 11/11/17.
//  Copyright © 2017 Scottie Biddle. All rights reserved.
//

import Foundation
import UIKit

extension SunData {
  
  static let NIGHT = UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.0)
  static let ASTRO = UIColor(red:0.00, green:0.25, blue:0.50, alpha:1.0)
  static let NAUT = UIColor(red:0.00, green:0.00, blue:1.00, alpha:1.0)
  static let CIV = UIColor(red:0.00, green:0.50, blue:1.00, alpha:1.0)
  static let DAY = UIColor(red:1.00, green:1.00, blue:0.40, alpha:1.0)
  
  class func getColors() -> [UIColor] {
    return [NIGHT, ASTRO, NAUT, CIV, DAY, CIV, NAUT, ASTRO, NIGHT]
  }
  
  func getSizes(width: CGFloat, height: CGFloat) -> [CGSize] {
    let startNightSeconds = self.astroTwilightBegin!.timeIntervalSince(self.date!)
    let nightStartSize = getProportionalSize(width: width, height: height, duration: startNightSeconds)
    let startAstroSeconds = self.nauticalTwilightBegin!.timeIntervalSince(self.astroTwilightBegin!)
    let astroStartSize = getProportionalSize(width: width, height: height, duration: startAstroSeconds)
    let startNauticalSeconds = self.civilTwilightBegin!.timeIntervalSince(self.nauticalTwilightBegin!)
    let nauticalStartSize = getProportionalSize(width: width, height: height, duration: startNauticalSeconds)
    let startCivilSeconds = self.sunrise!.timeIntervalSince(self.civilTwilightBegin!)
    let civilStartSize = getProportionalSize(width: width, height: height, duration: startCivilSeconds)
    let daylightSeconds = self.sunset!.timeIntervalSince(self.sunrise!)
    let daylightSize = getProportionalSize(width: width, height: height, duration: daylightSeconds)
    let endCivilSeconds = self.civilTwilightEnd!.timeIntervalSince(self.sunset!)
    let endCivilSize = getProportionalSize(width: width, height: height, duration: endCivilSeconds)
    let endNauticalSeconds = self.nauticalTwilightEnd!.timeIntervalSince(self.civilTwilightEnd!)
    let endNauticalSize = getProportionalSize(width: width, height: height, duration: endNauticalSeconds)
    let endAstronomicalSeconds = self.astroTwilightEnd!.timeIntervalSince(self.nauticalTwilightEnd!)
    let endAstronomicalSize = getProportionalSize(width: width, height: height, duration: endAstronomicalSeconds)
    var sizes =  [nightStartSize, astroStartSize, nauticalStartSize, civilStartSize,
    daylightSize, endCivilSize, endNauticalSize, endAstronomicalSize]
    let totalHeightSoFar = sizes.map { $0.height}.reduce(0, {$0 + $1})
    sizes.append(CGSize(width: width, height: height - totalHeightSoFar))
    return sizes
  }
  
  func getProportionalSize(width: CGFloat, height: CGFloat, duration: Double) -> CGSize {
    let fraction: Double = duration / 86400
    return CGSize(width: width, height: CGFloat(fraction) * height)
  }
  
  
}

