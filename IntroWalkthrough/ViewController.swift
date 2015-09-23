//
//  ViewController.swift
//  RazzleDazzleDemo
//
//  Created by Laura Skelton on 6/15/15.
//  Copyright (c) 2015 IFTTT. All rights reserved.
//

import UIKit
import RazzleDazzle
import CoreGraphics


class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var personView: UIView!
    @IBOutlet weak var box1View: UIView!
    @IBOutlet weak var box2View: UIView!
    @IBOutlet weak var box3View: UIView!
    @IBOutlet weak var box4View: UIView!
    @IBOutlet weak var box5View: UIView!
    @IBOutlet weak var box6View: UIView!
    @IBOutlet weak var paralaxBackgroundView: UIImageView!

    
    @IBOutlet weak var camera1View: UIView!
    @IBOutlet weak var camera2View: UIView!
    @IBOutlet weak var camera3View: UIView!
    
    @IBOutlet weak var card1View: UIView!
    @IBOutlet weak var card2View: UIView!
    @IBOutlet weak var card3View: UIView!
    @IBOutlet weak var card4View: UIView!
    
    
    private var animator = Animator()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self;
        scrollView.decelerationRate = 0.8; // UIScrollViewDecelerationRateFast;
        
        configurePage1()
        configurePage2()
        configurePage3()
    }
    
    
    //MARK configure
    
    
    func configurePage1(){
        let paths:[CGPath] = [circlePathForSize(personView.frame.size), circlePathForSize(box1View.frame.size), circlePathForSize(box2View.frame.size), circlePathForSize(box3View.frame.size), circlePathForSize(box4View.frame.size), circlePathForSize(box5View.frame.size), circlePathForSize(box6View.frame.size)]
        
        
        let views:[UIView] = [personView, box1View, box2View, box3View, box4View, box5View, box6View]
        let offsets:[CGFloat] = [1100, 400, 550, 300, 400, 500, 20]
        
        let paralax = ParalaxHelper.init(animator: animator, views: views, paths: paths, offsets: offsets, width: view.frame.size.width, margin: 0)
        
        paralax.configure()
    }
    
    func configurePage2(){
        let paths:[CGPath] = [circlePathForSize(camera1View.frame.size), circlePathForSize(camera2View.frame.size), circlePathForSize(camera3View.frame.size)]
        
        
        let views:[UIView] = [camera1View, camera2View, camera3View]
        let offsets:[CGFloat] = [1100, 800, 800]
        
        let paralax = ParalaxHelper.init(animator: animator, views: views, paths: paths, offsets: offsets, width: view.frame.size.width, margin: view.frame.size.width)
        
        paralax.configure()
    }
    
    func configurePage3(){
        let paths:[CGPath] = [rectPathForSize(card1View.frame.size), rectPathForSize(card2View.frame.size), rectPathForSize(card3View.frame.size), rectPathForSize(card4View.frame.size)]
        
        
        let views:[UIView] = [card1View, card2View, card3View, card4View]
        let offsets:[CGFloat] = [1000, 800, 600, 400]
        
        let paralax = ParalaxHelper.init(animator: animator, views: views, paths: paths, offsets: offsets, width: view.frame.size.width, margin: view.frame.size.width*2)
        
        paralax.configure()
    }
    
    //MARK path helper functions
    
    func circlePathForSize(size:CGSize) ->CGPath {
        let circlePath = CGPathCreateMutable();
        CGPathAddEllipseInRect(circlePath, nil, CGRect(origin: CGPointZero, size: size));
        return circlePath;
    }

    func rectPathForSize(size:CGSize) ->CGPath {
        let rectPath = CGPathCreateMutable();
        CGPathAddRect(rectPath, nil, CGRect(origin: CGPointZero, size: size))
        return rectPath;
    }
    
    
    //MARK: scrollview
    
    private func pageSize()->CGFloat
    {
        return ceil(view.bounds.size.width)
    }
    
    private func resolveTargetContentOffset(scrollView:UIScrollView, velocity:CGPoint, inout targetContentOffset: CGPoint) -> CGPoint {
        let pageWidth = pageSize()

        
        let val = scrollView.contentOffset.x / pageWidth;
        var newPage = floor(val);
    
        if (velocity.x == 0) {
            newPage = floor((targetContentOffset.x - pageWidth / 2) / pageWidth) + 1;
        }
        else if(velocity.x > 0){
            newPage += 1
        }
    
        return CGPoint(x:newPage * pageWidth, y:targetContentOffset.y);
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        animator.animate(scrollView.contentOffset.x)
    }
    
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let targetOffset = resolveTargetContentOffset(scrollView, velocity: velocity, targetContentOffset: &targetContentOffset.memory)
        
        
        targetContentOffset.memory = targetOffset
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
}
