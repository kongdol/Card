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
    
    var cards: [Card] = []
    var wrongAttempts: Int = 0
    var currentLevel: Int = 1
    
    var pairCount: Int {
        return 10 + (currentLevel - 1) * 2
    }
    
    // 1 - 4열
    // 2~3 - 5열
    // 4~6 - 6열
    // 7~9 - 7열
    var itemsPerRow: Int {
        let count = pairCount * 2
        if count <= 20 { return 4 }       // 최대 20개면 4열
        else if count <= 30 { return 5 }  // 최대 30개면 5열
        else if count <= 42 { return 6 }  // 6열
        else { return 7 }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCard(for: currentLevel)
    }
    
    
    @IBAction func restartButton(_ sender: UIButton) {
        resetGame()
    }
    
    
    func resetGame() {
        // 오답 횟수 초기화
        wrongAttempts = 0
        // 선택 상태 초기화
        resetSelection()
        
        // 카드 배열 비우고 컬렉션뷰 초기화 -> 싹 사라지게
        cards.removeAll()
        cardCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.setupCard(for: self.currentLevel)
        }
        
    }
    
    // MARK: 랜덤으로 같은 숫자 10개
    private func setupCard(for level: Int) {
        // 1. 숫자범위 설정
        let numberRange: ClosedRange<Int>
        switch level {
        case 1:
            numberRange = 1...10
        case 2...3:
            numberRange = 1...15
        case 4...6:
            numberRange = 1...20
        default:
            numberRange = 1...25
        }
        
        // 2. 쌍 개수 계산: 레벨 1 -> 10쌍, 이후 2쌍씩 증가
        let pairCount = 10 + (level - 1) * 2
        
        // 3. 랜덤 숫자 뽑기 & 카드 만들기
        let randomNumbers = Array(numberRange).shuffled().prefix(pairCount)
        let duplicatedNumbers = (randomNumbers + randomNumbers).shuffled()
        
        // 애니메이션과 함께 리로드
        cards = duplicatedNumbers.map { Card(number: $0) }
        
        cardCollectionView.performBatchUpdates({
            cardCollectionView.reloadSections(IndexSet(integer: 0))
        }) { _ in
            // 새로 리로드된 셀들에 애니메이션 적용
            let cells = self.cardCollectionView.visibleCells
            for (index, cell) in cells.enumerated() {
                cell.alpha = 0
                UIView.animate(withDuration: 0.3, delay: 0.05 * Double(index), options: [], animations: {
                    cell.alpha = 1
                })
            }
        }
    }
    
    // MARK: 선택초기화, 잠금해제
    func resetSelection() {
        firstSelectedIndexPath = nil
        secondSelectedIndexPath = nil
        isSelectionLocked = false
    }
    
    // MARK: 정답오답확인
    func checkForMatch() {
        guard let firstIndex = firstSelectedIndexPath,
              let secondIndex = secondSelectedIndexPath
        else { return }
        
        let firstCard = cards[firstIndex.row]
        let secondCard = cards[secondIndex.row]
        
        
        guard let firstCell = cardCollectionView.cellForItem(at: firstIndex) as? CardCollectionViewCell,
              let secondCell = cardCollectionView.cellForItem(at: secondIndex) as? CardCollectionViewCell
        else { return }
        
        let isMatch = firstCard.number == secondCard.number
        
        if isMatch {
            // 정답
            cards[firstIndex.row].isMatched = true
            cards[secondIndex.row].isMatched = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                firstCell.isHidden = true
                secondCell.isHidden = true
                self.resetSelection()
            }
        } else {
            // 오답
            let isWrongAttempt = firstCard.hasBeenSeen || secondCard.hasBeenSeen
            
            if isWrongAttempt {
                wrongAttempts += 1
                print("오답횟수 : \(wrongAttempts)")
            }
            
            // 카드 뒤집은적 있다고 표시
            cards[firstIndex.row].hasBeenSeen = true
            cards[secondIndex.row].hasBeenSeen = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                firstCell.flip()
                secondCell.flip()
                self.resetSelection()
            }
        }
    }
}



