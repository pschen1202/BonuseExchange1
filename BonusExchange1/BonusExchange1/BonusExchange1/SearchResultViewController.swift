//
//  SearchResult.swift
//  BonusExchange1
//
//  Created by 水平嵐 on 2016/3/22.
//  Copyright (c) 2016年 Arashi Chen. All rights reserved.
//

import UIKit

class SearchResultViewController: UITableViewController, NSURLSessionDelegate {
//, NSURLSessionDelegate, NSURLSessionDownloadDelegate {

//    var sidemenu:Array<String> = ["搜尋商品"]
    // 儲存json資料物件
    var dataArray = [AnyObject]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (dataArray.count > 0) {
            print("get dataArray succeeded!!")
        } else {
            print("get file err!!")
        }
        //重新整理Table View
        self.tableView.reloadData()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "更新中")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let searchcell = tableView.dequeueReusableCellWithIdentifier("SearchDetailCell", forIndexPath: indexPath)

//        searchcell.textLabel!.text = dataArray[indexPath.row] as? String

//        print(dataArray[indexPath.row].count)
//        print(dataArray[indexPath.row]["product_image"])

        // 取得圖片，由JSON上取得圖片連結後，下載圖片
        var imgUrl = dataArray[indexPath.row]["product_image"]
        if imgUrl == nil {
            imgUrl = "http://ebank.feib.com.tw/feibhappygoapi/HG/upload/product/f200_s.jpg"
        }
        // MARK: creat session - 方式1
        //// 建立一般的session設定
        //let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        //// 設定委任對象為自己
        //let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        // MARK: creat session - 方式2
        let session = NSURLSession.sharedSession()
        
        // 設定下載網址
        let dataTask = session.downloadTaskWithURL(NSURL(string: imgUrl as! String)!)
        // 啟動或重新啟動下載動作
        dataTask.resume()
        
        // 重設圖片大小及定位
        if let imageData = NSData(contentsOfURL: NSURL(string: imgUrl as! String)!) {
            let cellImg : UIImageView = UIImageView(frame: CGRectMake(10, 10, 80, 80))
            cellImg.image = UIImage(data: imageData)
            searchcell.addSubview(cellImg)
        }
        // 取得brand_group_title
        if let bgtLabelData = dataArray[indexPath.row]["brand_group_title"] {
            let bgtLabel : UILabel = UILabel(frame: CGRectMake(101, 11, 300, 23))
            bgtLabel.text = bgtLabelData as? String
            bgtLabel.backgroundColor = UIColor.whiteColor()
            searchcell.addSubview(bgtLabel)
        }
        // 取得product_title
        if let ptLabelData = dataArray[indexPath.row]["product_title"] {
            let ptLabel : UILabel = UILabel(frame: CGRectMake(101, 41, 300, 23))
            ptLabel.text = ptLabelData as? String
            ptLabel.backgroundColor = UIColor.whiteColor()
            searchcell.addSubview(ptLabel)
        }
        // 取得product_title
        if let hppLabelData = dataArray[indexPath.row]["hg_pre_point"] {
            let hppLabel : UILabel = UILabel(frame: CGRectMake(101, 70, 300, 23))
            let hppLabelData = hppLabelData as? String
            hppLabel.text = "免費兌換: " + hppLabelData! + " 點"
            hppLabel.backgroundColor = UIColor.whiteColor()
            searchcell.addSubview(hppLabel)
        }
        return searchcell

    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        // 因預設會回傳一個UITableViewCell型態的通用Cell，所以使用as!強迫轉型成RestaurantTableViewCell
//        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath) as! UITableViewCell
//        cell.dic = dataArray[indexPath.row]
//        
//        // Configure the cell...
//        //cell.nameLable.text = restaurantNames[indexPath.row]
//        let startDate = dataArray[indexPath.row]["start_date"] as? String
//        let endDate = dataArray[indexPath.row]["end_date"] as? String
//        cell.peroidLable.text = startDate! + "~" + endDate!
//        //cell.locationLable.text = restaurantLocations[indexPath.row]
//        //cell.thumbnailImageView.image = UIImage(named: restaurantImages[indexPath.row])
//        // 讓縮圖變成圓形
//        //cell.thumbnailImageView.layer.cornerRadius = 30.0
//        //cell.thumbnailImageView.clipsToBounds = true
//        //cell.typeLable.text = restaurantTypes[indexPath.row]
//        cell.typeLable.text =  dataArray[indexPath.row]["title"] as? String
//        
//        if restaurantIsVisited[indexPath.row] {
//            cell.accessoryType = .Checkmark
//        }else {
//            cell.accessoryType = .None
//        }
//        
//        return cell
//    }
    
}
