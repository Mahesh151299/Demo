//
//  EmptyView.swift
//  Courail
//
//  Created by Omeesh Sharma on 27/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class EmptyView: UIView {
    
    //MARK: OUTLETS
    
    @IBOutlet var bgView: UIView!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var loader: UIImageView!
    
    //MARK: VARIABLES
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect,icon: String?) {
        super.init(frame: frame)
        self.setup(icon: icon)
    }
    
    
    func setup(icon: String?){
        DispatchQueue.main.async {
            self.bgView = Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)?.first as? UIView
            self.bgView.frame = self.bounds
            self.addSubview(self.bgView)
            self.icon.image = UIImage(named: icon ?? "")
            switch icon ?? ""{
            case "imgTakeout":
                self.icon.image = UIImage(named: "takeout")
                self.icon.contentMode = .scaleAspectFill
            case "imgDrycleaning":
                self.icon.contentMode = .scaleAspectFill
                self.icon.layer.cornerRadius = 10
            default:
                self.icon.contentMode = .scaleAspectFit
            }
//            self.loader.image = UIImage.gif(name: "ZZ5H")
        }
    }
    
    
  
}


