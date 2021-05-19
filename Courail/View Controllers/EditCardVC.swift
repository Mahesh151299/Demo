//
//  EditCardVC.swift
//  Courail
//
//  Created by mac on 10/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class EditCardTVC: UITableViewCell {
    
}

class EditCardVC: UIViewController {
    
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var tableViewEditCard: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionSave(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func deleteAction(_ sender: Any) {
//        UIView.animate(withDuration: 0.3) {
//            self.deleteView.isHidden = false
//        }
//        self.view.layoutIfNeeded()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.deleteView.isHidden = true
//            self.navigationController?.popViewController(animated: true)
//        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DeleteCardAlertVC") as! DeleteCardAlertVC
                   vc.modalPresentationStyle = .overCurrentContext
                   self.view.addSubview(vc.view)
                   self.addChild(vc)
                   
//                   vc.view.layoutIfNeeded()
//                   vc.view.frame=CGRect(x: 0 , y: -0 + UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
//                   UIView.animate(withDuration: 0.5, animations: { () -> Void in
//                       vc.view.frame=CGRect(x: 0, y:0, width: UIScreen.main.bounds.size.width, height: (UIScreen.main.bounds.size.height));
//                   }, completion:nil)
    }
    
    
}

extension EditCardVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = EditCardTVC()
        cell = tableViewEditCard.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath) as! EditCardTVC
        return cell
    }
    
    
}
