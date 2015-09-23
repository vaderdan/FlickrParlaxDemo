//
//  ParalaxHelper.swift
//  IntroWalkthrough
//
//  Created by Danny on 9/22/15.
//  Copyright © 2015 Danny. All rights reserved.
//

import Foundation
import UIKit
import RazzleDazzle

public class ParalaxHelper {
    public let views:[UIView]
    public let paths:[CGPath]
    public let offsets:[CGFloat]
    public let animator:Animator
    public let width:CGFloat
    public let margin:CGFloat
    
    private var outerPadding:CGFloat  = 5.0
    private var maskpaths = [[CGPath]]();

    
    public init(animator:Animator, views: [UIView], paths:[CGPath], offsets:[CGFloat], width:CGFloat, margin:CGFloat, outerPadding:CGFloat = 5) {
        self.views = views
        self.offsets = offsets
        self.animator = animator
        self.width = width
        self.paths = paths
        self.margin = margin
        self.outerPadding = outerPadding
    }
    
    func configure(){
        configureMasks(self.views)
        configureAnimations()
    }
    
    private func configureMasks(views:[UIView]) {
        for (var i:Int = 0; i<views.count; i++) {
            var tmppaths:[CGPath] = [CGPath]();

            for (var j = 0; j < views.count-i; j++) {
                tmppaths.append(resizePath(paths[i], size:views[i].frame.size, padding: outerPadding))
            }
            
            maskpaths.append(tmppaths)
        }
        

        
        for (var i:Int = 0; i < views.count; i++) {
            let view:UIView = views[i]
            
            
            if let bezierLayer = self.maskImageForIndex(i, views:views) {
                view.layer.mask = bezierLayer;
            }
        }
    }
    
    private func maskImageForIndex(i:Int, views:[UIView]) -> CALayer? {
        let radius:CGFloat = ceil(width);
        let rect:CGRect = CGRectMake(-radius, -radius, radius*2, radius*2);
        
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
            
            
            for (var j:Int = 0; j < i; j++) {
                maskpaths[j][i-j] = movePath(maskpaths[j][i-j], fromView: views[j], toView: views[i])
                CGPathAddPath(circlePath, nil, maskpaths[j][i-j]);
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
            return layer;
        }
        
        return nil;
    }
    
    private func configureAnimations() {
        for (var i = 0; i < views.count; i++) {
            self.configureDazzleView(views[i], width: width, traslation: offsets[i], toTranslation: -offsets[i])
        }
        
        for (var i = 0; i < views.count; i++) {
            var paths = [CGPath]();
            var relativeOffsets = [CGFloat]();
            
            
            for (var j = 0; j < i; j++) {
                let path = maskpaths[j][i-j];
                paths.append(path)
                let relativeOffset = (offsets[j] - offsets[i]) / offsets[i];
                relativeOffsets.append(relativeOffset)
            }
            
            configureDazzleLayer(views[i].layer, width: width, traslation: -offsets[i], toTranslation: offsets[i], paths:paths, offsets:relativeOffsets);
        }
    }
   
    
    private func movePath(path:CGPath, fromView fromview:UIView, toView toview:UIView) -> CGPath
    {
        var translation = CGAffineTransformMakeTranslation(fromview.frame.origin.x - toview.frame.origin.x, fromview.frame.origin.y - toview.frame.origin.y);
        
        if let outputPath = CGPathCreateCopyByTransformingPath(path, &translation) {
            return outputPath
        }
        else {
            return path
        }
    }
    
    private func resizePath(path:CGPath, size:CGSize, padding:CGFloat) -> CGPath
    {
        var translation = CGAffineTransformMakeScale((size.width+padding)/size.width, (size.height+padding)/size.height)
        
        if let outputPath = CGPathCreateCopyByTransformingPath(path, &translation) {
            return outputPath
        }
        else {
            return path
        }
    }
    
    
    private func configureDazzleView(view:UIView, width:CGFloat, traslation:CGFloat, toTranslation:CGFloat){
        let translationAnimation = TranslationAnimation.init(view: view)
        translationAnimation.addKeyframe(margin-width, value: CGPoint(x:traslation, y:0))
        translationAnimation.addKeyframe(margin+width, value: CGPoint(x:toTranslation, y:0))
        
        animator.addAnimation(translationAnimation)
    }
    
    private func configureDazzleLayer(layer:CALayer, width:CGFloat, traslation:CGFloat, toTranslation:CGFloat, paths:[CGPath], offsets:[CGFloat]){
        
        let translationAnimation = LayerPathsTranslationAnimation.init(layer: layer, paths: paths, offsets: offsets)
        translationAnimation.addKeyframe(margin-width, value: traslation)
        translationAnimation.addKeyframe(margin+width, value: toTranslation)
        
        animator.addAnimation(translationAnimation)
    }
}