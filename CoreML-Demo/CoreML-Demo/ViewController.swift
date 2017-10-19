//
//  ViewController.swift
//  CoreML-Demo
//
//  Created by Devil on 2017/10/16.
//  Copyright © 2017年 Devil. All rights reserved.
//

import UIKit
import SnapKit

import Photos

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

@available(iOS 11.0, *)
class ViewController: UIViewController{
    
    var yvTableView: UITableView!
    
    let yvNameOfClasses: Array<Dictionary<String,UIViewController.Type>> =
        [["MobileNetDemo":MobileNetViewController.self],
         ["SqueezeNetDemo":SqueezeNetViewController.self],
         ["GoogLeNetPlacesDemo":GoogLeNetPlacesViewController.self],
         ["Resnet50Demo":Resnet50ViewController.self],
         ["Inceptionv3Demo":Inceptionv3ViewController.self],
         ["VGG16VDemo":VGG16ViewController.self]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initUI() {
        self.title = "CoreML-Demo"
        yvTableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: .plain)
        yvTableView.rowHeight = 60
        yvTableView.delegate = self
        yvTableView.dataSource = self
        yvTableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.view.addSubview(yvTableView)
    }
}
@available(iOS 11.0, *)
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yvNameOfClasses.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = yvNameOfClasses[indexPath.row].keys.first
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vcT =  yvNameOfClasses[indexPath.row].values.first
        let vc = vcT?.init()
        vc?.title = yvNameOfClasses[indexPath.row].keys.first
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

