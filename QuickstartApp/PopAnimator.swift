//
//  PopAnimator.swift
//  QuickstartApp
//
//  Created by Luqmaan Siddiqui on 7/9/18.
//  Copyright © 2018 Luqmaan Siddiqui. All rights reserved.
//

import Foundation
/*
 * Copyright (c) 2014-present Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 1.0
    var presenting = true
    var originFrame = CGRect.zero
    
    var dismissCompletion: (()->Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
       // let herbView = presenting ? toView : transitionContext.view(forKey: .from)!
        
        let initialFrame = originFrame
        let finalFrame = toView.frame
        
//        let xScaleFactor = presenting ?
//            initialFrame.width / finalFrame.width :
//            finalFrame.width / initialFrame.width
//
//        let yScaleFactor = presenting ?
//            initialFrame.height / finalFrame.height :
//            finalFrame.height / initialFrame.height
        
        
        
        //let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        toView.transform = CGAffineTransform(scaleX: initialFrame.width/finalFrame.width, y: initialFrame.height/finalFrame.height)
        toView.center = CGPoint(x:initialFrame.midX, y:initialFrame.midY)
        containerView.addSubview(toView)
        
       // containerView.addSubview(toView)
      
        
        UIView.animate(withDuration: duration, delay:0.0,
                       usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0,
                       animations: {
                      toView.transform = .identity
                        toView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }, completion: { _ in
            
            transitionContext.completeTransition(true)
        })
    }
}
