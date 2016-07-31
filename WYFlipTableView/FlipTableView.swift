//
//  FlipTableView.swift
//  segment
//
//  Created by 王颖 on 15/12/30.
//  Copyright © 2015年 王颖. All rights reserved.
//

import UIKit

@objc protocol FlipTableViewDelegate:NSObjectProtocol{
    @objc func scrollChangeToIndex(index :NSInteger)
}

class FlipTableView: UIView,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{
    var tableView :UITableView?
    var dataArray :NSMutableArray?
    var delegate :FlipTableViewDelegate?
    func initFlipTableView(frame: CGRect,contentArray :NSArray) {
        self.frame = frame
        self.dataArray = NSMutableArray()
        self.dataArray?.addObjectsFromArray(contentArray as [AnyObject])
        self.tableView = UITableView()
        self.tableView!.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
        self.tableView!.frame = self.bounds
        self.tableView!.bounces = false
        self.tableView!.scrollsToTop = true
        self.tableView!.pagingEnabled = true
        self.tableView!.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView!.showsVerticalScrollIndicator = false
        
        self.tableView!.delegate = self;
        self.tableView!.dataSource = self;
        self.addSubview(self.tableView!)
    }
    //tableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataArray?.count)!
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId :String = "cell"
        var cell :UITableViewCell?
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
            cell!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            cell!.contentView.backgroundColor = UIColor.clearColor()
            let vc :UIViewController = (self.dataArray?.objectAtIndex(indexPath.row))! as! UIViewController
            vc.view.frame = (cell?.bounds)!
            cell?.contentView.addSubview(vc.view)
        }
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.frame.size.width
    }
    //scrollViewController
    //MARK : 可能存在问题 #selector(FlipTableViewDelegate.scrollChangeToIndex(_:))
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (self.delegate?.respondsToSelector(#selector(FlipTableViewDelegate.scrollChangeToIndex(_:))) == true){
            let index :Int = Int(scrollView.contentOffset.y / self.frame.size.width)
            self.delegate?.scrollChangeToIndex(index + 1)
        }
    }
    func selectIndex(index :NSInteger){
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), atScrollPosition:UITableViewScrollPosition.None , animated: false)
        })
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}

