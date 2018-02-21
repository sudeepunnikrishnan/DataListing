//
//  ViewExtension.swift
//  Employee Directory
//
//  Created by Sudeep.Unnikrishnan on 23/12/17.
//  Copyright © 2017 Sudeep Unnikrishnan. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var corner_Radius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var border_Width: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var border_Color: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

var AppActivityView: UnsafePointer<UIView>? = nil
extension UIView {
    
    func showActivity(_ disableAll: Bool = false) {
        
        let existingView = objc_getAssociatedObject(self, &AppActivityView) as! UIView?
        if(existingView != nil) {
            return
        }
        
        let disablerView = UIView();
        disablerView.translatesAutoresizingMaskIntoConstraints = false
        disablerView.backgroundColor = UIColor.clear //UIColor(white: 0.0, alpha: 0.3)
        disablerView.alpha = 0.0
        
        if disableAll {
            
            let window = (UIApplication.shared.delegate as! AppDelegate).window!
            window.addSubview(disablerView)
            
        } else {
            addSubview(disablerView)
        }
        
        var viewsDictionary: NSDictionary = ["disablerView": disablerView]
        
        let contraintArrayv  = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[disablerView]-0-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: viewsDictionary as! [String : AnyObject])
        let contraintArrayh = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[disablerView]-0-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: viewsDictionary as! [String : AnyObject])
        
        if disableAll {
            
            let window = (UIApplication.shared.delegate as! AppDelegate).window!
            window.addConstraints(contraintArrayv)
            window.addConstraints(contraintArrayh)
            
        } else {
            
            addConstraints(contraintArrayv)
            addConstraints(contraintArrayh)
        }
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let bgView = UIVisualEffectView(effect: blurEffect)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.layer.cornerRadius = 8;
        bgView.layer.masksToBounds = true
        bgView.layer.shadowColor = UIColor.clear.cgColor
        bgView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        bgView.layer.shadowOpacity = 0.8
        bgView.layer.shadowRadius = 6;
        bgView.layer.shadowOffset = CGSize(width: 4, height: 4)
        bgView.layer.shouldRasterize = true
        bgView.layer.rasterizationScale = UIScreen.main.scale
        disablerView.addSubview(bgView)
        
        viewsDictionary = ["bgView": bgView]
        
        let constaintBgViewV = NSLayoutConstraint.constraints(withVisualFormat: "V:[bgView(100)]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: viewsDictionary as! [String : AnyObject])
        let constaintBgViewH = NSLayoutConstraint.constraints(withVisualFormat: "H:[bgView(100)]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: viewsDictionary as! [String : AnyObject])
        
        bgView.addConstraints(constaintBgViewV)
        bgView.addConstraints(constaintBgViewH)
        
        let centerBgViewx =  NSLayoutConstraint(item: bgView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: disablerView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let centerBgViewy =  NSLayoutConstraint(item: bgView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: disablerView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        
        disablerView.addConstraint(centerBgViewx)
        disablerView.addConstraint(centerBgViewy)
        
        let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white);
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.color = UIColor.gray
        activity.backgroundColor = UIColor.clear
        disablerView.addSubview(activity);
        activity.startAnimating()
        
        let centerActivtyx =  NSLayoutConstraint(item: activity, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: disablerView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let centerActivtyy =  NSLayoutConstraint(item: activity, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: disablerView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        
        disablerView.addConstraint(centerActivtyx)
        disablerView.addConstraint(centerActivtyy)
        
        // associate the activity view with self
        objc_setAssociatedObject (self, &AppActivityView, disablerView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2, animations: {
            disablerView.alpha = 1.0
        })
        
    }
    
    func hideActivity() {
        let existingView = objc_getAssociatedObject(self, &AppActivityView) as! UIView?
        if(existingView != nil) {
            isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.2, animations: {
                existingView!.alpha = 0.0
            }, completion: { success in
                existingView!.removeFromSuperview()
                objc_setAssociatedObject (self, &AppActivityView, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            })
        }
        
    }
}
