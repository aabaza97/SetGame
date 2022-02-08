//
//  GameModeSelectorTableViewController.swift
//  setGame_task2
//
//  Created by Ahmed Abaza on 31/01/2022.
//

import UIKit

typealias MenuItem = (title: String, subtitle: String)

class GameModeSelectorTableViewController: UITableViewController {
    private let menuItems: [MenuItem] = [
        (title: "Textual Set", subtitle: "Cards represented using text"),
        (title: "Graphical Set", subtitle: "Cards represented using graphics"),
        (title: "Animated Set",subtitle: "Cards represented interactively")
    ]
    
    
    
    // MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "textGame") as? SetGameViewController else { return }
            vc.displayMode = .textual
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "graphicsGame") as? SetGameViewController else { return }
            vc.displayMode = .graphical
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2: break
        default: return
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Display Modes"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        32.0
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        
        //Cell configuration
        var contentConfiugration = cell.defaultContentConfiguration()
        contentConfiugration.textProperties.color = .white
        contentConfiugration.secondaryTextProperties.color = .white
        contentConfiugration.text = self.menuItems[indexPath.row].title
        contentConfiugration.secondaryText = self.menuItems[indexPath.row].subtitle
        
        
        let accView = UIImageView(image: .init(systemName: "chevron.right"))
        cell.contentConfiguration = contentConfiugration
        cell.accessoryView = accView
        cell.tintColor = .white
        
        return cell
    }
}
