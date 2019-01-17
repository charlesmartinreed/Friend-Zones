//
//  FriendViewController.swift
//  Friend Zones
//
//  Created by Charles Martin Reed on 1/16/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class FriendViewController: UITableViewController, Storyboarded {

    //MARK:- Properties
     //need bi-directional reference to previous screen, in form of a Friend object and a delegate
    var friend: Friend!
    weak var coordinator: MainCoordinator?
    weak var delegate: ViewController?
    
    let nameCellIdentifer = "NameCell"
    let timeZoneCellIdentifer = "TimeZoneCell"
   
    var nameEditingCell: TextTableViewCell? {
        //allows us to read and activate the name editing cell from anywhere in our code
        let indexPath = IndexPath(row: 0, section: 0)
        return tableView.cellForRow(at: indexPath) as? TextTableViewCell
    }
    
    //array of time zones, index of selected time zone
    var timeZones = [TimeZone]()
    var selectedTimeZone = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //grab all the timezones, add them to the array
        let identifers = TimeZone.knownTimeZoneIdentifiers
        for identifer in identifers {
            //create a timeZone instance from each identifer that we can work with
            //timezones have interesting facts like, how far from GMT a location is
            if let timeZone = TimeZone(identifier: identifer) {
                timeZones.append(timeZone)
            }
        }
        let now = Date()
        
        //sort our timeZones - 1. first by west to east, offset by GMT and 2. by name
        timeZones.sort {
            //get diff between first timezone and GMT
            let ourDifference = $0.secondsFromGMT(for: now)
            let otherDifference = $1.secondsFromGMT(for: now)
            
            if ourDifference == otherDifference {
                //if same, sort by name
                return $0.identifier < $1.identifier
            } else {
                //if different
                return ourDifference < otherDifference
            }
        }
        
        selectedTimeZone = timeZones.index(of: friend.timeZone) ?? 0
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //call the method in VC to update friend as this FriendVC
        super.viewWillDisappear(animated)
        delegate?.update(friend: friend)
    }
    
    //MARK:- IBActions
    @IBAction func nameChanged(_ sender: UITextField) {
        //calls the vc every time the key stroke is detected
        friend.name = sender.text ?? ""
        
    }
    
    //MARK:- table view delegate methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2 //name your friend and timezones
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return timeZones.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //we're using a grouped style here
        if section == 0 {
            return "Name your friend"
        } else {
            return "Select their timezone"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //load one of the two classes and show it on the screen
        if indexPath.section == 0 {
            //name your friend
            guard let cell = tableView.dequeueReusableCell(withIdentifier: nameCellIdentifer, for: indexPath) as? TextTableViewCell else {
                fatalError("Couldn't create a TextTableViewCell")}
            cell.textField.text = friend.name
            return cell
        } else {
            //time zone
            let cell = tableView.dequeueReusableCell(withIdentifier: timeZoneCellIdentifer, for: indexPath)
            let timeZone = timeZones[indexPath.row]
            
            cell.textLabel?.text = timeZone.identifier.replacingOccurrences(of: "_", with: " ")
            let timeDifference = timeZone.secondsFromGMT(for: Date())
            cell.detailTextLabel?.text = timeDifference.timeString()
            
            //display to the user which time zone is currently selected
            if indexPath.row == selectedTimeZone {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            startEditingName() //by allowing anywhere in the cell to be tapped to activate the text editing, we've removed dead spots.
        } else {
            selectRow(at: indexPath) //will allow us the dismiss the first responder (keyboard, in this case) when selecting a row.
        }
    }
    
    
    func startEditingName() {
        nameEditingCell?.textField.becomeFirstResponder()
        
        //when editing is complete, we'll need to update the friend.name to reflect the changes - handled in nameChanged
    }
    
    func selectRow(at indexPath: IndexPath) {
        //when a row is tapped and selected, the keyboard should be resigned
        nameEditingCell?.textField.resignFirstResponder()
        
        //add checkmark to cell, remove checkmark from previous cells
        for cell in tableView.visibleCells {
            cell.accessoryType = .none
        }
        
        selectedTimeZone = indexPath.row
        friend.timeZone = timeZones[indexPath.row]
        
        let selected = tableView.cellForRow(at: indexPath)
        selected?.accessoryType = .checkmark
        
        //animated transition to indicate that the row was selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
