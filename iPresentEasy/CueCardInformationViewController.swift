//
//  CueCardInformationViewController.swift
//  iPresentEasy
//
//  Created by Mohammad Sulthan on 01/08/21.
//

import UIKit
import EventKit

class CueCardInformationViewController: UIViewController {
    @IBOutlet weak var presentationName: UITextField!
    @IBOutlet weak var durationPresentation: UITextField!
    @IBOutlet weak var presentationSchedule: UITextField!
    @IBOutlet weak var calendarSyncToggle: UISwitch!
    
    var duration =
    [ "5", "10" ]
    
    var store = EKEventStore()
    var durationPickerView = UIPickerView()
    var scheduleDatePicker = UIDatePicker()
    var comp = NSDateComponents()
    let eventStore = EKEventStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        durationPresentation.inputView = durationPickerView
        presentationSchedule.inputView = scheduleDatePicker
        
        durationPickerView.delegate = self
        durationPickerView.dataSource = self
        
        scheduleDatePicker.datePickerMode = .date
        scheduleDatePicker.addTarget(self, action: #selector(CueCardInformationViewController.scheduleDatePickerChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func scheduleDatePickerChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        let cal = NSCalendar.current
        
        comp = cal.dateComponents([.era, .day, .month], from: sender.date) as NSDateComponents
        
        presentationSchedule.text = dateFormatter.string(from: sender.date)
        presentationSchedule.resignFirstResponder()
    }
    
    func insertEvent(store: EKEventStore) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMMM-yyyy"
        
        let event:EKEvent = EKEvent(eventStore: store)
        let startDate = dateFormatter.date(from: presentationSchedule.text!)
        let endDate = startDate!.addingTimeInterval(2 * 60 * 60)
        
        event.title = presentationName?.text
        event.startDate = startDate
        event.endDate = endDate
        event.notes = "Informative Presentation"
        event.calendar = store.defaultCalendarForNewEvents
        
        do {
            try store.save(event, span: .thisEvent)
            print("Berhasil disinmapn")
            return true
        } catch let error as NSError {
            print("Failed to save event with error: \(error)")
            return false
        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
        // sync to Calendar or not
        if calendarSyncToggle.isOn {
            // calendar permission
            switch EKEventStore.authorizationStatus(for: .event) {
                case .authorized:
                    insertEvent(store: eventStore)
                case .denied:
                    let alert = UIAlertController(title: "Permission denied", message: "Your schedule will never be syncrhonized with Calendar.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Permission denied", style: .default))
                case .notDetermined:
                    eventStore.requestAccess(to: .event, completion: { [weak self] (granted: Bool, error: Error?) -> Void in
                        if granted {
                            print("Granted")
                        } else {
                            let alert = UIAlertController(title: "Permission denied", message: "Your schedule will never be syncrhonized with Calendar.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
                        }
                    })
                default:
                    print("Case default")
            }
        } else {
            print("Langsung simpan")
        }
    }
}

extension CueCardInformationViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 1 {
            return "minute"
        }
        return duration[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        durationPresentation.text = duration[row]
        durationPresentation.resignFirstResponder()
    }
}

extension CueCardInformationViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1 {
            return 1
        }
        return duration.count
    }
}
