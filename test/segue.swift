//
//  segue.swift
//  test
//
//  Created by 王義甫 on 2020/8/11.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class segue: UIStoryboardSegue {
    
    override func perform() {
            let src: UIViewController = self.source
            let dst: UIViewController = self.destination
            let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.duration = 0.25
            transition.timingFunction = timeFunc
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
            src.navigationController!.view.layer.add(transition, forKey: kCATransition)
            src.navigationController!.pushViewController(dst, animated: false)
        }

//    override func perform() {
//            let src = self.source
//            let dst = self.destination
//
//            src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
//            dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width*2, y: 0) //Double the X-Axis
//        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
//                dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
//            }) { (finished) in
//                src.present(dst, animated: false, completion: nil)
//            }
//        }

}
