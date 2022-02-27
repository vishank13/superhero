//
//  ViewController.swift
//  superhero
//
//  Created by Bhanu Kaushik on 27/02/22.
//

import UIKit

class SuperHeroViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mainBgView: UIView!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var heroTableView: UITableView!
    
    var heroDatabase: [Superhero]?
    var filterData: [Superhero]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getData()
        registerNib()
    }
    
    func setup() {
        navigationTitleLabel.text = "Hero / Villian"
        searchTextField.delegate = self
        searchTableView.isHidden = true
    }
    
    func registerNib() {
        searchTableView.register(UINib(nibName: AppConstants.searchIdentifier, bundle: nil), forCellReuseIdentifier: AppConstants.searchIdentifier)
        heroTableView.register(UINib(nibName: AppConstants.heroIdentifier, bundle: nil), forCellReuseIdentifier: AppConstants.heroIdentifier)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchTableView.isHidden = true
        heroTableView.reloadData()
        return true
    }
    
    @IBAction func searchName(_ sender: UITextField) {
        searchTableView.isHidden = false
        let filteredData = heroDatabase?.filter{ $0.name!.lowercased().replacingOccurrences(of: " ", with: "").contains(sender.text?.lowercased() ?? "") }
        print(filteredData?.count)
        filterData = filteredData
        searchTableView.reloadData()
    }
    
    
    
}

extension SuperHeroViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case searchTableView:
            guard let rows = filterData?.count else {
                return 0
            }
            return rows > 10 ? 10 : rows
        case heroTableView:
            return searchTextField.text!.isEmpty ? heroDatabase?.count ?? 0 : filterData?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.searchIdentifier) as? SearchTableViewCell else {
                return UITableViewCell()
            }
            guard let name = filterData?[indexPath.row].name else {
                return UITableViewCell()
            }
            cell.nameLabel.text = name
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.heroIdentifier) as? HeroTableViewCell else {
                return UITableViewCell()
            }
            
            if searchTextField.text!.isEmpty {
                guard let name = heroDatabase?[indexPath.row].name, let img = heroDatabase?[indexPath.row].images.xs, let url = URL(string: img) else {
                    return UITableViewCell()
                }
                cell.activityIndicator.startAnimating()
                cell.nameLabel.text = name
                cell.heroImageView.loadImage(from: url, indicator: cell.activityIndicator)
            } else {
                guard let name = filterData?[indexPath.row].name, let img = filterData?[indexPath.row].images.xs, let url = URL(string: img) else {
                    return UITableViewCell()
                }
                cell.activityIndicator.startAnimating()
                cell.nameLabel.text = name
                cell.heroImageView.loadImage(from: url, indicator: cell.activityIndicator)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(filterData?[indexPath.row].name)
    }
}
