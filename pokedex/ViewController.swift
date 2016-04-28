//
//  ViewController.swift
//  pokedex
//
//  Created by William L. Marr III on 4/25/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    let volumeImageOFF = UIImage(named: "volume-OFF.png")
    let volumeImageON = UIImage(named: "volume-ON.png")
    var inSearchMode = false
    var filteredPokemon = [Pokemon]()

    override func viewDidLoad() {
        super.viewDidLoad()

        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        initAudio()
        parsePokemonCSV()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetail" {
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                    
                    if let indexPaths = collection.indexPathsForSelectedItems() {
                        collection.deselectItemAtIndexPath(indexPaths[0], animated: false)
                    }
                }
            }
        }
    }

    func initAudio() {
        if let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3") {
            let musicURL = NSURL(fileURLWithPath: path)
            
            do {
                musicPlayer = try AVAudioPlayer(contentsOfURL: musicURL)
                musicPlayer.prepareToPlay()
                musicPlayer.numberOfLoops = -1
                musicPlayer.play()
                
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
    }
    
    func parsePokemonCSV() {
        
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let pokeID = Int(row["id"]!)!
                let name = row["identifier"]!
                let creature = Pokemon(name: name, pokedexID: pokeID)
                pokemon.append(creature)
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    @IBAction func volumeButtonTapped(sender: UIButton) {
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.setImage(volumeImageOFF, forState: .Normal)
        } else {
            musicPlayer.play()
            sender.setImage(volumeImageON, forState: .Normal)
        }
    }
}


extension ViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pokemonCell", forIndexPath: indexPath) as? PokeCell {
            
            //let poke = pokemon[indexPath.row]
            let poke: Pokemon!
            
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            
            cell.configureCell(poke)
            
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPokemon.count
        }
        
        return pokemon.count
    }
}

extension ViewController: UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        
        performSegueWithIdentifier("PokemonDetail", sender: poke)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
        } else {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercaseString
            filteredPokemon = pokemon.filter( {$0.name.rangeOfString(lower) != nil} )
        }

        collection.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        inSearchMode = false
        view.endEditing(true)
        collection.reloadData()
    }
}
