//
//  RSVPViewController.swift
//  updine-user
//
//  Created by Yasin Ehsan on 1/26/20.
//  Copyright © 2020 Yasin Ehsan. All rights reserved.
//

import UIKit
import EventKit

class RSVPViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func rsvpButtonTapped(_ sender: Any) {
        let eventStore:EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) {(granted, error) in
            if (granted) && (error) == nil
            {
                print("granted \(granted)")
                print("error \(error)")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = "RSVP Night Out"
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
