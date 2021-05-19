//
//  WebContainer.swift
//  Browser App
//
//  Created by Gaurav Gupta on 10/3/21. on 1/31/17.
//  .
//

import UIKit
import WebKit
import RealmSwift
import Then

class WebContainer: UIView, WKNavigationDelegate, WKUIDelegate, UIGestureRecognizerDelegate {
	
	@objc weak var parentView: UIView?
	@objc var webView: WKWebView?
    @objc var isObserving = false
	
	@objc weak var tabView: TabView?
    var favicon: Favicon?
    var currentScreenshot: UIImage?
    @objc var builtinExtensions: [BuiltinExtension]?
	
	@objc var progressView: UIProgressView?
    
    @objc var notificationToken: NotificationToken!
	var isPrivateEnable = false
	deinit {
        if isObserving {
            webView?.removeObserver(self, forKeyPath: "estimatedProgress")
            webView?.removeObserver(self, forKeyPath: "title")
        }
        notificationToken.invalidate()
        NotificationCenter.default.removeObserver(self)
	}
	
	@objc init(parent: UIView) {
		super.init(frame: .zero)
		
        
		self.parentView = parent
		
        backgroundColor = isPrivateEnable ? Colors.darkBg : .white
        
		webView = WKWebView(frame: .zero, configuration: loadConfiguration()).then { [unowned self] in
			$0.allowsLinkPreview = true
			$0.allowsBackForwardNavigationGestures = false
			$0.navigationDelegate = self
            $0.uiDelegate = self
            $0.contentMode = .scaleAspectFit
			self.addSubview($0)
			$0.snp.makeConstraints { (make) in
                make.edges.equalTo(self)
			}
		}
        
		progressView = UIProgressView().then { [unowned self] in
			$0.isHidden = true
			
			self.addSubview($0)
			$0.snp.makeConstraints { (make) in
				make.width.equalTo(self)
				make.top.equalTo(self)
				make.left.equalTo(self)
			}
		}
        
        do {
            let realm = try Realm()
            self.notificationToken = realm.observe { _, _ in
                self.reloadExtensions()
            }
        } catch let error as NSError {
            print("Error occured opening realm: \(error.localizedDescription)")
        }
        
        loadBuiltins()
        if self.webView?.url == nil {
            let _ = self.webView?.load(URLRequest(url: URL(string:defaultWebPage )!))
        }
        let swipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(backNavigationFunction(_:)))
            swipeGesture.edges = .left
            swipeGesture.delegate = self
        webView?.addGestureRecognizer(swipeGesture)
//        let source: String = "var meta = document.createElement('meta');" +
//                   "meta.name = 'viewport';" +
//                   "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
//                   "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);";
//
//               let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//               webView?.configuration.userContentController.addUserScript(script)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    // MARK: - Configuration Setup
    
    @objc func loadBuiltins() {
        builtinExtensions = WebViewManager.shared.loadBuiltinExtensions(webContainer: self)
        builtinExtensions?.forEach {
            if let handler = $0 as? WKScriptMessageHandler, let handlerName = $0.scriptHandlerName {
                webView?.configuration.userContentController.add(handler, name: handlerName)
            }
        }
    }
    
	@objc func loadConfiguration() -> WKWebViewConfiguration {
//		let config = WKWebViewConfiguration()
//
//		let contentController = WKUserContentController()
//
//		config.userContentController = contentController
//		config.processPool = WebViewManager.sharedProcessPool
//
//		return config
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
            "head.appendChild(meta);"

        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController: WKUserContentController = WKUserContentController()
        let conf = WKWebViewConfiguration()
        conf.userContentController = userContentController
        userContentController.addUserScript(script)
        return conf
	}
	
    
    @objc func reloadExtensions() {
        // Called when a new extension is added to Realm
        webView?.configuration.userContentController.removeAllUserScripts()
        builtinExtensions?.forEach {
            if let userScript = $0.webScript {
                webView?.configuration.userContentController.addUserScript(userScript)
            }
        }
    }
    
 
    
    @objc func adBlockChanged() {
        guard #available(iOS 11.0, *) else { return }
        
        let currentRequest = URLRequest(url: webView!.url!)
    }
	
    // MARK: - View Managment
    
	@objc func addToView() {
		guard let _ = parentView else { return }
		
		parentView?.addSubview(self)
		self.snp.makeConstraints { (make) in
			make.edges.equalTo(parentView!)
		}
		
		if !isObserving {
			webView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
            webView?.addObserver(self, forKeyPath: "title", options: .new, context: nil)
			isObserving = true
		}
	}
	
	@objc func removeFromView() {
		guard let _ = parentView else { return }
		
       // takeScreenshot()
        
		// Remove ourself as the observer
        if isObserving {
            webView?.removeObserver(self, forKeyPath: "estimatedProgress")
            webView?.removeObserver(self, forKeyPath: "title")
            isObserving = false
            progressView?.setProgress(0, animated: false)
            progressView?.isHidden = true
        }
		
		self.removeFromSuperview()
	}
	
