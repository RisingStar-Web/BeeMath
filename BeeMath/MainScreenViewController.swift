//
//  MainScreenViewController.swift
//  BeeMath
//
//  Created by Денис Марков on 3/6/19.
//  Copyright © 2019 Денис Марков. All rights reserved.
//

import UIKit

fileprivate let levelCellReuseIdentifier = "levelCellReuseIdentifier"
fileprivate let levelCellNibName = "LevelCollectionViewCell"

class MainScreenViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var darkView: UIView!
    
    @IBOutlet weak var tapToStartButton: UIButton!  {
        didSet {
            tapToStartButton.addTarget(self, action: #selector(tapToPlayButtonDidTap), for: .touchUpInside)
        }
    }
    let levels = Constants.numbers

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        checkFirstStart()
        collectionView.register(UINib(nibName: levelCellNibName, bundle: nil), forCellWithReuseIdentifier: levelCellReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    func checkFirstStart() {
        if !UserDefaults.standard.bool(forKey: "first_start") {
            darkView.isHidden = false
            UserDefaults.standard.set(true, forKey: "first_start")
        } else {
            darkView.isHidden = true
        }
    }
    
    @objc func tapToPlayButtonDidTap() {
        darkView.isHidden = true
    }
    

}

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: levelCellReuseIdentifier, for: indexPath) as! LevelCollectionViewCell
        if indexPath.item < levels.count {
            cell.setupCell(level: levels[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < levels.count {
            let level = levels[indexPath.item]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let gameVC = storyboard.instantiateViewController(withIdentifier: "BeeGameViewController") as? BeeGameViewController {
                gameVC.leftOperand = level
                self.navigationController?.pushViewController(gameVC, animated: true)
            }
        }
    }
    
    
}

extension MainScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 10
        return CGSize(width: width, height: width)
    }
}
