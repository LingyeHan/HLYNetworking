//
//  ViewController.swift
//  HLYNetworking
//
//  Created by LingyeHan on 09/11/2020.
//  Copyright (c) 2020 LingyeHan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let service = ModuleService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMember()
    }
    
    @IBAction func getRequestAction(_ sender: Any) {
        fetchMember()
    }
    
    func fetchMember() {
        service.fetchMember { (result) in
            switch result {
            case .success(let member):
                print("获取数据成功: \(member)")
            case .failure(let error):
                print("获取数据失败: \(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

