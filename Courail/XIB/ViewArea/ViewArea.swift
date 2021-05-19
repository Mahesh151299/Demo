//
//  ViewArea.swift
//  Courail
//
//  Created by Omeesh Sharma on 02/02/21.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class ViewArea: UIView {

    //MARK: OUTLETS
    
    @IBOutlet weak var bgView: UIView!
    
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
        self.bgView = Bundle.main.loadNibNamed("ViewArea", owner: self, options: nil)?.first as? UIView
        self.bgView.frame = self.bounds
        self.addSubview(self.bgView)
    }
    
    //MARK: BUTTONS ACTIONS
    
    @IBAction func closeBtn(_ sender: UIButton){
        self.removeFromSuperview()
    }
    
    @IBAction func viewMap(_ sender: UIButton) {
        guard let completion = self.completion else{
            self.removeFromSuperview()
            return
        }
        completion(1)
        self.removeFromSuperview()
    }
    
    @IBAction func skipBtn(_ sender: UIButton) {
        guard let completion = self.completion else{
            self.removeFromSuperview()
            return
        }
        completion(0)
        self.removeFromSuperview()
    }
    
}