	@objc func loadQuery(string: String) {
		var urlString = string
		if !urlString.isURL() {
			let searchTerms = urlString.replacingOccurrences(of: " ", with: "+")
            let searchUrl = UserDefaults.standard.string(forKey: SettingsKeys.searchEngineUrl)!
			urlString = searchUrl + searchTerms
		} else if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
			urlString = "http://" + urlString
		}
		
		if let url = URL(string: urlString) {
            var urlRequest = URLRequest(url: url)
            let blckCookies = UserDefaults.standard.bool(forKey: SettingsKeys.blockCookies)
            urlRequest.httpShouldHandleCookies = false//!blckCookies
			let _ = webView?.load(urlRequest)
		}
	}
    
    func takeScreenshot() {
        let screenshot = self.webView?.screenshot()
            print("screenshotr image\(screenshot)")
            self.currentScreenshot = screenshot
    }
	
    // MARK: - Webview Delegate
    
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			progressView?.isHidden = webView?.estimatedProgress == 1
			progressView?.setProgress(Float(webView!.estimatedProgress), animated: true)
            
            if webView?.estimatedProgress == 1 {
                progressView?.setProgress(0, animated: false)
            }
        } else if keyPath == "title" {
            tabView?.tabTitle = webView?.title
        }
	}
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        favicon = nil
    }
    
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		finishedLoadUpdates()
	}
    
    @objc func finishedLoadUpdates() {
        guard let webView = webView else { return }
        if !WebViewManager.shared.isPrivteEnable
        {
            WebViewManager.shared.logPageVisit(url: webView.url?.absoluteString, pageTitle: webView.title)
        }
       
        
        tabView?.tabTitle = webView.title
        tryToGetFavicon(for: webView.url)
        
        if let tabContainer = TabContainerView.currentInstance, isObserving {
            let attrUrl = WebViewManager.shared.getColoredURL(url: webView.url)
            if attrUrl.string == "" {
                tabContainer.addressBar?.setAddressText(webView.url?.absoluteString)
            } else {
                tabContainer.addressBar?.setAttributedAddressText(attrUrl)
            }
            tabContainer.addressBar?.lblTitle.text = attrUrl.string
            let secureColor = UIColor(named: "Secure")!
            //let insecureColor = UIColor(named: "Primary")
            let grayColor = UIColor(named: "Disabled")!
            let urlString = webView.url?.absoluteString
            if urlString!.contains("https://") {
                tabContainer.addressBar?.secureButton?.tintColor = secureColor
                //menuButton.tintColor = secureColor
              //  updateSecureButtonTint?(secureColor)
            } else {
                tabContainer.addressBar?.secureButton?.tintColor = grayColor
               // updateSecureButtonTint?(grayColor)
            }
            tabContainer.updateNavButtons()
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let tabContainer = TabContainerView.currentInstance, navigationAction.targetFrame == nil {
            tabContainer.addNewTab(withRequest: navigationAction.request)
        }
        return nil
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        if let tabContainer = TabContainerView.currentInstance {
            _ = tabContainer.close(tab: tabView!)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        handleError(error as NSError)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        handleError(error as NSError)
    }
    
    func handleError(_ error: NSError) {
        print(error.localizedDescription)
    }
    
  
	
	// MARK: - Alert Methods
	
	func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
	             initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
		let av = UIAlertController(title: webView.title, message: message, preferredStyle: .alert)
		av.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
			completionHandler()
		}))
		self.parentViewController?.present(av, animated: true, completion: nil)
	}
	
	func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String,
	             initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
		let av = UIAlertController(title: webView.title, message: message, preferredStyle: .alert)
		av.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
			completionHandler(true)
		}))
		av.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
			completionHandler(false)
		}))
		self.parentViewController?.present(av, animated: true, completion: nil)
	}
	
	func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String,
	             defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
		let av = UIAlertController(title: webView.title, message: prompt, preferredStyle: .alert)
		av.addTextField(configurationHandler: { (textField) in
			textField.placeholder = prompt
			textField.text = defaultText
		})
		av.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
			completionHandler(av.textFields?.first?.text)
		}))
		av.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
			completionHandler(nil)
		}))
		self.parentViewController?.present(av, animated: true, completion: nil)
	}
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.url?.scheme == "tel" {
               UIApplication.shared.open(navigationAction.request.url!)
               decisionHandler(.cancel)
           } else {
               decisionHandler(.allow)
           }
    }
    
    // MARK: - Helper methods
    
    @objc func tryToGetFavicon(for url: URL?) {
        if let faviconURL = favicon?.iconURL {
            tabView?.tabImageView?.sd_setImage(with: URL(string: faviconURL), placeholderImage: UIImage(named: "globe"))
            return
        }

        guard let url = url else { return }
        guard let scheme = url.scheme else { return }
        guard let host = url.host else { return }

        let faviconURL = scheme + "://" + host + "/favicon.ico"

        tabView?.tabImageView?.sd_setImage(with: URL(string: faviconURL), placeholderImage: UIImage(named: "globe"))
    }
    
    @objc func backNavigationFunction(_ sender: UIScreenEdgePanGestureRecognizer) {
        let dX = sender.translation(in: webView).x
        if sender.state == .ended {
            let fraction = abs(dX / parentView!.bounds.width ?? 0)
            if fraction >= 0.35 {
                //back navigation code here
                webView?.goBack()
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
