//
//  TableViewController.swift
//  Memorable Places
//
//  Created by kelvinfok on 18/7/16.
//  Copyright © 2016 kelvinfok. All rights reserved.
//

import UIKit

var places = [Dictionary<String,String>()]
var activePlace = -1

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if places.count == 1 {
            
            places.removeAtIndex(0)
            places.append(["name": "Center of the earth", "lat": "0", "long": "0"])
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return places.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = places[indexPath.row]["name"]
        
        return cell
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        activePlace = indexPath.row
        return indexPath
    }
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addPlace" {
            activePlace = -1
        }
    }
}
