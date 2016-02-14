//
//  ImageGeneration.swift
//  MemeMe
//
//  Created by Santiago Avila on 2/14/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation
import UIKit

class ImageGeneration {
    
    /**
     Renders a view to a UIImage
     
     - parameter containerView: The UIView to be render
     
     - returns: Image of the rendered view
     */
    class func generateMemedImage(containerView containerView: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, containerView.opaque, 0.0)
        containerView.drawViewHierarchyInRect(containerView.bounds, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }
}