//
//  MainViewController.swift
//  Browser App
//
//  Created by Gaurav Gupta on 1/31/17.
//  .
//

import UIKit
import RealmSwift
import FSnapChatLoading

var defaultWebPage = "https://search.questa.mobi/?"//"https://www.google.com"
class MainViewController: UIViewController, HistoryNavigationDelegate {
    
    
    @objc var container: UIView?
    @objc var tabContainer: TabContainerView?
    var addressBar: AddressBar!
    let documentInteractionController = UIDocumentInteractionController()
    let loadingView = FSnapChatLoadingView()
    let supportedTypes = ["pdf","doc","docx","rtf","txt","xlsx"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.whiteBg
        documentInteractionController.delegate = self
        let padding = UIView().then { [unowned self] in
            $0.backgroundColor = Colors.whiteBg
            
            self.view.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.width.equalTo(self.view)
                if #available(iOS 11.0, *) {
                    make.height.equalTo(self.view.safeAreaInsets.top)
                } else {
                    make.height.equalTo(UIApplication.shared.statusBarFrame.height)
                }
                make.top.equalTo(self.view)
            }
        }
        
        tabContainer = TabContainerView(frame: .zero).then { [unowned self] in
            $0.addTabButton?.addTarget(self, action: #selector(self.addTab), for: .touchUpInside)
            //$0.tabCountButton.addTarget(self, action: #selector(showTabTray), for: .touchUpInside)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints { (make) in
                if #available(iOS 11.0, *) {
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                } else {
                    make.top.equalTo(padding.snp.bottom)
                }
                make.left.equalTo(self.view)
                make.width.equalTo(self.view)
                make.height.equalTo(TabContainerView.standardHeight)
            }
        }
        
        addressBar = AddressBar(frame: .zero).then { [unowned self] in
            $0.tabCountButton.addTarget(self, action: #selector(showTabTray), for: .touchUpInside)
            $0.tabContainer = self.tabContainer
            self.tabContainer?.addressBar = $0
            
            $0.setupNaviagtionActions(forTabConatiner: self.tabContainer!)
            $0.menuButton?.addTarget(self, action: #selector(self.showMenu(sender:)), for: .touchUpInside)
            $0.homeButton?.addTarget(self, action: #selector(self.homeBtn(sender:)), for: .touchUpInside)
            $0.shareButton?.addTarget(self, action: #selector(self.shareLink), for: .touchUpInside)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.top.equalTo(self.tabContainer!.snp.bottom)
                make.left.width.equalTo(self.view)
                make.height.equalTo(AddressBar.standardHeight)
            }
        }
        container = UIView().then { [unowned self] in
            self.tabContainer?.containerView = $0
            
            self.view.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.top.equalTo(addressBar.snp.bottom)
                make.width.equalTo(self.view)
                make.bottom.equalTo(self.view)
                make.left.equalTo(self.view)
            }
        }
        tabContainer?.onScroll = { [weak self] scrollView in
            var height = AddressBar.standardHeight
            if !(self?.addressBar.addressField?.isEditing ?? false)
            {
                if scrollView.contentOffset.y > 150 {// the value when you want the headerview to hide
                    print("hide view")
                    height = AddressBar.scrollHeight
                    self?.addressBar.isHideSearchBar = true
                    
                }else {
                    print("shopw view")
                    height = AddressBar.standardHeight
                    self?.addressBar.isHideSearchBar = false
                }
                self?.addressBar?.snp.updateConstraints({ (make) -> Void in
                    make.height.equalTo(height)
                })
                UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: {
                    self?.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
        self.addressBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAddressField)))
        tabContainer?.loadBrowsingSession()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear called")
        TabContainerView.currentInstance?.currentTab?.webContainer?.takeScreenshot()
       // tabContainer?.currentTab?.webContainer?.takeScreenshot()
        
    }
    
    override func viewDidLayoutSubviews() {
        tabContainer?.setUpTabConstraints()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        tabContainer?.setUpTabConstraints()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    @objc func showAddressField(gesture:UITapGestureRecognizer) {
        var height = AddressBar.standardHeight
            if addressBar.isHideSearchBar
            {
                height = AddressBar.standardHeight
                self.addressBar.isHideSearchBar = false
                self.addressBar?.snp.updateConstraints({ (make) -> Void in
                    make.height.equalTo(height)
                })
                UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
    }
    
    @objc func addTab() {
        addressBar.addressField?.text = defaultWebPage
        addressBar?.lblTitle.text = defaultWebPage
        tabContainer?.currentTab?.webContainer?.takeScreenshot()
        let _ = tabContainer?.addNewTab(container: container!)
    }
    
    @objc func homeBtn(sender: UIButton) {
        addressBar.addressField?.text = defaultWebPage
        addressBar?.lblTitle.text = defaultWebPage
        tabContainer?.currentTab?.webContainer?.loadQuery(string: defaultWebPage)
        view.endEditing(true)
    }
    
    
    
    
    @objc func showMenu(sender: UIButton) {
       
        // let incognitoText = TabContainerView.currentInstance?.isPrivateEnable ?? false ? "Close incognito tab" : "New incognito tab"
        //,"Block All Cookies"
        var arrMenu = ["New tab","Bookmarks","Recent tabs","History","Share","Add to Home screen"]
        let isCloseTabShown = TabContainerView.currentInstance?.tabList.count ?? 1 > 1
        if isCloseTabShown
        {
            arrMenu.insert("Close tab", at: 1)
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "DropDownMenuVC") as! DropDownMenuVC
        vc.isBackEnable = tabContainer?.currentTab?.webContainer?.webView?.canGoBack ?? false
        vc.isForwardEnable = tabContainer?.currentTab?.webContainer?.webView?.canGoForward ?? false
        vc.arrMenu = arrMenu
        vc.upperBtnPress = { [weak self] btnType in
            switch btnType {
            case .back:
                print("back button press")
                self?.tabContainer?.currentTab?.webContainer?.webView?.goBack()
            case .forward:
                print("forward button press")
                self?.tabContainer?.currentTab?.webContainer?.webView?.goForward()
            case .bookmark:
                print("bookmark button press")
                vc.dismiss(animated: true)
                self?.addBookmark(btn: sender)
            case .reload:
                print("reload button press")
                self?.tabContainer?.loadQuery(string: self?.tabContainer?.addressBar?.addressField?.text)
                //self?.tabContainer?.currentTab?.webContainer?.webView?.reload()
            }
        }
        vc.selectedMenu = {[weak self] selectedIndex in
            vc.dismiss(animated: true)
            switch selectedIndex {
            case 0:
                self?.addTab()
            case 1:
                //self?.privateTab()
                print("private tab")
                if isCloseTabShown
                {
                    self?.closeCurrentTab()
                }else
                {
                    self?.showBookmarks()
                }
                
            case 2:
                //self?.addTab()
                print("bookmarks")
                if isCloseTabShown
                {
                    self?.showBookmarks()
                }else
                {
                    self?.showTabTray()
                }
                
            case 3:
                if isCloseTabShown
                {
                    self?.showTabTray()
                }else
                {
                    self?.showHistory()
                }
                
            case 4:
                //  self?.addTab()
                print("history")
                if isCloseTabShown
                {
                    self?.showHistory()
                }else
                {
                    self?.shareLink()
                }
                
            case 5:
                if isCloseTabShown
                {
                    self?.shareLink()
                }else
                {
                    self?.addToHomeScreen()
                }
                
            case 6:
                //self?.addTab()
                if isCloseTabShown
                {
                    self?.addToHomeScreen()
                }
                
                print("add to home screen")
            default:
                print("default")
            }
        }
        vc.modalPresentationStyle = .popover
        let popover = vc.popoverPresentationController
        vc.preferredContentSize = CGSize(width: 250, height: isCloseTabShown ? 350 : 310)
        popover?.delegate = self
        popover?.sourceView = sender
        popover?.sourceRect = sender.bounds
        popover?.permittedArrowDirections = []
        popover?.canOverlapSourceViewRect = true
        vc.popoverPresentationController?.backgroundColor = UIColor.white
        self.present(vc, animated: true)
    }
    
    @objc func shareLink() {
        guard let tabContainer = self.tabContainer else { return }
        let selectedTab = tabContainer.tabList[tabContainer.selectedTabIndex]
        
        guard let url = selectedTab.webContainer?.webView?.url else { return }
        if supportedTypes.contains(url.pathExtension)
        {
            self.storeAndShare(withURLString: url.absoluteString)
        }
        else
        {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
           // activityVC.excludedActivityTypes = [.print]
            activityVC.excludedActivityTypes = [
                .assignToContact,
                .print,
                .addToReadingList,
                .saveToCameraRoll,
                .openInIBooks,
                UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
                UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"),
            ]
            activityVC.completionWithItemsHandler = { _, completed, _, _ in
                if completed {
                }
            }
            if UIDevice.current.userInterfaceIdiom == .pad {
                   if let popup = activityVC.popoverPresentationController {
                       popup.sourceView = self.view
                       popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                   }
               }
            self.present(activityVC, animated: true, completion: nil)
        }
        
    }
    
    @objc func privateTab() {
        if TabContainerView.currentInstance?.isPrivateEnable ?? false
        {
            TabContainerView.currentInstance?.isPrivateEnable = false
            self.view.backgroundColor = Colors.whiteBg
        }
        else
        {
            TabContainerView.currentInstance?.isPrivateEnable = true
            self.view.backgroundColor = Colors.darkBg
        }
        
    }
    
    func closeCurrentTab()
    {
        if TabContainerView.currentInstance?.isPrivateEnable ?? false
        {
            
        }
        else
        {
            TabContainerView.currentInstance?.close(tab: (TabContainerView.currentInstance?.currentTab)!)
            
        }
    }
    
    
    @objc func showHistory() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HistoryListVC") as! HistoryListVC
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    @objc func showBookmarks() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "BookmarksVC") as! BookmarksVC
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    @objc func addBookmark(btn: UIView) {
        let vc = AddBookmarkTableViewController(style: .plain)
        vc.pageIconURL = tabContainer?.currentTab?.webContainer?.favicon?.getPreferredURL()
        vc.pageTitle = tabContainer?.currentTab?.webContainer?.webView?.title
        vc.pageURL = tabContainer?.currentTab?.webContainer?.webView?.url?.absoluteString
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func addToHomeScreen()
    {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddToHomeVC") as! AddToHomeVC
        vc.pageIconURL = tabContainer?.currentTab?.webContainer?.favicon?.getPreferredURL()
        vc.pageTitle = tabContainer?.currentTab?.webContainer?.webView?.title
        vc.pageURL = tabContainer?.currentTab?.webContainer?.webView?.url?.absoluteString
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func didSelectEntry(with url: URL?) {
        guard let url = url else { return }
        tabContainer?.loadQuery(string: url.absoluteString)
    }
    
  
    
    @objc func showTabTray() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let vc = TabTrayViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.addTapPress = { [weak self] in
                self?.addTab()
            }
            self.present(vc, animated: true, completion: nil)
        }
       
    }
    
}
extension MainViewController: UIPopoverPresentationControllerDelegate {
    
    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool
    {
        return true
    }
}
extension MainViewController {
    /// This function will set all the required properties, and then provide a preview for the document
    func share(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
       // activityVC.excludedActivityTypes = [.print]
        activityVC.excludedActivityTypes = [
            .assignToContact,
            .print,
            .addToReadingList,
            .saveToCameraRoll,
            .openInIBooks,
            UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
            UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"),
        ]
        activityVC.completionWithItemsHandler = { _, completed, _, _ in
            if completed {
            }
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
               if let popup = activityVC.popoverPresentationController {
                   popup.sourceView = self.view
                   popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
               }
           }
        self.present(activityVC, animated: true, completion: nil)
    }
    
    /// This function will store your document to some temporary URL and then provide sharing, copying, printing, saving options to the user
    func storeAndShare(withURLString: String) {
        guard let url = URL(string: withURLString) else { return }
        /// START YOUR ACTIVITY INDICATOR HERE
        loadingView.show(view: view, color: UIColor.gray)
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let pathEntension = url.pathExtension
            let tmpURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(response?.suggestedFilename ?? "\(Date().timeIntervalSinceNow).\(pathEntension)")
            do {
                try data.write(to: tmpURL)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                /// STOP YOUR ACTIVITY INDICATOR HERE
                self.loadingView.hide()
                self.share(url: tmpURL)
            }
            }.resume()
    }
}

extension MainViewController: UIDocumentInteractionControllerDelegate {
    /// If presenting atop a navigation stack, provide the navigation controller in order to animate in a manner consistent with the rest of the platform
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}
