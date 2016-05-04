//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by William L. Marr III on 4/27/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import UIKit
import Alamofire

class PokemonDetailVC: UIViewController {
    
    var mainPokeImage: UIImage!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var pokedexIDLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var baseAttackLabel: UILabel!
    @IBOutlet weak var nextEvolutionLabel: UILabel!
    @IBOutlet weak var currentEvolutionImage: UIImageView!
    @IBOutlet weak var nextEvolutionImage: UIImageView!
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = pokemon.name.capitalizedString
        descriptionLabel.text = ""
        typeLabel.text = ""
        defenseLabel.text = ""
        heightLabel.text = ""
        pokedexIDLabel.text = ""
        weightLabel.text = ""
        baseAttackLabel.text = ""
        nextEvolutionLabel.text = ""
        
        mainPokeImage = UIImage(named: "\(pokemon.pokedexID)")
        mainImage.image = mainPokeImage
        currentEvolutionImage.image = mainPokeImage
        
        // Wait until the remote API responds before setting
        // the images for the evolutions (done in updateUI()).
        currentEvolutionImage.hidden = true
        nextEvolutionImage.hidden = true
        
        pokemon.downloadPokemonDetails { () -> Void in
            
            // This code gets called when asynchronous download request completes.
            print("COMPLETION HANDLER CALLED")
            
            // At this point, the download request to the pokeapi.co RESTful API
            // has finished, and the user interface can be set up with the details.
            self.updateUI()
        }
    }
    
    func updateUI() {
        currentEvolutionImage.image = mainPokeImage
        currentEvolutionImage.hidden = false
        descriptionLabel.text = pokemon.pokeDescription
        typeLabel.text = pokemon.pokeType
        defenseLabel.text = pokemon.defense
        heightLabel.text = pokemon.height
        pokedexIDLabel.text = "\(pokemon.pokedexID)"
        weightLabel.text = pokemon.weight
        baseAttackLabel.text = pokemon.baseAttack
        
        if pokemon.nextEvolutionID == "" {
            nextEvolutionLabel.text = "No Evolutions"
            nextEvolutionImage.hidden = true
        } else {
            nextEvolutionImage.hidden = false
            nextEvolutionImage.image = UIImage(named: pokemon.nextEvolutionID)
            
            var evolutionText = "Next Evolution: \(pokemon.nextEvolutionText)"
            
            if pokemon.nextEvolutionLevel != "" {
                evolutionText += " - LVL \(pokemon.nextEvolutionLevel)"
            }
            
            nextEvolutionLabel.text = evolutionText
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
