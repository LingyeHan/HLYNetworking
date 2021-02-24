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
 
        service.fetchMember { (result) in
            switch result {
            case .success(let member):
                print("\n获取的数据: \(member)")
            case .failure(let error):
                print("\(error)")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

