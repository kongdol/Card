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
        
        frontLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 30, weight: .bold)
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        
        
        
        frontView.isHidden = true
        backView.isHidden = false
        isFlipped = true
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
