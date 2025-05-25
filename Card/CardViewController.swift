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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCard(for: currentLevel)
        cardCheck()
    }
    
    
    @IBAction func restartButton(_ sender: UIButton) {
        resetGame()
    }
    
    func cardCheck(){
        
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
        
        print("생성된 카드 숫자 배열: \(cards.map { $0.number })")
        print("생성된 카드 숫자 오름차순 배열: \(cards.map { $0.number }.sorted())")
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
        
        cell.isHidden = false
        
        return cell
    }
    
}

// MARK: - DelegateFlowLayout - 크기,여백
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
