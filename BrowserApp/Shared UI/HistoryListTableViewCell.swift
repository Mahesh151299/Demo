//
//  HistoryListTableViewCell.swift
//  BrowserApp
//
//  Created by Gaurav on 14/03/21.
//

import UIKit

class HistoryListTableViewCell: UITableViewCell {

    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var lblUrl: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgFavIcon: UIImageView!
    var btnCrossPress:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnCross(_ sender: Any) {
        self.btnCrossPress?()
    }

}
