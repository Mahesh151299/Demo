//
//  DropDownMenuVC.swift
//  Browser
//
//  Created by Gaurav on 09/03/21.
//

import UIKit

enum ButtonType {
    case back,forward,bookmark,reload
}

class DropDownMenuVC: UIViewController {

    @IBOutlet weak var viewTopBtns: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var btnBookMark: UIButton!
    @IBOutlet weak var btnForward: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    var arrMenu = [String]()
    var isBackEnable = true
    var isForwardEnable = true
    var isBookmarked = false
    var upperBtnPress:((ButtonType)->())?
    var selectedMenu:((Int)->())?
    var isHideTopMenu = false
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTopBtns.isHidden = isHideTopMenu
        btnBack.isUserInteractionEnabled = isBackEnable
        btnBack.tintColor = isBackEnable ? .black : .lightGray
        btnForward.isUserInteractionEnabled = isForwardEnable
        btnForward.tintColor = isForwardEnable ? .black : .lightGray
        btnBookMark.isSelected = isBookmarked
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnBackPress(_ sender: Any) {
        upperBtnPress?(ButtonType.back)
        self.dismiss(animated: true)
    }
    
    @IBAction func btnForwardPress(_ sender: Any) {
        upperBtnPress?(ButtonType.forward)
        self.dismiss(animated: true)
    }
    
    @IBAction func btnBookmarkPress(_ sender: Any) {
        upperBtnPress?(ButtonType.bookmark)
        self.dismiss(animated: true)
    }
    
    @IBAction func btnRefreshPress(_ sender: Any) {
        upperBtnPress?(ButtonType.reload)
        self.dismiss(animated: true)
    }
}
extension DropDownMenuVC : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrMenu[indexPath.row] == "Block All Cookies"
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellMenu", for: indexPath)
            cell.textLabel?.text = arrMenu[indexPath.row]
            let switchView = UISwitch(frame: .zero)
            let status = UserDefaults.standard.bool(forKey: SettingsKeys.blockCookies)
                                   switchView.setOn(status, animated: true)
            
                                   switchView.tag = indexPath.row // for detect which row switch Changed
                                   switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            
                                   cell.accessoryView = switchView
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellMenu", for: indexPath)
            cell.textLabel?.text = arrMenu[indexPath.row]
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrMenu[indexPath.row] != "Block All Cookies"
        {
            selectedMenu?(indexPath.row)
        }
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        UserDefaults.standard.set(sender.isOn, forKey: SettingsKeys.blockCookies)
       
          print("table row switch Changed \(sender.tag)")
          print("The switch is \(sender.isOn ? "ON" : "OFF")")
    }
}
