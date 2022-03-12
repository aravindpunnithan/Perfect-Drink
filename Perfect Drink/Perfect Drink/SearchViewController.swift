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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        cocktailsCollectionView.register(UINib(nibName: "CocktailCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "cocktailCollectionViewCell")
        cocktailsCollectionView.dataSource = self
        cocktailsCollectionView.delegate = self
        loadData()
    }
    
    
}


extension SearchViewController {
    
    private func loadData(searchString: String = "") {
        
        var apiToContact = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s"
        
        if searchString != "" {
            apiToContact = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s" + "=" + searchString
        }
        
        let request = AF.request(apiToContact)
        
        request.responseJSON() { response in
            guard let data = response.data else {
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(DrinksBase.self, from: data)
                
                if decodedData.drinks?.count ?? 0 > 0 {
                    self.dataStore = decodedData.drinks!
                    self.reloadView()
                }
            } catch {
                print("Decode Failed")
            }
        }
    }
    
    private func reloadView() {
        self.cocktailsCollectionView.reloadData()
    }
    
}



extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(String(describing: searchBar.text))")
        self.view.endEditing(true)
        self.loadData(searchString: (searchBar.text ?? "").trimmingCharacters(in: .whitespaces))
    }
    
}
    


extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataStore.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cocktailCollectionViewCell", for: indexPath as IndexPath) as! CocktailCollectionViewCell
        cell.thumbnailImage.image = UIImage(named: "thumbnail")
        cell.cellData = dataStore[indexPath.row]
        cell.configureCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(3)
    }
    
}