//
//  ViewController.swift
//  secondApp
//
//  Created by Alon Harari on 21/04/2019.
//  Copyright © 2019 Alon Harari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
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

        self.view.backgroundColor = UIColor(
            red: CGFloat(sliderR.value / 255.0) ,
            green: CGFloat(sliderG.value / 255.0),
            blue: CGFloat(sliderB.value / 255.0),
            alpha: 1)
    }
    
    fileprivate func setAlert() {
        let alert = UIAlertController(title: "Thanks!", message: "Please open host app to see the selected color", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sendColor(_ sender: Any) {
        UIPasteboard.general.color = self.view.backgroundColor
        setAlert()

    }
}

