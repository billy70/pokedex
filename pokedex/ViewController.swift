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
    
    var pokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    let volumeImageOFF = UIImage(named: "volume-OFF.png")
    let volumeImageON = UIImage(named: "volume-ON.png")

    override func viewDidLoad() {
        super.viewDidLoad()

        collection.dataSource = self
        collection.delegate = self
        
        initAudio()
        parsePokemonCSV()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            let poke = pokemon[indexPath.row]
            cell.configureCell(poke)
            
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 718
    }
}

extension ViewController: UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
}
