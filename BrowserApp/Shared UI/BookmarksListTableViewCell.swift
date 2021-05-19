//
//  BookmarksListTableViewCell.swift
//  BrowserApp
//
//  Created by Gaurav.
//

import UIKit

class BookmarksListTableViewCell: UITableViewCell {

    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var lblUrl: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgFavIcon: UIImageView!
    var btnDropMenuPress:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnDropDown(_ sender: Any) {
        self.btnDropMenuPress?()
    }
    
}
