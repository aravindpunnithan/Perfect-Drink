//
//  SearchViewController.swift
//  Perfect Drink
//
//  Created by Aravind P on 12/03/22.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {
    
    @IBOutlet weak var cocktailsCollectionView: UICollectionView!
    
    @IBOutlet var searchBar: UISearchBar!
    
    private var dataStore: [Drinks] = []
    
    private var selectedDrink: Drinks?
    
    private var loadingLabel: UILabel = UILabel()
    
    private var noItemLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        cocktailsCollectionView.register(UINib(nibName: "CocktailCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "cocktailCollectionViewCell")
        cocktailsCollectionView.dataSource = self
        cocktailsCollectionView.delegate = self
        loadingLabel = UIUtility().getLabel(with: "Loading...", font: UIFont.systemFont(ofSize: 15))
        noItemLabel = UIUtility().getLabel(with: "No drinks found.", font: UIFont.systemFont(ofSize: 15))
        loadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchDetailsSegue",
          let vc = segue.destination as? DetailsViewController {
            vc.cocktail = self.selectedDrink!
        }
    }
    
}


//MARK: - Private Methods
extension SearchViewController {
    
    
    private func loadData(searchString: String = "") {
        let formattedSearchString = searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        var apiToContact = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s"
        
        if searchString != "" {
            apiToContact = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s" + "=" + formattedSearchString!
        }
        
        setLoadingLabel()
        
        let request = AF.request(apiToContact)
        
        request.responseJSON() { response in
            
            self.loadingLabel.removeFromSuperview()
            
            guard let data = response.data else {
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(DrinksBase.self, from: data)
                
                if decodedData.drinks?.count ?? 0 > 0 {
                    self.dataStore = decodedData.drinks!
                } else {
                    self.dataStore = []
                }
                
                self.reloadView()
                
            } catch {
                print("Decode Failed")
            }
        }
    }
    
    
    private func reloadView() {
        self.cocktailsCollectionView.reloadData()
        
        if dataStore.count == 0 {
            setNoDrinksFoundLabel()
        } else {
            self.noItemLabel.removeFromSuperview()
        }
    }
    
    
    private func setLoadingLabel() {
        self.view.addSubview(loadingLabel)
        loadingLabel.backgroundColor = .clear
        loadingLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        loadingLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        loadingLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loadingLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func setNoDrinksFoundLabel() {
        self.view.addSubview(noItemLabel)
        noItemLabel.backgroundColor = .clear
        noItemLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        noItemLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        noItemLabel.widthAnchor.constraint(equalToConstant: 125).isActive = true
        noItemLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    
//    private func loadDrinkDetils(id: String) {
//        let apiToContact = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i" + "=" + id
//
//        let request = AF.request(apiToContact)
//
//        request.responseJSON() { response in
//            guard let data = response.data else {
//                return
//            }
//            do {
//                let decodedData = try JSONDecoder().decode(DrinksBase.self, from: data)
//
//                if let drink = decodedData.drinks?.first {
//                    self.selectedDrink = drink
//                    self.performSegue(withIdentifier: "searchDetailsSegue", sender: nil)
//                }
//            } catch {
//                print("Decode Failed")
//            }
//        }
//    }
    
    
}


//MARK: - UISearchBarDelegate Implimentation
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(String(describing: searchBar.text))")
        self.view.endEditing(true)
        self.loadData(searchString: (searchBar.text ?? "").trimmingCharacters(in: .whitespaces))
    }
    
}
    

//MARK: - UICollectionView Protocol Implimentations
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataStore.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cocktailCollectionViewCell", for: indexPath as IndexPath) as! CocktailCollectionViewCell
        cell.cellData = dataStore[indexPath.row]
        cell.configureCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.loadDrinkDetils(id: dataStore[indexPath.row].idDrink)
        self.selectedDrink = dataStore[indexPath.row]
        self.performSegue(withIdentifier: "searchDetailsSegue", sender: nil)
    }
    
}
