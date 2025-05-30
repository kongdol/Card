//
//  ResultViewController.swift
//  Card
//
//  Created by yk on 5/30/25.
//

import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var levelView: UIView!
    
    var currentLevel = 0
    
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var wrongLabel: UILabel!
    
   
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var levImage: UIImageView!
    
    
    @IBOutlet weak var correctRateLabel: UILabel!
    
    
    @IBAction func continueButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    var corrctRate: Int {
        return successCount * 100 / (successCount + wrongAttempts)
    }
    var successCount: Int = 0
    var wrongAttempts = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layerLevlView()
        checkLevel()
        
        correctLabel.text = "\(successCount)"
        wrongLabel.text = "\(wrongAttempts)"
        correctRateLabel.text = "정답률 \(corrctRate)%"
    }

    func layerLevlView() {
        levelView.layer.borderColor = UIColor.black.cgColor
        levelView.layer.borderWidth = 5.0
        levelView.layer.cornerRadius = 8.0
    }

    
    func checkLevel() {
        switch corrctRate {
        case 85...100:
            currentLevel += 1
            levImage.image = UIImage(systemName: "arrowshape.up.fill")
            levImage.tintColor = .systemRed
            levelLabel.text = "레벨 \(currentLevel)"
        case 65..<85:
            levImage.image = UIImage(systemName: "arrowshape.forward.fill")
            levImage.tintColor = .black
            levelLabel.text = "레벨 \(currentLevel)"
        default:
            levImage.image = UIImage(systemName: "arrowshape.down.fill")
            levImage.tintColor = .systemBlue
            currentLevel -= 1
            levelLabel.text = "레벨 \(currentLevel)"
            
            if currentLevel == 0 {
                currentLevel = 1
                levelLabel.text = "레벨 \(currentLevel)"
                levImage.image = UIImage(systemName: "arrowshape.forward.fill")
                levImage.tintColor = .black
            }
        }
    }
    

}
