//
//  AddressBar.swift
//  Browser App
//
//  Created by Gaurav Gupta on 1/31/17.
//  .
//

import UIKit

class AddressBar: UIView, UITextFieldDelegate {
    
    @objc static let standardHeight: CGFloat = 60
    @objc static let scrollHeight: CGFloat = 30
    var isHideSearchBar:Bool = false{
        didSet
        {
            self.stackView?.isHidden = isHideSearchBar
            self.lblTitle?.isHidden = !isHideSearchBar
        }
    }
	@objc var refreshButton: UIButton?
    @objc var addressField: UITextField?{
        didSet
        {
            self.lblTitle.text = addressField?.text
        }
    }
	@objc var menuButton: UIButton?
    @objc var homeButton: UIButton?
    @objc var shareButton: UIButton?
    @objc var viewSerach: UIView?
    @objc var viewHome: UIView?
    @objc var viewShare: UIView?
    @objc var viewTabs: UIView?
    @objc var viewMenu: UIView?
    @objc var secureButton: UIButton?
	@objc weak var tabContainer: TabContainerView?
    var tabCountButton: TabCountButton!
    var lblTitle: UILabel!
    @objc var stackView:UIStackView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = Colors.whiteBg
        stackView = UIStackView().then({ [unowned self] in
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 10
            self.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.left.equalTo(self).offset(8)
                make.right.equalTo(self).offset(-8)
                                make.top.equalTo(self).offset(12)
                                make.bottom.equalTo(self).offset(-12)
            }
        })
        viewHome = UIView().then { [unowned self] in
            
            stackView?.addArrangedSubview($0)
            $0.snp.makeConstraints { (make) in
                make.width.equalTo(25)
//                make.right.equalTo(self).offset(-8)
            }
        }
        homeButton = UIButton().then { [unowned self] in
            $0.setImage(UIImage(named: "home")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .black
            viewHome?.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.width.equalTo(25)
                make.height.equalTo(25)
                make.centerY.equalTo(viewHome!)
                make.centerX.equalTo(viewHome!)
//                make.right.equalTo(self).offset(-8)
            }
        }
        
        viewSerach = UIView().then({  [unowned self] in
            $0.backgroundColor = UIColor(red: 239/255, green: 241/255, blue: 245/255, alpha: 1.0)
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.borderWidth = 0.5
            $0.layer.cornerRadius = 18
            stackView?.addArrangedSubview($0)
            $0.snp.makeConstraints { (make) in
            }
        })
        
        secureButton = UIButton().then { [unowned self] in
            if #available(iOS 13.0, *) {
                $0.setImage(UIImage(systemName: "lock.fill"), for: .normal)
            } else {
                // Fallback on earlier versions
                $0.setImage(UIImage(named: "lockFill"), for: .normal)
                
            }
            $0.tintColor = .black
            viewSerach?.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.width.equalTo(20)
                make.height.equalTo(20)
                make.centerY.equalTo(self)
                make.left.equalTo(viewSerach!).offset(5)
            }
        }
        
        addressField = SharedTextField().then { [unowned self] in
            $0.placeholder = "Address"
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.inset = 8
            
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.keyboardType = .webSearch
            $0.delegate = self
            $0.clearButtonMode = .whileEditing
            
            if !isiPadUI {
                $0.inputAccessoryView = DoneAccessoryView(targetView: $0, width: UIScreen.main.bounds.width).then { obj in
                    obj.doneButton?.setTitle("Cancel", for: .normal)
                    obj.doneButton?.snp.updateConstraints { make in
                        make.width.equalTo(60)
                    }
                }
            }
            
            viewSerach?.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.left.equalTo(self.secureButton!.snp.right).offset(0)
                make.top.equalTo(self).offset(8)
                make.bottom.equalTo(self).offset(-8)
                make.right.equalTo(self.viewSerach!).offset(0)
            }
        }
        
        refreshButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20)).then {
            if #available(iOS 13.0, *) {
                $0.setImage(UIImage(systemName:"arrow.clockwise")?.withRenderingMode(.alwaysTemplate), for: .normal)
            } else
            {
                $0.setImage(UIImage.imageFrom(systemItem: .refresh)?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
            $0.backgroundColor = UIColor(red: 239/255, green: 241/255, blue: 245/255, alpha: 1.0)
            $0.tintColor = .gray
            addressField?.rightView = $0
            addressField?.rightViewMode = .always
        }
        
        viewShare = UIView().then { [unowned self] in
            $0.isHidden = true
            stackView?.addArrangedSubview($0)
            $0.snp.makeConstraints { (make) in
                make.width.equalTo(25)
//                make.right.equalTo(self).offset(-8)
            }
        }
        shareButton = UIButton().then { [unowned self] in
            $0.setImage(UIImage(named: "share"), for: .normal)
            $0.tintColor = .black
            viewShare?.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.width.equalTo(25)
                make.height.equalTo(25)
                make.centerY.equalTo(viewShare!)
                make.centerX.equalTo(viewShare!)
            }
        }
        
        viewTabs = UIView().then { [unowned self] in
            
            stackView?.addArrangedSubview($0)
            $0.snp.makeConstraints { (make) in
                make.width.equalTo(25)
//                make.right.equalTo(self).offset(-8)
            }
        }
        
        tabCountButton = TabCountButton().then {
            viewTabs?.addSubview($0)
            $0.snp.makeConstraints { make in
//                make.height.equalTo(TabContainerView.standardHeight - 5)
//                make.width.equalTo(TabContainerView.standardHeight - 5)
                make.width.equalTo(25)
               // make.height.equalTo(25)
                make.height.equalTo(25)
                make.centerY.equalTo(viewTabs!)
                make.centerX.equalTo(viewTabs!)
            }
        }
        
        viewMenu = UIView().then { [unowned self] in
            
            stackView?.addArrangedSubview($0)
            $0.snp.makeConstraints { (make) in
                make.width.equalTo(25)
//                make.right.equalTo(self).offset(-8)
            }
        }
		
		menuButton = UIButton().then { [unowned self] in
			$0.setImage(UIImage(named: "menu"), for: .normal)
            $0.tintColor = .black
            viewMenu?.addSubview($0)
			$0.snp.makeConstraints { (make) in
				make.width.equalTo(25)
                make.height.equalTo(25)
                make.centerY.equalTo(viewMenu!)
                make.centerX.equalTo(viewMenu!)
			//	make.height.equalTo(25)
//				make.centerY.equalTo(self)
//				make.right.equalTo(self).offset(-8)
			}
		}
        
        
        
        
       
        lblTitle = UILabel().then { [unowned self] in
            $0.text = ""
            $0.textColor = .black
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.isHidden = true
            $0.textAlignment = .center
            self.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.width.equalTo(200)
                make.height.equalTo(20)
                make.centerY.equalTo(self)
                make.centerX.equalTo(self)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    @objc func setupNaviagtionActions(forTabConatiner tabContainer: TabContainerView) {
        refreshButton?.addTarget(tabContainer, action: #selector(tabContainer.refresh(sender:)), for: .touchUpInside)
    }
	
	// MARK: - Actions
	
	@objc func setAddressText(_ text: String?) {
		guard let _ = addressField else { return }
		
		if !addressField!.isFirstResponder {
			addressField?.text = text
            checkForLocalhost()
		}
	}
	
	@objc func setAttributedAddressText(_ text: NSAttributedString) {
		guard let _ = addressField else { return }
		
		if !addressField!.isFirstResponder {
			addressField?.attributedText = text
            checkForLocalhost()
		}
	}
    
    func checkForLocalhost() {
        if let address = addressField?.text, address.contains("localhost") {
            addressField?.text = ""
        }
    }
    
    // MARK: - Textfield Delegate
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		tabContainer?.loadQuery(string: textField.text)
		textField.resignFirstResponder()
		return true
	}
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
		if let string = textField.attributedText?.mutableCopy() as? NSMutableAttributedString {
			string.setAttributes(convertToOptionalNSAttributedStringKeyDictionary([:]), range: NSRange(0..<string.length))
			textField.attributedText = string
		}
        if let text = textField.text, !text.isEmpty {
            textField.selectAll(nil)
        }
    }
    
    func managePrivateTabColor(isPrivate:Bool)
    {
        self.backgroundColor = isPrivate ? Colors.darkBg : Colors.whiteBg
        self.viewSerach?.backgroundColor = isPrivate ? Colors.darkBg : UIColor(red: 239/255, green: 241/255, blue: 245/255, alpha: 1.0)
        self.addressField?.textColor = isPrivate ? .white : .black
        self.menuButton?.tintColor = isPrivate ? .white : .black
        self.secureButton?.tintColor = isPrivate ? .white : .black
        self.tabCountButton.setTitleColor(isPrivate ? .white : .black, for: .normal)
        self.tabCountButton.layer.borderColor = isPrivate ? UIColor.white.cgColor : UIColor.black.cgColor
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
