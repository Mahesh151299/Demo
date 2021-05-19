//
//  SubtotalExplainedVC.swift
//  Courail
//
//  Created by mac on 21/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SubtotalExplainedTVC: UITableViewCell {
    
    @IBOutlet weak var TitleLbl: UILabel!
    
}

class SubtotalExplainedVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var skillLbl: UILabel!
    
    @IBOutlet weak var pricingTable: UITableView!
    @IBOutlet weak var pricingTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollTop: NSLayoutConstraint!
    //MARK: VARIABLES
    
    var pricingHeader = ["Base Fee","Effort Fee","Heavy Fee","Courial Pay Fee","Wait Time","Optional Tip"]
    var pricingText = ["$10.00 base fee + 0.35 / mile"]
    
    var isSkill = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isSkill{
            self.skillLbl.text = "SKILLS SERVICE"
            self.scrollTop.constant = 100
        } else{
            self.skillLbl.text = ""
            self.scrollTop.constant = 50
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.pricingTableHeight.constant = self.pricingTable.contentSize.height
    }
    
    //MARK: BUTTONS ACTIONS
    
    @IBAction func goToBack(_ sender: Any) {
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
}

extension SubtotalExplainedVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return pricingHeader.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row != 0 else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "pricingTVC", for: indexPath) as! SubtotalExplainedTVC
            cell.TitleLbl.text = pricingHeader[indexPath.section]
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PricingSubTVC", for: indexPath) as! SubtotalExplainedTVC
        if let string = self.attributedString(pricingText[indexPath.section]){
            cell.TitleLbl.attributedText = string
        } else{
            cell.TitleLbl.text = pricingText[indexPath.section]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
    func attributedString(_ originalText: String)-> NSMutableAttributedString?{
        let attributedString = NSMutableAttributedString(string: originalText)

        let loc1 = originalText.firstIndex(of: Character.init("("))?.utf16Offset(in: originalText) ?? 0
        let subString = originalText.components(separatedBy: "(").last ?? ""
        let range = attributedString.mutableString.range(of: "(" + subString)
        
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont.init(name: "Roboto-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13)], range: NSRange(location: 0, length: loc1))
        attributedString.addAttributes([
            NSAttributedString.Key.font: UIFont.init(name: "Roboto-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10)
        ], range: range)

        return attributedString
    }
    
}



