//
//  CGFloat + CGSize.swift
//  Today
//
//  Created by Scottie Biddle on 10/17/17.
//  Copyright © 2017 Scottie Biddle. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
  init(x: CGFloat, y: CGFloat, size: CGSize) {
    self.init(x: x, y:y, width: size.width, height: size.height)
  }
}
