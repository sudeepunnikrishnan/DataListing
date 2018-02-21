//
//  PaddingLabel.swift
//  Employee Directory
//
//  Created by Sudeep.Unnikrishnan on 23/12/17.
//  Copyright © 2017 Sudeep Unnikrishnan. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {

    var padding: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    // Create a new PaddingLabel instance programamtically with the desired insets
    required init(padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)) {
        self.padding = padding
        super.init(frame: CGRect.zero)
    }
    
    // Create a new PaddingLabel instance programamtically with default insets
    override init(frame: CGRect) {
        padding = UIEdgeInsets.zero // set desired insets value according to your needs
        super.init(frame: frame)
    }
    
    // Create a new PaddingLabel instance from Storyboard with default insets
    required init?(coder aDecoder: NSCoder) {
        padding = UIEdgeInsets.zero // set desired insets value according to your needs
        super.init(coder: aDecoder)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
    }
    
    // Override `intrinsicContentSize` property for Auto layout code
    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frame.size = intrinsicContentSize
    }
}
