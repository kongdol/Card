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
    var currentLevel: Int = 7
    
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
        // 카드 다시 섞고 상태 초기화
        setupCard(for: currentLevel)
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
        
        cards = duplicatedNumbers.map { Card(number: $0) }
        
//        print("생성된 카드 숫자 배열: \(cards.map { $0.number })")
//        print("생성된 카드 숫자 오름차순 배열: \(cards.map { $0.number }.sorted())")
        print("생성된 카드 갯수: \(cards.count)")
        
        // 4. 카드 뷰 갱신
        cardCollectionView.reloadData()
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



