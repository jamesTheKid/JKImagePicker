//  Created by James KUMAKO on 2/6/18.
//  Copyright © 2018 Fahid Attique. All rights reserved.
//

import UIKit


extension NSLayoutConstraint: NSCopying{
  
  public func copy(with zone: NSZone? = nil) -> Any {
    
    let newConstraint = NSLayoutConstraint(item: self.firstItem,
                                           attribute: self.firstAttribute,
                                           relatedBy: self.relation,
                                           toItem: self.secondItem,
                                           attribute: self.secondAttribute,
                                           multiplier: self.multiplier,
                                           constant: self.constant)
    return newConstraint
    
  }
  
}

extension UIView {
  
  func updateConstraint(attribute: NSLayoutAttribute, value: CGFloat) {
    self.superview?.layoutIfNeeded()
    var const: NSLayoutConstraint?
    for i in 0...self.constraints.count - 1 {
      let c = self.constraints[i]
      //print("constraint:", c.description)
      if c.firstAttribute == attribute {
        const = c
        //break
      }
    }
    
    const?.isActive = false
    self.removeConstraint(const!)
    let nc = const?.copy() as! NSLayoutConstraint
    nc.constant = value
    nc.isActive = true
    self.addConstraint(nc)
    self.superview?.layoutIfNeeded()
  }
  
}
