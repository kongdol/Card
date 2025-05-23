//
//  ViewController.swift
//  Card
//
//  Created by yk on 5/16/25.
//

import UIKit

class CardViewController: UIViewController {
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    var firstSelectedIndexPath: IndexPath? // 첫번째 선택 셀 위치
    var secondSelectedIndexPath: IndexPath? // 두번째 선택 셀 위치
    var isSelectionLocked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // 선택초기화, 잠금해제
    func resetSelection() {
        firstSelectedIndexPath = nil
        secondSelectedIndexPath = nil
        isSelectionLocked = false
    }
    
    func checkForMatch() {
        guard let firstIndex = firstSelectedIndexPath,
              let secondIndex = secondSelectedIndexPath,
              let firstCell = cardCollectionView.cellForItem(at: firstIndex) as? CardCollectionViewCell,
              let secondCell = cardCollectionView.cellForItem(at: secondIndex) as? CardCollectionViewCell
        else { return }
        
        let firstValue = firstCell.frontLabel.text
        let secondValue = secondCell.frontLabel.text
        
        if firstValue == secondValue {
            // 정답 0.5초 뒤에 사라짐
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                firstCell.isHidden = true
                secondCell.isHidden = true
                
                self.resetSelection()
            }
        } else {
            // 오답 1 초 뒤에 다시 뒤집힘
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                firstCell.flip()
                secondCell.flip()
                
                self.resetSelection()
            }
        }
    }
}



extension CardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 선택 잠금 중이면 클릭무시
        if isSelectionLocked { return }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else { return }
        
        // 같은셀 다시 클릭 못하게
        if indexPath == firstSelectedIndexPath { return }
        
        // 선택한 카드 숫자 보이게 뒤집기
        cell.flip()
        
        // 첫번째 선택
        if firstSelectedIndexPath == nil {
            firstSelectedIndexPath = indexPath
        }
        // 두번쨰 선택
        else if secondSelectedIndexPath == nil {
            secondSelectedIndexPath = indexPath
            
            // 두개 다 선택 됬으면 비교, 잠금
            isSelectionLocked = true
            checkForMatch()
        }
    }
}


extension CardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CardCollectionViewCell.self), for: indexPath) as! CardCollectionViewCell
        
        cell.frontLabel.text = [indexPath.row + 1].map(String.init).joined()
        
        
        return cell
    }
    
}


extension CardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        
        // Int로 하는이유 - 소수점오차로 UI 망가질까봐
        let width = (collectionView.bounds.width - flowLayout.minimumLineSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right) / 6
        
        let height = width * 1.4
        
        return CGSize(width: width, height: height)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    // 최소 라인여백
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    // 최소 셀여백
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
