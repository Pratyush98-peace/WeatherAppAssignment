//
//  SearchCityController.swift
//  SimpleWeather
//
//  Created by Pratyush Jha on 08/03/23.
//  Copyright © 2023 Joey deVilla. All rights reserved.
//

import UIKit

var array: [String] = []

class SearchCityController: UIViewController {
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SearchCityController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.TableView.cellForRow(at: indexPath) as! UITableViewCell
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "Main") as? WeatherMainViewController
        if let controller = controller {
            controller.city = cell.textLabel?.text
            self.present(controller,animated: true, completion: nil)
            self.modalPresentationStyle = .fullScreen
        } 
    }
}

extension SearchCityController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let appendedCity = searchBar.text {
            push(appendedCity)
            TableView.reloadData()
        }
    }
}

extension SearchCityController {
    
    func push(_ item: String) {
        if array.count == 5 {
            pop()
        }
      array.append(item)
    }
    
    func pop() -> String? {
       array.removeFirst()
    }
}
