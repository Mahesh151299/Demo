//
//  TabView.swift
//  Browser App
//
//  Created by Gaurav Gupta on 1/31/17.
//  .
//

import UIKit

protocol TabViewDelegate: class {
	func didTap(tab: TabView)
	func close(tab: TabView) -> Bool
    func scrollViewScroll(scrollView:UIScrollView)
}

class TabView: UIView, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    @objc var shapeLayer: CAShapeLayer?
    
    @objc var tabTitle: String? {
        didSet {
            tabTitleLabel?.text = tabTitle
        }
    }
    @objc var tabTitleLabel: UILabel?
    @objc var tabImageView: UIImageView?
	
	weak var delegate: TabViewDelegate?
	
	@objc var webContainer: WebContainer?

	@objc init(parentView: UIView) {
        super.init(frame: .zero)
        
        self.backgroundColor = Colors.whiteBg
		
		let closeBtn = UIButton().then { [unowned self] in
			$0.setImage(UIImage.imageFrom(systemItem: .stop)?.makeThumbnailOfSize(size: CGSize(width: 15, height: 15)), for: .normal)
			$0.addTarget(self, action: #selector(self.close(sender:)), for: .touchUpInside)
			
			self.addSubview($0)
			$0.snp.makeConstraints { (make) in
				make.height.equalTo(self).offset(-25)
				make.width.equalTo(self.snp.height).offset(-25)
				make.right.equalTo(self).offset(-14)
				make.centerY.equalTo(self)
			}
		}
		tabTitleLabel = UILabel().then { [unowned self] in
			$0.text = "New Tab"
            $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize - 0.5)
			
			self.addSubview($0)
			$0.snp.makeConstraints { (make) in
				//make.left.equalTo(self.tabImageView!.snp.right).offset(4)
                make.left.equalTo(self).offset(13)
				make.top.equalTo(self).offset(6)
				make.bottom.equalTo(self).offset(-6)
				make.right.equalTo(closeBtn.snp.left).offset(-4)
			}
		}
		
		let gesture = UITapGestureRecognizer()
        gesture.delegate = self
		gesture.addTarget(self, action: #selector(tappedTab))
        gesture.cancelsTouchesInView = false
		self.addGestureRecognizer(gesture)
		self.isUserInteractionEnabled = true
		
		webContainer = WebContainer(parent: parentView)
		webContainer?.tabView = self
        webContainer?.webView?.scrollView.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIControl {
            return false
        }
        
        return true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.blendCorner(corner: .All, shapeLayer: &shapeLayer, length: 10)
    }
	
	@objc func tappedTab(sender: UITapGestureRecognizer) {
		delegate?.didTap(tab: self)
	}
	
	@objc func close(sender: UIButton) {
		_ = delegate?.close(tab: self)
	}
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewScroll(scrollView: scrollView)
       
    }
    
    
}
