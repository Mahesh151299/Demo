//
//  HistoryListVC.swift
//  BrowserApp
//
//  Created by Gaurav on 14/03/21.
//

import UIKit
import RealmSwift

protocol HistoryNavigationDelegate: class {
    func didSelectEntry(with url: URL?)
}


class HistoryListVC: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var lblNoHistoryFound: UILabel!
    @IBOutlet weak var btnClearHistory: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    weak var delegate: HistoryNavigationDelegate?
    
    @objc var notificationToken: NotificationToken!
    var realm: Realm!
    
    var history: Results<HistoryEntry>?
    var searchHistory: Results<HistoryEntry>?
    deinit {
      //  notificationToken.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHistoryList()
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
    
    @IBAction func btnClearHistory(_ sender: Any) {
        clearHistory()
    }
    
    
    func showSearchBar(isShow:Bool)
    {
        self.lblTitle.isHidden = isShow
        self.searchBar.isHidden = !isShow
        self.btnSearch.isHidden = isShow
    }
    
    func getHistoryList()
    {
        do {
            realm = try Realm()
            history = realm.objects(HistoryEntry.self).sorted(byKeyPath: "visitDate", ascending: false)
            searchHistory = history
            notificationToken = history?.observe { [weak self] (changes: RealmCollectionChange) in
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial:
                    tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    tableView.beginUpdates()
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                         with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                    tableView.endUpdates()
                case .error(let error):
                    logRealmError(error: error)
                }
            }
        } catch let error {
            logRealmError(error: error)
        }
        
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""
        {
            let predicate = NSPredicate(format: "pageTitle contains[c] %@ OR pageURL CONTAINS[c] %@", searchText,searchText)
            do {
            realm = try Realm()
                searchHistory = realm.objects(HistoryEntry.self).filter(predicate)
                self.tableView.reloadData()
            }
         catch let error {
            logRealmError(error: error)
         }
        }
        else
        {
            searchHistory = history
            self.tableView.reloadData()
        }
    }
    
    func deleteHistory(index:Int)
    {
        self.popupAlert(title: "Delete", message: "Are you sure you want to delete?", actionTitles: ["Cancel","OK"], actions:[{action1 in
            print("cancel press")
        },{action2 in
            print("ok press")
            do {
                try self.realm.write {
                    self.realm.delete(self.history!.filter("id = %@", self.history![index].id))
                }
            } catch let error as NSError {
                print("Could not delete object: \(error.localizedDescription)")
            }
        }, nil])
    }
    
    func clearHistory()
    {
        self.popupAlert(title: "Delete", message: "Are you sure you want to clear?", actionTitles: ["Cancel","OK"], actions:[{action1 in
            print("cancel press")
        },{action2 in
            print("ok press")
            do {
                try self.realm.write {
                    self.realm.delete(self.history!)
                }
            } catch let error as NSError {
                print("Could not delete object: \(error.localizedDescription)")
            }
        }, nil])
    }
   

}
extension HistoryListVC : UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.btnSearch.isHidden = searchHistory?.count == 0
        self.btnClearHistory.isHidden = searchHistory?.count == 0
        self.lblNoHistoryFound.isHidden = searchHistory?.count != 0
        self.lblNoHistoryFound.text = searchBar.text != "" ? "Search result not found" : "No history found"
        return searchHistory?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellHistory", for: indexPath) as! HistoryListTableViewCell
//        cell.imgFavIcon?.image = UIImage(named: "globe")
//        cell.lblName.text = "History"
//        cell.lblUrl.text = defaultWebPage
       
        let entry = searchHistory?[indexPath.row]
        if let pageTitle = entry?.pageTitle, pageTitle != "" {
            cell.lblName.text = pageTitle

            let attrString = getGrayDate(entry!.visitDate)
            attrString.append(NSAttributedString(string: entry!.pageURL))
            cell.lblUrl.attributedText = attrString
        } else {
            cell.lblName.text = entry?.pageURL
            cell.lblUrl.attributedText = getGrayDate(entry!.visitDate, attachDash: false)
        }
        cell.lblUrl.text = entry?.pageURL
        if let iconURL = entry?.iconURL, iconURL != "", let imgURL = URL(string: entry!.iconURL) {
                    cell.imgFavIcon?.sd_setImage(with: imgURL, placeholderImage: UIImage(named: "globe"))
                } else {
                    cell.imgFavIcon?.image = UIImage(named: "globe")
                }
        cell.btnCrossPress = { [weak self] in
            self?.deleteHistory(index: indexPath.row)
        }
        return cell
    }
    
    func getGrayDate(_ date: Date, attachDash: Bool = true) -> NSMutableAttributedString {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yy hh:mma"
        let dateString = df.string(from: date)
        
        return NSMutableAttributedString(string: "\(dateString)\((attachDash) ? " - " : "")", attributes: [.foregroundColor: UIColor.gray])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            self.dismiss(animated: true, completion: nil)
        }
        guard let pageURL = searchHistory?[indexPath.row].pageURL else { return }
        
        let url = URL(string: pageURL)
        delegate?.didSelectEntry(with: url)
    }
}
