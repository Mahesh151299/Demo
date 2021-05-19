//
//  TabCollectionViewCell.swift
//  Browser App
//
//  Created by Gaurav Gupta.
//  .
//

import UIKit

protocol TabTrayCellDelegate: class {
    func didTapCloseBtn(tabCell: TabCollectionViewCell, tag: Int)
}

class TabCollectionViewCell: UICollectionViewCell {
    var screenshotView: UIImageView!
    var faviconView: UIImageView!
    var pageTitle: UILabel!
    var viewUpper: UIView!
    var closeTabButton: UIButton!
    
    weak var delegate: TabTrayCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        screenshotView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.backgroundColor = .white
            self.contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(self.contentView)
            }
        }
        
        viewUpper = UIView().then {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.35)
            
            self.contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.top.equalTo(self)
                make.height.equalTo(30)
                make.left.equalTo(self)
            }
        }
        
        faviconView = UIImageView().then {
            $0.image = UIImage(named: "globe")
            $0.contentMode = .scaleAspectFit

            self.viewUpper?.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.width.equalTo(15)
                make.height.equalTo(15)
                make.left.equalTo(10)
                make.centerY.equalTo(self.viewUpper)
               // make.bottom.equalTo(self.contentView).offset(-8)
            }
        }
        
      
        
        closeTabButton = UIButton(type: .custom).then {
         //   $0.setTitle("Close", for: .normal)
            $0.setImage(UIImage(named: "menu_close"), for: .normal)
            $0.tintColor = .white
           // $0.setTitleColor(.white, for: .normal)
//            $0.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
//            $0.layer.cornerRadius = 5
            $0.addTarget(self, action: #selector(tappedClose(sender:)), for: .touchUpInside)
            
            self.viewUpper?.addSubview($0)
            $0.snp.makeConstraints { make in
                make.height.equalTo(20)
                make.width.equalTo(20)
                make.top.right.equalTo(self.contentView).inset(8)
            }
        }
        pageTitle = UILabel().then {
            self.viewUpper?.addSubview($0)
            $0.textAlignment = .left
            $0.textColor = .white
            $0.snp.makeConstraints { make in
                make.left.equalTo(self.faviconView.snp.right).offset(5)
//               // make.centerY.equalTo(faviconView)
//                make.right.equalTo(self.contentView).offset(-8)
               // make.left.equalTo(10)
                make.right.equalTo(self.closeTabButton.snp.left).offset(5)
                make.centerY.equalTo(self.viewUpper)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tappedClose(sender: UIButton) {
        delegate?.didTapCloseBtn(tabCell: self, tag: sender.tag)
    }
}
