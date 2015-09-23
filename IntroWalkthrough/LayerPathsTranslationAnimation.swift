//
//  LayerPathsTranslationAnimation.swift
//  IntroWalkthrough
//
//  Created by Danny on 9/21/15.
//  Copyright © 2015 Danny. All rights reserved.
//

import Foundation
import UIKit
import RazzleDazzle

public class LayerPathsTranslationAnimation : Animation<CGFloat>, Animatable {
    private let layer : CALayer
    private let paths : [CGPath]
    private let offsets : [CGFloat]
    
    
    public init(layer: CALayer, paths:[CGPath], offsets:[CGFloat]) {
        self.layer = layer
        self.paths = paths
        self.offsets = offsets
    }
    
    public func animate(time: CGFloat) {
        if !hasKeyframes() {return}
        
        
        let translation = self[time]

        
        let radius = ceil(layer.frame.size.width);
        let rect = CGRectMake(-radius, -radius/4, radius*2, radius*2.5);
        
        
        
        UIGraphicsBeginImageContext(rect.size);
        let context:CGContextRef? = UIGraphicsGetCurrentContext();
        
        
        
        if let context = context {
            CGContextTranslateCTM(context, rect.size.width/2, rect.size.height/2);
            

            CGContextSaveGState(context);
            CGContextAddRect(context, rect);
            CGContextSetFillColorWithColor(context, UIColor.init(red: 0, green: 255, blue: 255, alpha: 1).CGColor);
            CGContextFillRect(context, rect);
            CGContextRestoreGState(context);
    
            
            
            let circlePath = CGPathCreateMutable();
            CGContextSaveGState(context);
    

            for (var j = 0; j < paths.count; j++) {
                let appendPath = movePath(paths[j], translation:CGPoint(x:-translation*offsets[j], y:0))
                CGPathAddPath(circlePath, nil, appendPath);
            }
            
    
            
            CGContextSetBlendMode(context, CGBlendMode.Clear);
            CGContextAddPath(context, circlePath);
            CGContextFillPath(context);
            CGContextRestoreGState(context);
            
            let bezierImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            
            let layer:CAShapeLayer = CAShapeLayer.init()
            layer.bounds = CGRect(origin: CGPointZero, size: rect.size)
            layer.contents = bezierImage.CGImage;

            self.layer.mask = layer;
        }
    }
    
    public override func validateValue(value: CGFloat) -> Bool {
        return true;
    }
    
    //MARK: utils
    
    private func movePath(path:CGPath, translation:CGPoint) -> CGPath{
        var transform:CGAffineTransform = CGAffineTransformMakeTranslation(translation.x, translation.y);
        if let outputPath = CGPathCreateCopyByTransformingPath(path, &transform) {
            return outputPath
        }
        else {
            return path
        }
    }
}
