//
//  ViewController.swift
//  Perfect Drink
//
//  Created by Aravind P on 12/03/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var favouriteCollectionView: UICollectionView!
    
    private var dataStore: [Drinks] = []
    
    private var selectedDrink: Drinks?
    
    private var noItemLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteCollectionView.register(UINib(nibName: "CocktailCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "cocktailCollectionViewCell")
        favouriteCollectionView.dataSource = self
        favouriteCollectionView.delegate = self
        noItemLabel = UIUtility().getLabel(with: "You haven't added any favourite drinks.", font: UIFont.systemFont(ofSize: 15))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favDetailsSegue",
          let vc = segue.destination as? DetailsViewController {
            vc.cocktail = self.selectedDrink!
        }
    }

    @IBAction func ditTapSearchButton(_ sender: Any) {
        self.performSegue(withIdentifier: "searchPageSegue", sender: nil)
    }
    
}


//MARK: - Private Methods
extension ViewController {
    
    private func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let context = delegate?.persistentContainer.viewContext

        let request: NSFetchRequest<DrinksEntity> = DrinksEntity.fetchRequest()

        do {
            let entities =  try context?.fetch(request)
            
            if entities?.count ?? 0 > 0 {
                self.dataStore = entities!.map { Drinks(idDrink: $0.idDrink ?? "",
                                                        strDrink: $0.strDrink ?? "",
                                                        strDrinkThumb: $0.strDrinkThumb ?? "",
                                                        strInstructions: $0.strInstructions ?? "") }
            } else {
                self.dataStore = []
            }
            
            self.reloadView()
            
        } catch let error {
            print(error)
        }
    }
    
    private func reloadView() {
        self.favouriteCollectionView.reloadData()
        
        if dataStore.count == 0 {
            setNoFavLabel()
        } else {
            self.noItemLabel.removeFromSuperview()
        }
    }
    
    private func setNoFavLabel() {
        self.view.addSubview(noItemLabel)
        noItemLabel.backgroundColor = .clear
        noItemLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        noItemLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        noItemLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
        noItemLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
}



//MARK: - UICollectionView Protocol Implimentations
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataStore.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cocktailCollectionViewCell", for: indexPath as IndexPath) as! CocktailCollectionViewCell
        cell.cellData = dataStore[indexPath.row]
        cell.delegate = self
        cell.configureCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedDrink = dataStore[indexPath.row]
        self.performSegue(withIdentifier: "favDetailsSegue", sender: nil)
    }
    
}



//MARK: - FavouriteCocktailDelegate Implimentations
extension ViewController: FavouriteCocktailDelegate {
    
    func favouriteCocktail(didDeselect drink: Drinks) {
        self.loadData()
    }
    
}

