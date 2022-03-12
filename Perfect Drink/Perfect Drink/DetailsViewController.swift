//
//  DetailsViewController.swift
//  Perfect Drink
//
//  Created by Aravind P on 12/03/22.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var cocktailLabel: UILabel!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var instructionsTextView: UITextView!
    
    var cocktail: Drinks!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    
    private func setupView() {
        self.cocktailLabel.text = cocktail.strDrink
        
        let url = URL(string: cocktail.strDrinkThumb)
        let data = try? Data(contentsOf: url!)
        thumbnailImageView.image = UIImage(data: data!)
        
        instructionsTextView.text = cocktail.strInstructions
        
    }
    


}
