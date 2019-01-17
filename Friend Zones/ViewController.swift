//
//  ViewController.swift
//  Friend Zones
//
//  Created by Charles Martin Reed on 1/16/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, Storyboarded {

    //MARK:- Properties
    weak var coordinator: MainCoordinator?
    var friends = [Friend]()
    var selectedFriend: Int? = nil
    
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
        
        //formatting our identifer to show the current time in our friend's location instead of a generic identifer like America/Los Angeles
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = friend.timeZone
        dateFormatter.timeStyle = .short
        
        cell.detailTextLabel?.text = dateFormatter.string(from: Date())
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //by calling the configure method here, we allow editing of the friend by tapping on the row
        selectedFriend = indexPath.row
        coordinator?.configure(friend: friends[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            friends.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
    }
    
    //MARK:- Friend configuration methods
    @objc func addFriend() {
        let friend = Friend()
        friends.append(friend)
        
        //insert into table view - at the end of the list
        tableView.insertRows(at: [IndexPath(row: friends.count - 1, section: 0)], with: .automatic)
        saveData()
        
        //immediately begin editing friend
        selectedFriend = friends.count - 1
        coordinator?.configure(friend: friend)
    }
    
    func update(friend: Friend) {
        //this method will be called by the FriendViewController, used to reflect editing changes
        guard let selectedFriend = selectedFriend else { return }
        
        friends[selectedFriend] = friend //take item in array that we're editing and replace it with the new friend
        saveData()
        tableView.reloadData()
        
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

