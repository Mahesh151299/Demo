//
//  AddToHomeVC.swift
//  BrowserApp
//
//  Created by Gaurav on 14/03/21.
//

import UIKit

class AddToHomeVC: UIViewController {

    @IBOutlet weak var imgFavAddToHome: UIImageView!
    @IBOutlet weak var tfAddToHomeScreen: UITextField!
    @IBOutlet weak var viewAddToHomeScreen: UIView!
    @objc var pageIconURL: String?
    @objc var pageTitle: String?
    @objc var pageURL: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfAddToHomeScreen.text = pageURL
        if let iconURL = pageIconURL, iconURL != "", let imgURL = URL(string: iconURL) {
            imgFavAddToHome.sd_setImage(with: imgURL, placeholderImage: UIImage(named: "globe"))
        } else {
            imgFavAddToHome.image = UIImage(named: "globe")
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCancelAddToHome(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnAddToHome(_ sender: Any) {
        done()
        
    }
    @objc func displayValidationError(message: String) {
        let av = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        av.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(av, animated: true, completion: nil)
    }
    
    @objc func done() {
        guard let title = tfAddToHomeScreen?.text, title != "" else {
            displayValidationError(message: "Please enter a url.")
            return
        }
        UserDefaults.standard.setValue(tfAddToHomeScreen.text, forKey: SettingsKeys.defaultPageUrl)
        UserDefaults.standard.synchronize()
        self.dismiss(animated: true)
    }
}
