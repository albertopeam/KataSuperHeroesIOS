//
//  UISearchBar.swift
//  KataSuperHeroes
//
//  Created by Alberto on 1/10/18.
//  Copyright © 2018 GoKarumi. All rights reserved.
//

import UIKit.UISearchBar

extension UISearchBar {
    
    var cancelButton : UIButton? {
        if let view = self.subviews.first {
            for subView in view.subviews {
                if let cancelButton = subView as? UIButton {
                    return cancelButton
                }
            }
        }
        return nil
    }
    
    var textField : UITextField? {
        if let view = self.subviews.first {
            for subView in view.subviews {
                if let textField = subView as? UITextField {
                    return textField
                }
            }
        }
        return nil
    }
    
}
