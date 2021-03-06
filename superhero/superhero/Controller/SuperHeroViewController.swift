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
    @IBOutlet weak var blackBgView: UIView!
    
    var heroDatabase: [Superhero]?
    var filterData: [Superhero]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getData()
        registerNib()
    }
    
    func setup() {
        navigationTitleLabel.text = "Search"
        searchTextField.delegate = self
        searchTableView.isHidden = true
        blackBgView.isHidden = true
        searchTableView.layer.cornerRadius = 20
        searchTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
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
        blackBgView.isHidden = true
        heroTableView.reloadData()
        return true
    }
    
    func filterData(name: String) {
        print(name)
        let filteredData = heroDatabase?.filter{ $0.name!.lowercased().contains(name.lowercased() ) }
        searchTableView.isHidden = filteredData?.count ?? 0 > 0 ? false : true
        UIView.animate(withDuration: 5, delay: 5, options: .transitionCrossDissolve) {
            self.blackBgView.isHidden = filteredData?.count ?? 0 > 0 ? false : true
        }

        blackBgView.isHidden = filteredData?.count ?? 0 > 0 ? false : true
        print(filteredData?.count)
        filterData = filteredData
        searchTableView.reloadData()
    }
    
    @IBAction func searchName(_ sender: UITextField) {
        filterData(name: sender.text ?? "")
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
            
            let details = searchTextField.text!.isEmpty ? heroDatabase : filterData
            
            guard let name = details?[indexPath.row].name, let img = details?[indexPath.row].images.xs, let url = URL(string: img) else {
                return UITableViewCell()
            }
            cell.activityIndicator.startAnimating()
            cell.nameLabel.text = name
            cell.heroImageView.loadImage(from: url, indicator: cell.activityIndicator)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(filterData?[indexPath.row].name)
        if tableView == searchTableView {
            guard let name = filterData?[indexPath.row].name else { return }
            searchTextField.text = name
            filterData(name: name)
            searchTableView.isHidden = true
            blackBgView.isHidden = true
            
//            searchName(searchTextField)
//            searchTextField.resignFirstResponder()
//            searchTableView.isHidden = true
//            blackBgView.isHidden = true
            heroTableView.reloadData()
            searchTextField.resignFirstResponder()
        }
    }
}
