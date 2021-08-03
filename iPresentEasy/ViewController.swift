//
//  ViewController.swift
//  iPresentEasy
//
//  Created by Diana Febrina Lumbantoruan on 21/07/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var grabAttention: UITextField!
    @IBOutlet weak var stateTopic: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPresentation()
    }
    
    func fetchPresentation() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Presentation")
        
        do {
            let presentations = try managedObjectContext.fetch(fetchRequest)
            
            for data in presentations {
                print(data.value(forKey: "attention") ?? nil)
                print(data.value(forKey: "stateTopic") ?? nil)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func saveContent(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let presentationEntity = NSEntityDescription.entity(forEntityName: "Presentation", in: managedObjectContext)!
        
        let presentation = NSManagedObject(entity: presentationEntity, insertInto: managedObjectContext)
        
        presentation.setValue(grabAttention.text, forKey: "attention")
        presentation.setValue(stateTopic.text, forKey: "stateTopic")
        
        do {
            try managedObjectContext.save()
            print("Berhasil")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

