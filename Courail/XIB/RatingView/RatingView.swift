//
//  RatingView.swift
//  Courail
//
//  Created by Omeesh Sharma on 17/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Cosmos

class RatingView: UIView {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var ratingView: CosmosView!
    //MARK: VARIABLES
    
    var completion : ((Int)-> ())?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, completion: @escaping ((Int)-> ())) {
        super.init(frame: frame)
        self.completion = completion
        self.setup()
    }
    
    
    func setup(){
        self.bgView = Bundle.main.loadNibNamed("RatingView", owner: self, options: nil)?.first as? UIView
        self.bgView.frame = self.bounds
        self.addSubview(self.bgView)
        
        self.ratingView.didFinishTouchingCosmos = { rating in
            guard let completion = self.completion else{
                self.removeFromSuperview()
                return
            }
            completion(Int(rating))
            self.removeFromSuperview()
            
        }
    }
    
    //MARK: BUTTONS ACTIONS
    
    @IBAction func notNowBtn(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    
}
