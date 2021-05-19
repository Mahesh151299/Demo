//
//  SearchEmptyView.swift
//  Courail
//
//  Created by Omeesh Sharma on 25/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class SearchEmptyView: UIView {
    
    //MARK: OUTLETS
    
    @IBOutlet var bgView: UIView!
    
    @IBOutlet weak var loader: UIImageView!
    
    @IBOutlet weak var bgImage: UIImageView!
    //MARK: VARIABLES
    
    var gifName = ""
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, gifName: String) {
        super.init(frame: frame)
        self.gifName = gifName
        self.setup()
    }
    
    func setup(){
        DispatchQueue.main.async {
            self.bgView = Bundle.main.loadNibNamed("SearchEmptyView", owner: self, options: nil)?.first as? UIView
            self.bgView.frame = self.bounds
            self.addSubview(self.bgView)
            self.bgImage.image = UIImage.gif(name: self.gifName)
        }
    }
    
}


