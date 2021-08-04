//
//  ContentViewController.swift
//  iPresentEasy
//
//  Created by Mohammad Sulthan on 04/08/21.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var contentTableView: UITableView!
    
    var point = ["Grab Attention", "Reason To Listen", "State Topic"]
    var section = String()
    
    private var content: [Content] = []
    private var contents: Content?

    override func viewDidLoad() {
        super.viewDidLoad()
        contentTableView.delegate = self
        contentTableView.dataSource = self
        print(section)
        sectionTitle.text = section
    }
}

extension ContentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return point.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentIdentifier") as! ContentTableViewCell
        
        let sectionList = point[indexPath.row]
        cell.contentLabel.text = sectionList
        
        return cell
    }
}
