//
//  AboutContactUsViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 12/07/2021.
//

import UIKit

struct cellData {
    var opened = Bool()
    var name = String()
    var picture = UIImage(systemName: "person.fill.questionmark")
    var blurb = String()
}

class AboutUsViewController: UIViewController {

    @IBOutlet weak var bookStopButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewData = [cellData]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.aboutUs.cellNibName, bundle: nil), forCellReuseIdentifier: K.aboutUs.cellID)
        
        tableViewData = [
            cellData(opened: false, name: "Eoin Ó'hAnnagáin B.Rel.Ed.M, A.R.I.A.M.", picture: #imageLiteral(resourceName: "Eoin1"), blurb: "Throughout the practicum Eoin was responsible for the iOS development learning swift and Xcode from scratch to do so. As part of this he also took lead of the project UI styles as well initiating the cross platform chat function. Additionally, as the teams maintenance lead, Eoin was responsible for maintaining the teams GitHub repository, establishing the teams best practices, and resolving conflicts.\n\nPrior to undertaking the Computer Science conversion masters at UCD, Eoin was a Music and Religious Education teacher, having studied at Mater Dei/DCU. He is also an associate of the Royal Irish Academy of Music and has been teaching piano since 2008 and has performed organ at the National Concert Hall."),
            cellData(opened: false, name: "Eugene", blurb: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam eleifend velit scelerisque, efficitur augue quis, lobortis mauris. Donec magna velit, egestas vel viverra rhoncus, feugiat quis arcu. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aenean eget urna lorem. Phasellus luctus fringilla leo, ut maximus nulla gravida ut. Duis nec malesuada risus, eu tempus metus. Ut in dictum tellus. Aliquam eros urna, rhoncus nec laoreet eu, imperdiet sed mi. Nunc vestibulum justo sed scelerisque consequat. Fusce rutrum facilisis justo sit amet mollis. Donec sagittis velit nulla, eget interdum purus feugiat vitae.\n\nFusce pellentesque mauris eu fringilla ultrices. Praesent maximus libero lorem, non semper neque commodo vitae. Proin turpis ipsum, consequat eget metus consequat, vulputate semper nisl. Donec et tortor convallis, pellentesque ipsum a, porttitor augue. Mauris imperdiet vel magna sit amet cursus. Mauris quis malesuada justo, at convallis augue. Proin at massa enim. Aenean accumsan magna quis mauris euismod volutpat."),
            cellData(opened: false, name: "Even", blurb: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam eleifend velit scelerisque, efficitur augue quis, lobortis mauris. Donec magna velit, egestas vel viverra rhoncus, feugiat quis arcu. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aenean eget urna lorem. Phasellus luctus fringilla leo, ut maximus nulla gravida ut. Duis nec malesuada risus, eu tempus metus. Ut in dictum tellus. Aliquam eros urna, rhoncus nec laoreet eu, imperdiet sed mi. Nunc vestibulum justo sed scelerisque consequat. Fusce rutrum facilisis justo sit amet mollis. Donec sagittis velit nulla, eget interdum purus feugiat vitae.\n\nFusce pellentesque mauris eu fringilla ultrices. Praesent maximus libero lorem, non semper neque commodo vitae. Proin turpis ipsum, consequat eget metus consequat, vulputate semper nisl. Donec et tortor convallis, pellentesque ipsum a, porttitor augue. Mauris imperdiet vel magna sit amet cursus. Mauris quis malesuada justo, at convallis augue. Proin at massa enim. Aenean accumsan magna quis mauris euismod volutpat."),
            cellData(opened: false, name: "Hank", blurb: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam eleifend velit scelerisque, efficitur augue quis, lobortis mauris. Donec magna velit, egestas vel viverra rhoncus, feugiat quis arcu. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aenean eget urna lorem. Phasellus luctus fringilla leo, ut maximus nulla gravida ut. Duis nec malesuada risus, eu tempus metus. Ut in dictum tellus. Aliquam eros urna, rhoncus nec laoreet eu, imperdiet sed mi. Nunc vestibulum justo sed scelerisque consequat. Fusce rutrum facilisis justo sit amet mollis. Donec sagittis velit nulla, eget interdum purus feugiat vitae.\n\nFusce pellentesque mauris eu fringilla ultrices. Praesent maximus libero lorem, non semper neque commodo vitae. Proin turpis ipsum, consequat eget metus consequat, vulputate semper nisl. Donec et tortor convallis, pellentesque ipsum a, porttitor augue. Mauris imperdiet vel magna sit amet cursus. Mauris quis malesuada justo, at convallis augue. Proin at massa enim. Aenean accumsan magna quis mauris euismod volutpat.")
        ]
        
        

        // Do any additional setup after loading the view.
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

extension AboutUsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.aboutUs.cellID, for: indexPath) as! AboutUsCellTableViewCell
            cell.nameLabel.text = tableViewData[indexPath.section].name
            cell.profileImage.image = tableViewData[indexPath.section].picture
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.aboutUs.textCellId)
            cell?.textLabel?.text = tableViewData[indexPath.section].blurb
            return cell!
        }
    }
    
}

extension AboutUsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableViewData[indexPath.section].opened {
            tableViewData[indexPath.section].opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        } else {
            tableViewData[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }
    }
    
}


//MARK: - Audio Book Control

extension AboutUsViewController {
    
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
