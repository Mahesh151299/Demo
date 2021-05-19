//
//  NotesView.swift
//  Courail
//
//  Created by Omeesh Sharma on 25/01/21.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class NotesView: UIView {

    //MARK: OUTLETS
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    //MARK: VARIABLES
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, data: String, title: String) {
        super.init(frame: frame)
        self.setup(data : data, title: title)
    }
    
    
    func setup(data: String, title: String){
        self.bgView = Bundle.main.loadNibNamed("NotesView", owner: self, options: nil)?.first as? UIView
        self.bgView.frame = self.bounds
        self.addSubview(self.bgView)
        
        self.textView.text = data
        self.titleLbl.text = title
    }
    
    //MARK: BUTTONS ACTIONS
    
    @IBAction func closeBtn(_ sender: UIButton){
        self.removeFromSuperview()
    }
    
}
