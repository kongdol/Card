//
//  CardCollectionViewCell.swift
//  Card
//
//  Created by yk on 5/17/25.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardContainerView: UIView!
    @IBOutlet weak var backView: UIView! // 이미지
    @IBOutlet weak var frontView: UIView! // 레이블
    
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var frontLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        
        frontView.isHidden = true
        backView.isHidden = false
        isFlipped = true
    }
    
    // 1/ 4열, 2~3/ 5열, 4~6/ 6열, 7/ 7열
    func configure(level: Int) {
        if level == 1 {
            frontLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 35, weight: .bold)
        } else if level <= 3 {
            frontLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 32, weight: .bold)
        } else if level <= 6 {
            frontLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 30, weight: .bold)
        } else {
            frontLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 26, weight: .bold)
        }
    }
    
    // 셀 재사용 될때도 상태 초기화
    override func prepareForReuse() {
        super.prepareForReuse()
        frontView.isHidden = true
        backView.isHidden = false
        isFlipped = true
    }
    
    var isFlipped = false
    
    func flip() {
        let fromView = isFlipped ? backView : frontView // 현재 화면에 보이는뷰
        let toView = isFlipped ? frontView : backView   // 나중에 보일 뷰
        
        UIView.transition(from: fromView!,
                          to: toView!,
                          duration: 0.4,
                          options: [
                            .transitionFlipFromLeft, .showHideTransitionViews]) { [weak self] _ in
                                self?.isFlipped.toggle()
                            }
        }
        
}
