//
//  CustonTableViewCell.swift
//  +
//
//  Created by shensu on 17/4/5.
//  Copyright © 2017年 杨健. All rights reserved.
//

import UIKit

class CustonTableViewController: UITableViewController {
    var segumented: UISegmentedControl!
    var url = ""
    var modelArray = Array<Dictionary<String,Any>>()
    override func viewDidLoad() {
        super.viewDidLoad()
        loaddata()
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loaddata()
        })
//        let right = UIBarButtonItem(title: "试玩", style: .done, target: self, action: #selector(rightClick))
//        right.tintColor = UIColor.gray
//        self.navigationItem.rightBarButtonItem = right
        

    }
//    func rightClick(){
//        if Apploction.default.isLogin {
//            let   vc = GoucaiViewController()
//            vc.hidesBottomBarWhenPushed = true;
//            switch segumented.selectedSegmentIndex {
//            case 0:
//                vc.titlename = "幸运28"
//            default:
//                vc.titlename = "新加坡28"
//            }
//            vc.qishu = modelArray.first?["issue"]
//            _ = self.navigationController?.pushViewController(vc, animated: true)
//        }else{
//            
//            let vc = UIStoryboard(name: "LoginViewController", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController")
//            vc.hidesBottomBarWhenPushed = true
//            _  = self.navigationController?.pushViewController(vc, animated: true)
//            
//        }
//        
//        
//    }
    func loaddata(){
        
        HttpTools.postCustonCAIPIAO(withPath: self.url, parms: nil, success: { (resport) in
            if let data = resport as?  Array<Dictionary<String, Any>> {
                self.modelArray.removeAll()
                self.modelArray =  data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.mj_header.endRefreshing()
                }
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: "数据加载出错，请稍候再试")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                SVProgressHUD.dismiss()
            })
        }
     
   
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.modelArray.count + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //  let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? PCddTableViewCell
        cell = Bundle.main.loadNibNamed("PCddTableViewCell", owner: self, options: nil)?.first as! PCddTableViewCell?
        
        if indexPath.section == 0 {
            cell?.qishu.text = "期数"
            cell?.time.text = "开奖时间"
            cell?.jieguo.text = "开奖结果"
        }else{
            if modelArray.count > indexPath.section - 1{
                let model = modelArray[indexPath.section - 1]
                cell?.qishu.text = "第\(model["wareIssue"]!)期"
                let str = "\(model["PrizeTime"]!)"
                let index = str.index(str.startIndex, offsetBy: 5)
                let suffix = str.substring(from: index)
                cell?.time.text = suffix
                cell?.jieguo.text = model["wareResult"]! as? String
                cell?.qishu.backgroundColor = UIColor.init(red: 245.0/255.0, green: 225.0/255.0, blue: 210.0/255.0, alpha: 1)
                cell?.time.backgroundColor = UIColor.init(red: 245.0/255.0, green: 225.0/255.0, blue: 210.0/255.0, alpha: 1)
                cell?.jieguo.backgroundColor = UIColor.init(red: 245.0/255.0, green: 225.0/255.0, blue: 210.0/255.0, alpha: 1)
                cell?.jieguo.textColor = UIColor.gray
                cell?.time.textColor = UIColor.gray
                cell?.qishu.textColor = UIColor.gray
            }
        }
        cell?.selectionStyle = .none
        
        return cell!
    }
    

}