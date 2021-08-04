//
//  SectionViewController.swift
//  iPresentEasy
//
//  Created by Mohammad Sulthan on 04/08/21.
//

import UIKit

class SectionViewController: UIViewController {
    
    var sectionArr = ["Introduction", "Body", "Conclusion"]

    @IBOutlet weak var sectionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionTableView.delegate = self
        sectionTableView.dataSource = self
    }
}

extension SectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionIdentifier") as! SectionTableViewCell
        
        let sectionList = sectionArr[indexPath.row]
        cell.sectionLabel.text = sectionList
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSection = sectionArr[indexPath.row]
        if let viewController = storyboard?.instantiateViewController(identifier: "contentView") as? ContentViewController {
            viewController.section = selectedSection
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
