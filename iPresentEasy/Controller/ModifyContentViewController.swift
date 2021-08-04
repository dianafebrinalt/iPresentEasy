//
//  ModifyContentViewController.swift
//  iPresentEasy
//
//  Created by Mohammad Sulthan on 04/08/21.
//

import UIKit

class ModifyContentViewController: UIViewController {

    @IBOutlet weak var contentAreaCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ModifyContentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = contentAreaCollectionView.dequeueReusableCell(withReuseIdentifier: "content", for: indexPath) as? contentCollectionViewCell
        cell?.labelCollection.text = String(indexPath.row)
        return cell!
    }
    
    
}
