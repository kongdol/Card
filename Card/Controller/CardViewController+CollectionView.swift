//
//  Untitled.swift
//  Card
//
//  Created by yk on 5/25/25.
//
import UIKit

// MARK: - Delegate - 선택했을때
extension CardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 선택 잠금 중이면 클릭무시
        if isSelectionLocked { return }
        
        if indexPath == firstSelectedIndexPath { return }
        
        let selectedCard = cards[indexPath.row]
        
        guard !selectedCard.isMatched else { return } // 이미 맞춘카드 클릭 무시
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else { return }
        
        
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

// MARK: - DataSource - 갯수, 내용
extension CardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CardCollectionViewCell.self), for: indexPath) as! CardCollectionViewCell
        
        let card = cards[indexPath.row]
        cell.frontLabel.text = String(card.number)
        cell.configure(level: currentLevel)
        
        cell.isHidden = false
        
        return cell
    }
    
}
