//
//  PokemonDetailVC.swift
//  Pokédex
//
//  Created by Dishank on 1/23/16.
//  Copyright © 2016 Dishank. All rights reserved.
//

import UIKit

extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercaseString + String(characters.dropFirst())
    }
}

class PokemonDetailVC: UIViewController {
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var pokedexIdLbl: UILabel!
    @IBOutlet weak var hptLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvo: UIImageView!
    @IBOutlet weak var nextEvo: UIImageView!
    @IBOutlet weak var transitionImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name.uppercaseFirst
        mainImg.image = UIImage(named: "\(pokemon.pokedexId)")
        currentEvo.image = UIImage(named: "\(pokemon.pokedexId)")
        
        pokemon.downloadPokemonDetails { () -> () in
            //This will be called after downloading is complete
            self.updateUI()
        }
    }
    
    func updateUI() {
        descriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        attackLbl.text = pokemon.attack
        weightLbl.text = pokemon.weight + " lbs"
        heightLbl.text = pokemon.height + "'"
        speedLbl.text = pokemon.speed
        hptLbl.text = pokemon.hp
        pokedexIdLbl.text = "\(pokemon.pokedexId)"
        if pokemon.nextEvoId == "" {
            evoLbl.text = "NO EVOLUTIONS"
            nextEvo.hidden = true
        } else {
            nextEvo.hidden = false
            nextEvo.image = UIImage(named: pokemon.nextEvoId)
            var temp = "Next Evolution: \(pokemon.nextEvoTxt)"
            
            if pokemon.nextEvolvl != "" {
                temp += " LVL-\(pokemon.nextEvolvl)"
            }
            evoLbl.text = temp
        }
    }

    @IBAction func backPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func segmentIndexChanged(sender: AnyObject) {
        if segmentedControl.selectedSegmentIndex == 0 {
            descriptionLbl.text = pokemon.description
        } else if segmentedControl.selectedSegmentIndex == 1 {
            descriptionLbl.text = pokemon.abilities
        }
    }
}
