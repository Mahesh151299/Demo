//
//  TabCountButton.swift
//  Browser App
//
//  Created by Gaurav Gupta.
//  .
//

import UIKit

class TabCountButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.5
        layer.cornerRadius = 4
        
        setTitle("0", for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCount(_ newCount: Int) {
        setTitle("\(newCount)", for: .normal)
    }
    
}
