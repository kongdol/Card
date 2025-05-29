//
//  ResultViewController.swift
//  Card
//
//  Created by yk on 5/30/25.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var levelView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layerLevlView()
        
    }

    func layerLevlView() {
        levelView.layer.borderColor = UIColor.black.cgColor
        levelView.layer.borderWidth = 5.0
        levelView.layer.cornerRadius = 8.0
    }

    

}
