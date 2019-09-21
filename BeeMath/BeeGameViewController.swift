//
//  ViewController.swift
//  BeeMath
//
//  Created by Денис Марков on 3/5/19.
//  Copyright © 2019 Денис Марков. All rights reserved.
//

import UIKit
import AVFoundation

fileprivate let beeCellReuseIdentifier = "BeeCellReuseIdentifier"

class BeeGameViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var beeView: UIView!
    @IBOutlet weak var beeImageView: UIImageView!
    @IBOutlet weak var targetLabel: UILabel! {
        didSet {
            targetLabel.layer.cornerRadius = targetLabel.frame.width / 2
            targetLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.layer.cornerRadius = 8
            backButton.layer.masksToBounds = true
            backButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
        }
    }
    @IBOutlet weak var whereIsMyHouseLabel: UILabel! {
        didSet {
            whereIsMyHouseLabel.layer.cornerRadius = 8
            whereIsMyHouseLabel.layer.masksToBounds = true
        }
    }
    
    var leftOperand = 2
    var level: Level?
    var currentSublevel = 0
    var rightAnswer = 0
    
    var fly = CAKeyframeAnimation(keyPath: "position")
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "EvidenceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: beeCellReuseIdentifier)
        collectionView.contentInset.bottom = 20
        level = Level(leftOperand: leftOperand)
        rightAnswer = level?.subLevels[currentSublevel].rightAnswer ?? 0
        targetLabel.text = "№ \(rightAnswer)"
        fly.duration = 1
    }
    
    func nextSublevel() {
        player?.stop()
        guard let level = level else { return }
        if currentSublevel < level.subLevels.count - 1 {
            currentSublevel += 1
            rightAnswer = level.subLevels[currentSublevel].rightAnswer
            targetLabel.text = "№ \(rightAnswer)"
            collectionView.reloadData()
            collectionView.isUserInteractionEnabled = true
        } else {
            cancelButtonDidTap()
        }
    }
    
    func beeFly(index: IndexPath) {
        if let evidenceCoordinate = collectionView.layoutAttributesForItem(at: index)?.frame.origin {
            playSound()
            let realEvidenceCoordinate =  collectionView.convert(evidenceCoordinate, to: collectionView.superview)
            let startPoint = beeImageView.convert(beeImageView.frame.origin, to: self.view)
            fly.values = [NSValue(cgPoint:startPoint), NSValue(cgPoint:realEvidenceCoordinate)]
            fly.setValue("move_bee", forKey: "animation_name")
            fly.delegate = self
            beeImageView.layer.add(fly, forKey: nil)
        }
    }
    
    func newBee() {
        let beeIndex = Int.random(in: 0..<3)
        switch beeIndex {
        case 0:
            beeImageView.image = #imageLiteral(resourceName: "bee")
            break
        case 1:
            beeImageView.image = #imageLiteral(resourceName: "beeLeft")
            break
        case 2:
            beeImageView.image = #imageLiteral(resourceName: "beeRight")
            break
        default:
            break
        }
        let startPoint = beeImageView.convert(CGPoint(x: UIScreen.main.bounds.maxX, y: beeImageView.frame.minY), to: self.view)
        fly.values = [NSValue(cgPoint:startPoint), NSValue(cgPoint:beeImageView.center)]
        fly.setValue("new_bee", forKey: "animation_name")
        fly.delegate = self
        beeImageView.layer.add(fly, forKey: nil)
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "bee", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func cancelButtonDidTap() {
        let vcs = self.navigationController?.viewControllers
        if ((vcs?.contains(self)) != nil) {
            self.navigationController?.popViewController(animated: false)
        } else {
            self.dismiss(animated: false, completion: nil)
        }
    }

}

extension BeeGameViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        guard let animName = anim.value(forKey: "animation_name") as? String else {
            return
        }
        switch animName {
        case "move_bee":
            newBee()
            break
        case "new_bee":
            nextSublevel()
            break
        default:
            break
        }
    }
    
}

extension BeeGameViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let level = level else { return 0}
        return level.subLevels[currentSublevel].evidences.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: beeCellReuseIdentifier, for: indexPath) as! EvidenceCollectionViewCell
        if let level = level, currentSublevel < level.subLevels.count, indexPath.item < level.subLevels[currentSublevel].evidences.count {
            cell.setUp(evidence: level.subLevels[currentSublevel].evidences[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let level = level, currentSublevel < level.subLevels.count, indexPath.item < level.subLevels[currentSublevel].evidences.count {
            let cellResult = level.subLevels[currentSublevel].evidences[indexPath.item].result
            if cellResult == rightAnswer {
                collectionView.isUserInteractionEnabled = false
                beeFly(index: indexPath)
            } else {
                level.subLevels[currentSublevel].evidences[indexPath.item].wrong = true
                collectionView.reloadItems(at: [indexPath])
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 + 5
        return CGSize(width: width, height: width + 20)
    }
    
    
}

