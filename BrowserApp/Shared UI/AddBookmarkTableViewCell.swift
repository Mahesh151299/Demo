//
//  AddBookmarkTableViewCell.swift
//  BrowserApp
//
//  Created by Gaurav.
//

import UIKit

class AddBookmarkTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var tfDetails: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
