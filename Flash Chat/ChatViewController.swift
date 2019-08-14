//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Declare instance variables here
    var messageArray = ["First Message", "Second Message bla bla bla bla bla", "Third Message bla bla"]
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self    // all actions towards tableview will be notified (delegated) to ChatViewController
        messageTableView.dataSource = self  // all datasource to tableview should come from ChatViewController
        
        //TODO: Set yourself as the delegate of the text field here:

        
        
        //TODO: Set the tapGesture here:
        
        

        //TODO: Register your MessageCell.xib file here: Register the CustomMessageCell in order to be able to use
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(indexPath)
        print(indexPath.section)    // section is like column
        print(indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell   // modify each cell (UITableViewCell) to be loaded in the UITableView to use our CustomMessageCell (identifier "customMessageCell", MessageCell.xib as registered in the viewDidLoad() above)
        
        cell.messageBody.text = messageArray[indexPath.row]
        
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count   // return number of cells to be displayed (the content of the cell should not be empty or else error). Therefore, should be same as number of content to be put in the cell
    }
    
    
    //TODO: Declare tableViewTapped here:
    
    
    
    //TODO: Declare configureTableView here:
    
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        
        //TODO: Send the message to Firebase and save it in our database
        
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
    

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let err as NSError {
            print("Error! there was problem signing out.")
            print(err)
        }

        
    }
    


}
