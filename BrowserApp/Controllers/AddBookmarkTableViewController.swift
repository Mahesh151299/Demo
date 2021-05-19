//
//  AddBookmarkTableViewController.swift
//  Browser App
//
//  Created by Gaurav Gupta on 2/9/17.
//  .
//

import UIKit
import RealmSwift


fileprivate let reuseidentifier = "bookmarkCell"

class AddBookmarkTableViewController: UITableViewController {
    
    @objc var pageIconURL: String?
    @objc var pageTitle: String?
    @objc var pageURL: String?
    
    @objc var titleTextField: UITextField?
    @objc var urlTextField: UITextField?
    
//    override var preferredContentSize: CGSize {
//        get {
//            return CGSize(width: 414, height: 200)
//        }
//        set { super.preferredContentSize = newValue }
//    }
    var isComeForEdit = false
    var bookmark: Bookmark?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = isComeForEdit ? "Edit Bookmark" : "Add Bookmark"
        if isComeForEdit{
            pageIconURL = bookmark?.iconURL
            pageTitle = bookmark?.name
            pageURL = bookmark?.pageURL
        }
        self.tableView.separatorStyle = .none
        self.navigationController?.navigationBar.barTintColor = Colors.whiteBg
        self.tableView.backgroundColor = Colors.whiteBg
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(done))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))

        tableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: reuseidentifier)
        tableView.register(UINib(nibName: "AddBookmarkTableViewCell", bundle: nil), forCellReuseIdentifier: "cellAddBookmark")
        
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func displayValidationError(for field: String) {
        let av = UIAlertController(title: "Error", message: "Please enter a \(field) for your bookmark.", preferredStyle: .alert)
        av.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(av, animated: true, completion: nil)
    }
    
    @objc func done() {
        guard let title = titleTextField?.text, title != "" else {
            displayValidationError(for: "title")
            return
        }
        guard let url = urlTextField?.text, url != "" else {
            displayValidationError(for: "URL")
            return
        }
        if isComeForEdit
        {
            do {
                let realm = try Realm()
                let bookmarks = realm.objects(Bookmark.self)
                let matchingProduct = bookmarks.filter("id == %@", bookmark?.id).first

                if let matchingProduct = matchingProduct {
                    do {
                        try realm.write {
                            matchingProduct.name = title
                            matchingProduct.pageURL = url
                        }
                    } catch {
                        // error Handling
                    }
                }
            } catch let error {
                logRealmError(error: error)
            }
        }
        else
        {
        let bookmark = Bookmark(value: ["id": UUID().uuidString, "name": title,
                                        "pageURL": url, "iconURL": pageIconURL ?? ""])
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(bookmark)
            }
        } catch let error {
            logRealmError(error: error)
        }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAddBookmark", for: indexPath) as? AddBookmarkTableViewCell
        if indexPath.row == 0
        {
            cell?.lblTitle.text = "Name"
            cell?.tfDetails.placeholder = "Bookmark name"
            titleTextField = cell?.tfDetails
            cell?.tfDetails.text = pageTitle
        }
        else
        {
            cell?.lblTitle.text = "URL"
            cell?.tfDetails.placeholder = "Bookmark URL"
            urlTextField = cell?.tfDetails
            cell?.tfDetails.text = pageURL
        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseidentifier, for: indexPath) as? BookmarkTableViewCell
//
////        if let pageIconURL = pageIconURL, let imgURL = URL(string: pageIconURL) {
////            cell?.imageView?.sd_setImage(with: imgURL, placeholderImage: UIImage(named: "globe"))
////        } else {
////            cell?.imageView?.image = UIImage(named: "globe")
////        }
//
//        titleTextField = cell?.titleTextField
//        urlTextField = cell?.urlTextField
//
//        cell?.titleTextField?.text = pageTitle
//        cell?.urlTextField?.text = pageURL
//
        return cell!
    }

}
