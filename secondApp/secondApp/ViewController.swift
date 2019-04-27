//
//  ViewController.swift
//  secondApp
//
//  Created by Alon Harari on 21/04/2019.
//  Copyright © 2019 Alon Harari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var RGBcolor:[String:Float] = ["R":255.0, "G":255.0, "B":255.0]
    @IBOutlet weak var sliderR: UISlider!
    @IBOutlet weak var sliderG: UISlider!
    @IBOutlet weak var sliderB: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(
            red: CGFloat(sliderR.value / 255.0) ,
            green: CGFloat(sliderG.value / 255.0),
            blue: CGFloat(sliderB.value / 255.0),
            alpha: 1)
    }

    
    @IBAction func sliderChangeValue(_ sender: Any) {
        RGBcolor["R"] = sliderR.value
        RGBcolor["G"] = sliderG.value
        RGBcolor["B"] = sliderB.value

        self.view.backgroundColor = UIColor(
            red: CGFloat(sliderR.value / 255.0) ,
            green: CGFloat(sliderG.value / 255.0),
            blue: CGFloat(sliderB.value / 255.0),
            alpha: 1)
    }
    
    @IBAction func sendColor(_ sender: Any) {
        print(RGBcolor)
        //let RGBstr = "\(RGBcolor["R"] ?? 255),\(RGBcolor["G"] ?? 255),\(RGBcolor["B"] ?? 255)"
        UIPasteboard.general.color = self.view.backgroundColor

//        let application = UIApplication.shared
//        let homeTestAppPath = "homeTestC://viewController?color=\(RGBstr)"
//        let appUrl = URL(string: homeTestAppPath)!
//        let websiteUrl = URL(string: "https://taboola.com")!
//        if application.canOpenURL(appUrl) {
//            application.open(appUrl, options: [:], completionHandler: nil)
//        } else {
//            application.open(websiteUrl)
//        }
    }
    
    


}

