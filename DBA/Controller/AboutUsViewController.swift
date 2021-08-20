//
//  AboutContactUsViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 12/07/2021.
//

import UIKit

struct cellData {
    // Structure for cellData object
    
    var opened = Bool()
    var name = String()
    var picture = UIImage(systemName: "person.fill.questionmark")
    var blurb = String()
}

class AboutUsViewController: UIViewController {

    // IBOutlet for navigation bar audio book button
    @IBOutlet weak var bookStopButton: UIBarButtonItem!
    
    // IBOutlet for table view
    @IBOutlet weak var tableView: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set table view delegates
        tableView.dataSource = self
        tableView.delegate = self
        
        // Set xib for table view
        tableView.register(UINib(nibName: K.aboutUs.cellNibName, bundle: nil), forCellReuseIdentifier: K.aboutUs.cellID)
        
    }
}


//MARK: - Table View Data Source

extension AboutUsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Number of sections
        
        return K.aboutUs.tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Rows per sections
        
        if K.aboutUs.tableViewData[section].opened == true {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Method to populate rows and segments
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.aboutUs.cellID, for: indexPath) as! AboutUsCellTableViewCell
            cell.nameLabel.text = K.aboutUs.tableViewData[indexPath.section].name
            cell.profileImage.image = K.aboutUs.tableViewData[indexPath.section].picture
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.aboutUs.textCellId)
            cell?.textLabel?.text = K.aboutUs.tableViewData[indexPath.section].blurb
            return cell!
        }
    }
    
}


//MARK: - Table View Delegate

extension AboutUsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Method for displaying or hiding blurb when row is selected
        
        if K.aboutUs.tableViewData[indexPath.section].opened {
            K.aboutUs.tableViewData[indexPath.section].opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        } else {
            K.aboutUs.tableViewData[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }
    }
}


//MARK: - Audio Book Control

extension AboutUsViewController {
    // Audio book navigation bar controls
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if SpeechService.shared.renderStopButton() {
            bookStopButton.image = UIImage(systemName: "play.slash")
        } else {
            bookStopButton.image = nil
        }
        
    }
    
    @IBAction func bookStopButtonPressed(_ sender: UIBarButtonItem) {
        SpeechService.shared.stopSpeeching()
        bookStopButton.image = nil
    }
}
