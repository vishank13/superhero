//
//  ViewController.swift
//  superhero
//
//  Created by Bhanu Kaushik on 27/02/22.
//

import UIKit

class SuperHeroViewController: UIViewController {
    
    @IBOutlet weak var mainBgView: UIView!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var heroTableView: UITableView!
    
    var heroDatabase: [Superhero]?
    var filterData: [Superhero]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    func getData() {
        if let url = Bundle.main.url(forResource: "HeroData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Superhero].self, from: data)
                print(jsonData.first?.name)
                heroDatabase = jsonData
            } catch {
                print("error:\(error)")
            }
        }
    }
    
    @IBAction func searchName(_ sender: UITextField) {
        let filteredData = heroDatabase?.filter{ $0.name!.lowercased().replacingOccurrences(of: " ", with: "").contains(sender.text?.lowercased() ?? "") }
        print(filteredData?.first?.name)
        filterData = filteredData
    }
    
    
    
}

extension SuperHeroViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case searchTableView:
            return 10
        case heroTableView:
            return filterData?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
