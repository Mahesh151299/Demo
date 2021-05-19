//
//  PrivacyViewController.swift
//  Courail
//
//  Created by apple on 17/03/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import WebKit

class PrivacyViewController: UIViewController , WKNavigationDelegate {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var screenTitle: UILabel!
    
    @IBOutlet weak var backBtnOut: UIButton!
    
    //MARK: VARIABLES
    
    var webView: WKWebView!
    
    var screen  = "Privacy Policy"
    
    let privacyURL = "https://www.courial.com/privacy"
    let tosURL = "https://www.courial.com/tos"
    let licensesURL = "https://www.courial.com"
    let promotionsURL = "https://www.courial.com"
    let contactUs = "https://www.courial.com"
    let helpURL = "https://courial.helpscoutdocs.com/"
    let learnMore = "https://courial.helpscoutdocs.com/article/109-can-courial-help-with-my-ecommerce-or-online-deliveries"
    
    var fromMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenTitle.text = self.screen

        self.webView = WKWebView.init(frame: self.innerView.bounds)
        self.webView.backgroundColor = .clear
        self.webView.scrollView.backgroundColor = .clear
        self.innerView.addSubview(self.webView)
        
        if self.fromMenu{
            self.backBtnOut.setImage(UIImage(named: "newBar"), for: .normal)
        } else{
            self.backBtnOut.setImage(UIImage(named: "arrow_3Temp"), for: .normal)
        }
        
        
        self.webView.navigationDelegate = self
        
        var urlString = ""
        switch self.screen{
        case "Privacy Policy":
            urlString = self.privacyURL
        case "Terms of Service":
            urlString = self.tosURL
        case "License":
            urlString = self.licensesURL
        case "Promotions":
            urlString = self.promotionsURL
        case "Contact Us":
            urlString = self.contactUs
        case "Learn More":
            urlString = self.learnMore
        case "Get Help":
            urlString = self.helpURL
        default:
            urlString = self.licensesURL
        }
        
        guard let url = URL(string: urlString) else {return}
        
        let request = URLRequest(url: url)
        self.webView.load(request)
        showLoader()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        self.webView.navigationDelegate = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.webView.frame = self.innerView.bounds
    }
    
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func backBtn(_ sender: UIButton) {
        if fromMenu{
            toggleMenu(self)
        } else{
            self.pop()
        }
    }
    
    //MARK:- WebView Delegates
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoader()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoader()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        hideLoader()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy.allow)
    }

}
