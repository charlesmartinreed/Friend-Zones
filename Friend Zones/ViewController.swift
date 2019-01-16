//
//  ViewController.swift
//  Friend Zones
//
//  Created by Charles Martin Reed on 1/16/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    //MARK:- Properties
    var friends = [Friend]()
    let cellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        title = "Friend Zone" //title for the nav
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend)) //#selector - a swift compiler method that says "find this method and verify that it exists
        
    }

    
    //MARK:- table view delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let friend = friends[indexPath.row]
        cell.textLabel?.text = friend.name
        cell.detailTextLabel?.text = friend.timeZone.identifier
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //by calling the configure method here, we allow editing of the friend by tapping on the row
        configure(friend: friends[indexPath.row], position: indexPath.row)
    }
    
    //MARK:- Friend configuration methods
    @objc func addFriend() {
        let friend = Friend()
        friends.append(friend)
        
        //insert into table view - at the end of the list
        tableView.insertRows(at: [IndexPath(row: friends.count - 1, section: 0)], with: .automatic)
        saveData()
        
        //immediately begin editing friend
        configure(friend: friend, position: friends.count - 1)
    }
    
    func configure(friend: Friend, position: Int) {
        //create instance of FriendVC, assign self as delegate, assign selected friend as FriendVC's friend property and push the Friend VC onto the stack
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "FriendViewController") as? FriendViewController else {
            fatalError("Unable to create FriendViewController.")
        }
        
        vc.delegate = self
        vc.friend = friend
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:- Data handling methods
    func loadData() {
        //pulling stored friend info from UserDefaults
        let defaults = UserDefaults.standard
        
        guard let savedData = defaults.data(forKey: "Friends") else { return }
        
        //decode found json data
        let decoder = JSONDecoder()
        guard let savedFriends = try? decoder.decode([Friend].self, from: savedData) else { return }
        
        friends = savedFriends
    }
    
    func saveData() {
        let defaults = UserDefaults.standard
        
        //encode and write to NSUSerDefaults
        let encoder = JSONEncoder()
        guard let savedData = try? encoder.encode(friends) else {
            fatalError("Unable to encode friends data")
        }
        
        defaults.set(savedData, forKey: "Friends")
    }

}

