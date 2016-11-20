//
//  ImageViewWithTranslucentWindow.swift
//  ImageWithTranslucentWindow
//
//  Created by Christian Schraga on 11/20/16.
//  Copyright © 2016 Straight Edge Digital. All rights reserved.
//

import UIKit
import AVFoundation

class ImageViewWithTranslucentWindow: UIView {

    //private instance variables
    fileprivate var _image: UIImage?
    fileprivate var _circleRect: CGRect?
    fileprivate var _blurFactor: CGFloat = 10.0
    
    //public interface variables
    var image: UIImage? {
        get{
            return _image
        }
        set(newImage){
            _image = newImage
            setNeedsDisplay()
        }
    }
    var circleRect: CGRect? {
        get{
            return _circleRect
        }
        set(newRect){
            _circleRect = newRect
            setNeedsDisplay()
        }
    }
    var blurFactor: CGFloat {
        get{
            return _blurFactor
        }
        set(newFactor){
            _blurFactor = newFactor
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        self.contentMode = .scaleAspectFit
        if _circleRect == nil {
            let inset = CGFloat(10.0)
            let width = self.bounds.width - inset*2
            _circleRect = CGRect(x: inset, y: inset, width: width, height: width)
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        if let _image = self._image {
            
            let ctx = UIGraphicsGetCurrentContext()!
            
            //make a clipping mask of the circle
            ctx.saveGState()
            let circleRectPath = UIBezierPath(ovalIn: _circleRect ?? rect)
            ctx.addPath(circleRectPath.cgPath)
            ctx.clip()
        
            if _image.size.width > 0.0 && _image.size.height > 0.0 {
                //get correct image rectangle size for aspect ratio fit
                let widthFactor  =  rect.size.width  / _image.size.width
                let heightFactor =  rect.size.height / _image.size.height
                let maxFactor = max(widthFactor, heightFactor)
                let adjWidth  = _image.size.width  / maxFactor
                let adjHeight = _image.size.height / maxFactor
                let adjX = rect.midX - adjWidth/2
                let adjY = rect.midY - adjHeight/2
                let imageRect = CGRect(x: adjX, y: adjY, width: adjWidth, height: adjHeight)
                
            
                //blur effect
                let inputImage = CIImage(image: _image)
                var outputImage: UIImage?
                let gaussianBlurFilter = CIFilter(name: "CIGaussianBlur")
                if gaussianBlurFilter != nil {
                    gaussianBlurFilter!.setValue(inputImage, forKey: "inputImage")
                    gaussianBlurFilter!.setValue(_blurFactor, forKey: "inputRadius")
                    if let outputCI = gaussianBlurFilter!.outputImage {
                        outputImage = UIImage(ciImage: outputCI)
                    }
                }
                let finalImage = outputImage ?? _image
                
                //draw image over mask
                finalImage.draw(in: imageRect)
                
                
                //draw outside of circle
                ctx.restoreGState()
                
                //clip
                ctx.saveGState()
                let circleRectPath = UIBezierPath(ovalIn: _circleRect ?? rect)
                ctx.addPath(circleRectPath.cgPath)
                let outlinePath   = UIBezierPath(rect: rect) //this is so i get an inverted mask
                ctx.addPath(outlinePath.cgPath)
                ctx.clip(using: .evenOdd)
            
                //image
                _image.draw(in: imageRect)
                
                ctx.restoreGState()
                
            }
        }
    }
    

}
