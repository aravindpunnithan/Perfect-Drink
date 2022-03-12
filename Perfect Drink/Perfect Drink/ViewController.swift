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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteCollectionView.register(UINib(nibName: "CocktailCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "cocktailCollectionViewCell")
        favouriteCollectionView.dataSource = self
        favouriteCollectionView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadData()
    }

    @IBAction func ditTapSearchButton(_ sender: Any) {
        self.performSegue(withIdentifier: "searchPageSegue", sender: nil)
    }
    
    
}


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
    }
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "favDetailsSegue",
          let vc = segue.destination as? DetailsViewController {
            vc.cocktail = self.selectedDrink!
        }
        
    }
    
}




extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        return CGFloat(15)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedDrink = dataStore[indexPath.row]
        self.performSegue(withIdentifier: "favDetailsSegue", sender: nil)
    }
    
}

