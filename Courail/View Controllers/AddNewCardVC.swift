//
//  AddNewCardVC.swift
//  Courail
//
//  Created by mac on 12/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AddNewCardTVC: UITableViewCell {
    
    @IBOutlet weak var btnCreditCard: UIButton!
}

class AddNewCardVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveBtn(_ sender: Any) {
        backBtn(self)
    }
    
}

extension AddNewCardVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = AddNewCardTVC()
        cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! AddNewCardTVC
        cell.btnCreditCard.addTarget(self, action: #selector(ActionBtnCreditCard), for: .touchUpInside)
        return cell
    }
    
    @objc func ActionBtnCreditCard(sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddCardDetailVC") as! AddCardDetailVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

