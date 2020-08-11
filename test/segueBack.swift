//
//  segueBack.swift
//  test
//
//  Created by 王義甫 on 2020/8/11.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class segueBack: UIStoryboardSegue {

    override func perform() {
        let src = self.source
        let dst = self.destination

        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width*2, y: 0) //Double the X-Axis
        UIView.animate(withDuration: 0.5, delay: 0.0, options:
                        UIView.AnimationOptions.curveEaseInOut, animations: {
                            dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
                            }) { (finished) in
            src.present(dst, animated: false, completion: nil)
        }
        }
    
}
