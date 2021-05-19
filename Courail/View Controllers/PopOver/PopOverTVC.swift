//
//  PopOverTVC.swift
//  CourialPartner
//
//  Created by apple on 23/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class PopOverTVC: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgSelection: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
