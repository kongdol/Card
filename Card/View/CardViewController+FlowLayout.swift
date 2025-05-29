//
//  Untitled.swift
//  Card
//
//  Created by yk on 5/25/25.
//
import UIKit

// MARK: - DelegateFlowLayout - 크기,여백
extension CardViewController: UICollectionViewDelegateFlowLayout {

    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 셀간 여백 설정
        let spacing: CGFloat = 8
        let sectionInset: CGFloat = 8
        
        // 총여백 = 셀 간 여백 + 좌우 인셋
        let totalSpacing = spacing  * CGFloat(itemsPerRow - 1) + sectionInset * 2
        let availableWidth = collectionView.bounds.width - totalSpacing

        // 셀너비계산
        let shrinkFactor: CGFloat = (itemsPerRow == 7 ? 0.92 : 1.0)
        let itemWidth = floor(availableWidth / CGFloat(itemsPerRow) * shrinkFactor)
        var itmeHeight = itemWidth * 1.4
        
        if currentLevel == 1 {
            itmeHeight *= 0.9
        }
        
        
        return CGSize(width: itemWidth, height: itmeHeight)
    }
    
    
    // 여백
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
