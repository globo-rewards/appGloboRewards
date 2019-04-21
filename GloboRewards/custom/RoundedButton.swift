//
//  RoundedButton.swift
//  GloboRewards
//
//  Created by Carlos Doki on 21/04/19.
//  Copyright © 2019 Carlos Doki. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = UIScreen.main.nativeScale * 1
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        layer.borderColor = isEnabled ? tintColor.cgColor : UIColor.white.cgColor
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 1, height: 1)
    }
}
