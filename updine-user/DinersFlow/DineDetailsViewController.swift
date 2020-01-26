//
//  DineDetailsViewController.swift
//  updine-user
//
//  Created by Yasin Ehsan on 1/15/20.
//  Copyright © 2020 Yasin Ehsan. All rights reserved.
//

import UIKit
import EventKit

class DineDetailsViewController: UIViewController {
    @IBOutlet weak var screenImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        screenImageView.image = UIImage(named: "")

        // Do any additional setup after loading the view.
    }
    
    //RSVP SONN
    @IBAction func calenderButtonTapped(_ sender: Any) {
        
        let eventStore:EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) {(granted, error) in
            if (granted) && (error) == nil
            {
                print("granted \(granted)")
                print("error \(error)")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = "Hurricane Dorian Clothing Drive"
                event.startDate = Date()
                event.endDate = Date()
                event.notes = ""
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError{
                    print("error : \(error)")
                }
                print("Save Event")
            } else{
                print("error : \(error)")
            }
            
        }
    }
    
   

}
