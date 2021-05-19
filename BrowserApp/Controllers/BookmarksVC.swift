//
//  BookmarksVC.swift
//  BrowserApp
//
//  Created by Gaurav on 14/03/21.
//

import UIKit
import RealmSwift

class BookmarksVC: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var lblNoBookmark: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @objc var notificationToken: NotificationToken!
    var realm: Realm!
    
    var bookmarks: Results<Bookmark>?
    var searchBookmarks: Results<Bookmark>?
    
    weak var delegate: HistoryNavigationDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        getBookmarks()
        self.showSearchBar(isShow: false)
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        self.showSearchBar(isShow: true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func showSearchBar(isShow:Bool)
    {
        self.lblTitle.isHidden = isShow
        self.searchBar.isHidden = !isShow
        self.btnSearch.isHidden = isShow
    }
   
    func getBookmarks()
    {
        do {
            realm = try Realm()
            bookmarks = realm.objects(Bookmark.self)
          
            searchBookmarks = bookmarks
            notificationToken = bookmarks?.observe { [weak self] (changes: RealmCollectionChange) in
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial:
                    tableView.reloadData()
                case .update:
                    tableView.reloadSections([0], with: .automatic)
                case .error(let error):
                    logRealmError(error: error)
                }
            }
        } catch let error {
            logRealmError(error: error)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""
        {
            let predicate = NSPredicate(format: "name contains[c] %@ OR pageURL CONTAINS[c] %@", searchText,searchText)
            do {
            realm = try Realm()
            searchBookmarks = realm.objects(Bookmark.self).filter(predicate)
                self.tableView.reloadData()
            }
         catch let error {
            logRealmError(error: error)
         }
        }
        else
        {
            bookmarks = searchBookmarks
            self.tableView.reloadData()
        }
    }
    
    func showDropDownMenu(view:UIButton,index:Int)
    {
        let arrMenu = ["Edit","Delete"]
        let vc = storyboard?.instantiateViewController(withIdentifier: "DropDownMenuVC") as! DropDownMenuVC
        vc.isHideTopMenu = true
        vc.arrMenu = arrMenu
      
        vc.selectedMenu = {[weak self] selectedIndex in
            vc.dismiss(animated: true)
            switch selectedIndex {
            case 0:
               print("edit")
                self?.editBookmark(index: index)
            case 1:
                self?.deleteBookmark(index: index)
                print("delete")
           
            default:
                print("default")
            }
        }
        vc.modalPresentationStyle = .popover
        let popover = vc.popoverPresentationController
        vc.preferredContentSize = CGSize(width: 150, height: 100)
        popover?.delegate = self
        popover?.sourceView = view
        popover?.sourceRect = view.bounds
        popover?.permittedArrowDirections = .up
        popover?.canOverlapSourceViewRect = true
        vc.popoverPresentationController?.backgroundColor = UIColor.white
        self.present(vc, animated: true)
    }
    
    func editBookmark(index:Int)
    {
        let vc = AddBookmarkTableViewController(style: .plain)
        vc.bookmark = self.searchBookmarks?[index]
        vc.isComeForEdit = true
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func deleteBookmark(index:Int)
    {
        self.popupAlert(title: "Delete", message: "Are you sure you want to delete?", actionTitles: ["Cancel","OK"], actions:[{action1 in
            print("cancel press")
        },{action2 in
            print("ok press")
            do {
                try self.realm.write {
                    self.realm.delete(self.searchBookmarks!.filter("id = %@", self.searchBookmarks![index].id))
                }
            } catch let error as NSError {
                print("Could not delete object: \(error.localizedDescription)")
            }
        }, nil])
    }
    
   

}
extension BookmarksVC : UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.btnSearch.isHidden = searchBookmarks?.count == 0
        self.lblNoBookmark.isHidden = searchBookmarks?.count != 0
        self.lblNoBookmark.text = searchBar.text != "" ? "Search result not found" : "No bookmarks found"
        return searchBookmarks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellBookmark", for: indexPath) as! BookmarksListTableViewCell
//        cell.imgFavIcon?.image = UIImage(named: "globe")
//        cell.lblName.text = "Bookmark"
//        cell.lblUrl.text = defaultWebPage
       
        let bookmark = searchBookmarks?[indexPath.row]
        cell.lblName.text = bookmark?.name
        cell.lblUrl.text = bookmark?.pageURL
        if let iconURL = bookmark?.iconURL, iconURL != "", let imgURL = URL(string: bookmark!.iconURL) {
            cell.imgFavIcon?.sd_setImage(with: imgURL, placeholderImage: UIImage(named: "globe"))
        } else {
            cell.imgFavIcon?.image = UIImage(named: "globe")
        }
        cell.btnDropMenuPress = { [weak self] in
            self?.showDropDownMenu(view: cell.btnDropDown, index: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            self.dismiss(animated: true, completion: nil)
        }
        guard let bookmark = searchBookmarks?[indexPath.row] else { return }
        
        delegate?.didSelectEntry(with: URL(string: bookmark.pageURL))
    }
}
extension BookmarksVC: UIPopoverPresentationControllerDelegate {
    
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
