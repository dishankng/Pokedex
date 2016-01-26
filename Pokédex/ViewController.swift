//
//  ViewController.swift
//  Pokédex
//
//  Created by Dishank on 1/21/16.
//  Copyright © 2016 Dishank. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    var filteredPokemonn = [Pokemon]()
    var cellHeight: CGFloat!
    var cellWidth: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        //STUPID STUFF. CAN BE DONE DIRECTLY FROM THE STORYBOARD
//        searchBar.showsCancelButton = true
//        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKkeyboard")
//        let scroll: UIGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "dismissKkeyboard")
//        view.addGestureRecognizer(tap)
//        view.addGestureRecognizer(scroll)
        
        parsePokemonCSV()
        initAudio()
    
    }
    
    override func viewWillAppear(animated: Bool) {
        dynamicSizeView(UIScreen.mainScreen().bounds.size)
    }
    // Dynamically Change size of the cell depending on the screen size
    func dynamicSizeView(size: CGSize) {
//        print(size.width)
//        print(size.height)
        switch (size.width, size.height) {
        case (375, 667) :
            cellHeight = 110.0
            cellWidth = 110.0
        case (414, 736) :
            cellHeight = 120.0
            cellWidth = 120.0
        case (736, 414) :
            cellHeight = 120.0
            cellWidth = 120.0
        case (768, 1024):
            cellHeight = 125.0
            cellWidth = 125.0
        case (1024, 768):
            cellHeight = 125.0
            cellWidth = 125.0
        case (1024, 1366):
            cellHeight = 125.0
            cellWidth = 125.0
        case (1366, 1024):
            cellHeight = 125.0
            cellWidth = 125.0
        default:
            cellHeight = 93.0
            cellWidth = 93.0
        }
        
    }
    // PARSING THE NAMES AND IDs
    func parsePokemonCSV() {
        if let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv") {
            do {
                let csv = try CSV(contentsOfURL: path)
                let rows = csv.rows
                
                for row in rows {
                    let pokeId = Int(row["id"]!)!
                    let name = row["identifier"]!
//                    print(name)
                    let poke = Pokemon(name: name, pokedexID: pokeId)
                    pokemon.append(poke)
                }
                
            } catch let err as NSError {
                print(err.debugDescription)
            }
        
        }
    }
    
    // SEARCH FILTERING
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            dismissKkeyboard()
            collection.reloadData()
        } else {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercaseString
            
            filteredPokemonn = pokemon.filter({$0.name.rangeOfString(lower) != nil })
            collection.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        dismissKkeyboard()
    }

    func dismissKkeyboard() {
        view.endEditing(true)
    }
    

    // COLLECTIONVIEW DELEGATE METHODS
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return  filteredPokemonn.count
        }
        
        return pokemon.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemonn[indexPath.row]
            performSegueWithIdentifier("PokemonDetailVC", sender: poke)

        } else {
            poke = pokemon[indexPath.row]
            performSegueWithIdentifier("PokemonDetailVC", sender: poke)

        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            
            var poke: Pokemon!
            
            if inSearchMode {
                
                poke = filteredPokemonn[indexPath.row]
                
            } else {
                
                poke = pokemon[indexPath.row]
            }
            cell.configureCell(poke)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(cellWidth, cellHeight)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // AUDIO STUFF
    func initAudio() {
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!))
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    @IBAction func musicBtnPressed(sender: UIButton) {
        
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 1.0
        } else {
            musicPlayer.play()
            sender.alpha = 0.6
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
}

