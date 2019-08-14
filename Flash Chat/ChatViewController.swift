//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here
    var messageArray: [Message] = [Message]()
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self    // all actions towards tableview will be notified (delegated) to ChatViewController
        messageTableView.dataSource = self  // all datasource to tableview should come from ChatViewController
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self // to subscribe/delegate ChatViewController to the event that occurs on UITextField. which is why we implements UITextFieldDelegate
        
        
        //TODO: Set the tapGesture here:    // add tap gesture to the UITableView, so when messageTableView(UITableView) is clicked, it will trigger the tableViewTapped()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)

        //TODO: Register your MessageCell.xib file here: Register the CustomMessageCell in order to be able to use
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        
        retrieveMessages()  // put retrieveMessages function here will also load the message on this viewDidLoad init and also when every new value is added on .childAdded
        messageTableView.separatorStyle = .none    // remove the line separator in the UITableView
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(indexPath)
        print(indexPath.section)    // section is like column
        print(indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell   // modify each cell (UITableViewCell) to be loaded in the UITableView to use our CustomMessageCell (identifier "customMessageCell", MessageCell.xib as registered in the viewDidLoad() above)
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        // set different background color using ChameleonFramework based on sender
        if cell.senderUsername.text == Auth.auth().currentUser?.email {
            cell.avatarImageView.backgroundColor = UIColor.flatYellow()
            cell.messageBackground.backgroundColor = UIColor.flatYellow()
        } else {
            cell.avatarImageView.backgroundColor = UIColor.flatPurple()
            cell.messageBackground.backgroundColor = UIColor.flatPurple()
        }
        
        
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count   // return number of cells to be displayed (the content of the cell should not be empty or else error). Therefore, should be same as number of content to be put in the cell
    }
    
    
    //TODO: Declare tableViewTapped here:
    @objc  // added @objc because #selector is objective-C command, in order for this to work, need to add this
    func tableViewTapped() {
        messageTextfield.endEditing(true)   // this will trigger textFieldDidEndEditing event
    }
    
    
    //TODO: Declare configureTableView here:
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension     // auto adjust row height
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
    
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308.0   // adjust the constant of the heightConstraint to 308 when cursor in textfield to cater space for keyboard
            self.view.layoutIfNeeded()   // reload the view (ChatViewController)
        }
    }
    
    
    
    //TODO: Declare textFieldDidEndEditing here:    this function needs to be manually triggered!!
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50.0   // adjust the constant of the heightConstraint to back to initial position when cursor is out of textfield
            self.view.layoutIfNeeded()   // reload the view (ChatViewController)
        }
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        //TODO: Send the message to Firebase and save it in our database
        let messagesDB = Database.database().reference().child("Messages")
        
        let messageDict = ["sender": Auth.auth().currentUser?.email, "messageBody": messageTextfield.text!]
        
        messagesDB.childByAutoId().setValue(messageDict) {
            (error, ref) in
            
            if error != nil {
                print(error!)
            } else {
                print("message saved successfully!")
                
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
            
        }
        
        
    }
    
    //TODO: Create the retrieveMessages method here:
    func retrieveMessages() {
        let messagesDB = Database.database().reference().child("Messages")
        
        messagesDB.observe(.childAdded) {
            (snapshot) in
            print("SNAPSHOT..... ")
            print(snapshot)
            
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let message = Message()
            
            message.sender = snapshotValue["sender"]!
            message.messageBody = snapshotValue["messageBody"]!
            
            self.messageArray.append(message)
            self.messageTableView.reloadData()  // reload the UITableView so that new message will be reflected
            
            SVProgressHUD.dismiss()
        }
    }
    

    
    
    
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
