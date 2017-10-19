//
//  GoogLeNetPlacesViewController.swift
//  CoreML-Demo
//
//  Created by Devil on 2017/10/19.
//  Copyright © 2017年 Devil. All rights reserved.
//

import UIKit
import YVImagePickerController
import VideoToolbox

@available(iOS 11.0, *)
class GoogLeNetPlacesViewController: UIViewController {
    var showImageV: UIImageView!
    var showLab: UILabel!
    
    let model = GoogLeNetPlaces()
    ///别名: 已经存在的类型赋值为新的名字
    typealias Prediction = (String, Double)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initUI()  {
        self.view.backgroundColor = UIColor.white
        addNavRightItem()
        showImageV = UIImageView()
        showImageV.backgroundColor = UIColor.gray
        showLab = UILabel()
        showLab.backgroundColor = UIColor.gray
        showLab.numberOfLines = 0
        self.view.addSubview(showImageV)
        self.view.addSubview(showLab)
        showImageV.snp.makeConstraints { (make) in
            make.width.height.equalTo(ScreenWidth-20)
            make.top.equalTo(self.view).offset(64+10)
            make.centerX.equalTo(self.view)
        }
        showLab.snp.makeConstraints { (make) in
            make.top.equalTo(showImageV.snp.bottom).offset(10)
            make.width.centerX.equalTo(showImageV)
        }
    }
    func addNavRightItem() {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 70, height: 35)
        btn.setTitle("添加", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(navRightItemClicked), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
    }
    @objc func navRightItemClicked()  {
        
        let pickerVC = YVImagePickerController()
        pickerVC.yvmediaType = .image
        pickerVC.yvcolumns = 4
        pickerVC.delegate = self
        self.present(pickerVC, animated: true, completion: nil)
    }
    
    func predictUsingCoreML(image: UIImage) {
        if let pixelBuffer = image.pixelBuffer(width: 224, height: 224),
            let prediction = try? model.prediction(sceneImage: pixelBuffer) {
            let top5 = top(5, prediction.sceneLabelProbs)
            show(results: top5)
            var imoog: CGImage?
            VTCreateCGImageFromCVPixelBuffer(pixelBuffer, nil, &imoog)
            self.showImageV.image = UIImage(cgImage: imoog!)
        }
    }
    
    func show(results: [Prediction]) {
        var s: [String] = []
        for (i, pred) in results.enumerated() {
            s.append(String(format: "%d: %@ (%3.2f%%)", i + 1, pred.0, pred.1 * 100))
        }
        self.showLab.text = s.joined(separator: "\n\n")
    }
    func top(_ k: Int, _ prob: [String: Double]) -> [Prediction] {
        precondition(k <= prob.count)
        
        return Array(prob.map { x in (x.key, x.value) }
            .sorted(by: { a, b -> Bool in a.1 > b.1 })
            .prefix(through: k - 1))
    }
}
@available(iOS 11.0, *)
extension GoogLeNetPlacesViewController: YVImagePickerControllerDelegate{
    func yvimagePickerController(_ picker: YVImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            if info["imagedata"] != nil{
                let img = info["imagedata"] as! UIImage
                self.predictUsingCoreML(image: img)
            }
        }
    }
    func yvimagePickerControllerDidCancel(_ picker: YVImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
