//
//  CocktailCollectionViewCell.swift
//  Perfect Drink
//
//  Created by Aravind P on 12/03/22.
//

import UIKit
import CoreData

class CocktailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImage: UIImageView!
    
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var cocktailLabel: UILabel!
    
    var cellData: Drinks!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}


extension CocktailCollectionViewCell {
    
    func configureCell() {
        self.cocktailLabel.text = cellData.strDrink
        
        let url = URL(string: cellData.strDrinkThumb)
        let data = try? Data(contentsOf: url!)
        thumbnailImage.image = UIImage(data: data!)
        
        self.setFavButton()
    }
    
    
    private func setFavButton() {
        self.favButton.isSelected = self.isFavourite()
        self.favButton.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        self.favButton.setImage(UIImage(named: "heartDeselected"), for: .normal)
        self.favButton.setImage(UIImage(named: "heartSelected"), for: .selected)
    }
    
    
    
    
    private func isFavourite() -> Bool {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let context = delegate?.persistentContainer.viewContext

        let request: NSFetchRequest<DrinksEntity> = DrinksEntity.fetchRequest()

        do {
            request.predicate = NSPredicate(format: "idDrink == \(cellData.idDrink)")
            let entities =  try context?.fetch(request)
            
            if (entities?.first) != nil {
                return true
            }
            
            return false
            
        } catch let error {
            print(error)
            return false
        }
        
    }
    
    
    @IBAction func didSelectFavButton(_ sender: Any) {
        if favButton.isSelected {
            favButton.isSelected = false
            removeFromDB()
        } else {
            favButton.isSelected = true
            addToDB()
        }
    }
    
    private func addToDB() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let context = delegate?.persistentContainer.viewContext
        
        let request: NSFetchRequest<DrinksEntity> = DrinksEntity.fetchRequest()
        
        do {
            request.predicate = NSPredicate(format: "idDrink == \(cellData.idDrink)")
            let entities =  try context?.fetch(request)
            
            if let entity = entities?.first {
                entity.idDrink = cellData.idDrink
                entity.strDrink = cellData.strDrink
                entity.strInstructions = cellData.strInstructions
                entity.strDrinkThumb = cellData.strDrinkThumb
            } else {
                let newEntity = DrinksEntity(context: context!)
                newEntity.idDrink = cellData.idDrink
                newEntity.strDrink = cellData.strDrink
                newEntity.strInstructions = cellData.strInstructions
                newEntity.strDrinkThumb = cellData.strDrinkThumb
            }
            
            try context?.save()
            
        } catch let error {
            print(error)
        }
        
    }
    
    
    
    private func removeFromDB() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let context = delegate?.persistentContainer.viewContext

        let request: NSFetchRequest<DrinksEntity> = DrinksEntity.fetchRequest()

        do {
            request.predicate = NSPredicate(format: "idDrink == \(cellData.idDrink)")
            let entities =  try context?.fetch(request)
            
            if let entity = entities?.first {
                context?.delete(entity)
            }
            
            try context?.save()
            
        } catch let error {
            print(error)
        }
        
    }
    
    
    
}
