//
//  DetailViewController.swift
//  BonusExchange1
//
//  Created by 水平嵐 on 2016/3/20.
//  Copyright (c) 2016年 Arashi Chen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, NSURLSessionDelegate//, NSURLSessionDownloadDelegate
{


    @IBOutlet weak var pickerTextField: UITextField!
    @IBOutlet weak var pickerTextField2: UITextField!
    @IBOutlet weak var keyworkTextField: UITextField!
    @IBOutlet weak var lastptTextField: UITextField!
    @IBOutlet weak var mostptTextField: UITextField!
    @IBAction func btnSearch(sender: AnyObject) {
        postUrlToHappyGoApi()
    }
    
    var pickerData: [String] = [String]()
    
    var pickerData2: [String] = [String]()

    var resultTitles = [String]()
    var resultIds = [String]()
    
    // 儲存json資料物件
    var dataArray = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect data
        self.keyworkTextField.delegate = self
        self.lastptTextField.delegate = self
        self.mostptTextField.delegate = self
        
        // 初始化各欄位的鍵盤狀態
        self.keyworkTextField.keyboardType = UIKeyboardType.Default
        self.lastptTextField.keyboardType = UIKeyboardType.NumberPad // 將鍵盤設定為數字鍵盤
        self.mostptTextField.keyboardType = UIKeyboardType.NumberPad
        
        // 選單功能
        let pickerView = UIPickerView()
        pickerView.tag = 1

        pickerView.delegate = self
        pickerTextField.inputView = pickerView
        pickerTextField.text = "全部"

        // Connect data:
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.reloadAllComponents()

//        pickerData = ["全部", "餐廳美食", "咖啡茶館", "eTag儲值金", "娛樂玩家", "旅遊住宿", "折抵金", "商品券", "民生生活", "交通運輸", "3C家電", "時尚購物", "美妝保養", "美好回憶", "心靈饗宴", "經典美味", "茶點飲品", "天然保養"]
        let pickerUrl = NSURL(string: "https://ebank.feib.com.tw/feibhappygoapi/api/listProductSubCate.do")
        let session = NSURLSession.sharedSession()
        let dataTask = session.downloadTaskWithURL(pickerUrl!)
        dataTask.resume()
        do {
            let pickerDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: pickerUrl!)!, options: .AllowFragments)
            print("Get JSON!!")
            let pickerDicArray = pickerDic["list"] as! [[String: AnyObject]]
            
            for pickerdt in pickerDicArray {
                if let title = pickerdt["title"] as? String {
                    resultTitles.append(title)
                }
                if let id = pickerdt["id"] as? String {
                    resultIds.append(id)
                }
            }
        } catch {
            print("Parse JSON ERR : \(error)")
        }
        


//        pickerArray = {["title": "美妝保養","id": "04"]}

        // 選單功能2
        let pickerView2 = UIPickerView()
        pickerView2.tag = 2
        
        pickerView2.delegate = self
        pickerTextField2.inputView = pickerView2
        pickerTextField2.text = "免費兌換"
        
        // Connect data:
        pickerView2.delegate = self
        pickerView2.dataSource = self
        
        // Input data into the Array:
        pickerData2 = ["免費兌換", "點數+自費兌換"]
        
        // 選單功能上的 ToolBar & ToolBar Butoon
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.Default
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.magentaColor()
        
        // 程式定義ToolBar上各按鈕
//        let defaultButton = UIBarButtonItem(title: "Default", style: UIBarButtonItemStyle.Plain, target: self, action: "tappedToolBarBtn:")
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "donePressed:")
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
//        label.text = "Pick one number"
        label.textAlignment = NSTextAlignment.Center
        
        let textBtn = UIBarButtonItem(customView: label)

        // ToolBar的排列格式
//        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        toolBar.setItems([flexSpace,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        pickerTextField.inputAccessoryView = toolBar
        pickerTextField2.inputAccessoryView = toolBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 點擊它處即隱藏鍵盤
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.keyworkTextField.resignFirstResponder()
        self.lastptTextField.resignFirstResponder()
        self.mostptTextField.resignFirstResponder()
    }
    // 點擊鍵盤上的Return即隱藏鍵盤
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func donePressed(sender: UIBarButtonItem) {
        pickerTextField.resignFirstResponder()
        pickerTextField2.resignFirstResponder()
    }

    func tappedToolBarBtn(sender: UIBarButtonItem) {
        
        pickerTextField.text = "全部"
        pickerTextField.resignFirstResponder()
        
        pickerTextField2.text = "免費兌換"
        pickerTextField2.resignFirstResponder()
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1){
            return resultTitles.count
        } else {
            return pickerData2.count
        }
    }

    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1){
            return resultTitles[row]
        } else {
            return pickerData2[row]
        }
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1){
            pickerTextField.text = resultTitles[row]
        } else {
            pickerTextField2.text = pickerData2[row]
        }
    }

    func postUrlToHappyGoApi() {
        
        print("YA! Query Start!")
        
        // i兌換網址
        var urlAppend = "https://ebank.feib.com.tw/feibhappygoapi/api/listEventProduct.do?lat=7&lng=1&orderby=1&status=1"
        
//        let url = NSURL(string: "https://ebank.feib.com.tw/feibhappygoapi/api/listEventProduct.do?lat=7&lng=1&orderby=1&status=1")//&pageNo=1&pageItems=6")
        
        let keyword = self.keyworkTextField.text as String!
        
        if keyword.characters.count > 0 {
            urlAppend = urlAppend.stringByAppendingString("&keyword=" + keyword)
        }

        // NSURL不能處理中文，需要先轉換為UTF－8
        let urlString = NSURL(string: urlAppend.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        print("Input keyword is :", keyword)
        print("urlstring is :", urlString)
        
        // 建立一般的session設定
//        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        // 設定委任對象為自己
//        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        let session = NSURLSession.sharedSession()
        // 設定下載網址
        let dataTask = session.downloadTaskWithURL(urlString!)
        // 啟動或重新啟動下載動作
        dataTask.resume()
        
//        var prdImgUrl = [String]()
        do {
            let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: urlString!)!, options: .AllowFragments)
            print("Get JSON!!")
            dataArray = dataDic["list"] as! [[String: AnyObject]]
        } catch {
            print("Parse JSON ERR : \(error)")

        }
    }
    
    // 把資料傳到SearchResultViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "searchDetailSegue" {
            let detailVC = segue.destinationViewController as! SearchResultViewController
            detailVC.dataArray = dataArray
        }
    }
}

