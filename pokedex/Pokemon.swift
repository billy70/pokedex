//
//  Pokemon.swift
//  pokedex
//
//  Created by William L. Marr III on 4/25/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexID: Int!
    private var _description = ""
    private var _type = ""
    private var _defense = ""
    private var _height = ""
    private var _weight = ""
    private var _baseAttack = ""
    private var _moves = ""
    private var _nextEvolutionID = ""
    private var _nextEvolutionLevel = ""
    private var _nextEvolutionText = ""
    private var _pokemonURL = ""
    
    var name: String {
        return _name
    }
    
    var pokedexID: Int {
        return _pokedexID
    }
    
    var pokeDescription: String {
        return _description
    }
    
    var pokeType: String {
        return _type
    }
    
    var defense: String {
        return _defense
    }
    
    var height: String {
        return _height
    }
    
    var weight: String {
        return _weight
    }
    
    var baseAttack: String {
        return _baseAttack
    }
    
    var moves: String {
        return _moves
    }
    
    var nextEvolutionID: String {
        return _nextEvolutionID
    }
    
    var nextEvolutionLevel: String {
        return _nextEvolutionLevel
    }
    
    var nextEvolutionText: String {
        return _nextEvolutionText
    }
    
    init(name: String, pokedexID: Int) {
        self._name = name
        self._pokedexID = pokedexID
        
        _pokemonURL = "\(URL_BASE)\(URL_POKEMONAPI_V1)\(_pokedexID)/"
    }
    
    func downloadPokemonDetails(completionHandler: DownloadComplete) {
        
        let url = NSURL(string: _pokemonURL)!
        Alamofire.request(.GET, url).responseJSON { response in
            
            print("**> ALAMOFIRE REQUEST:")
            print(response.request)
            print("**> ALAMOFIRE RESPONSE:")
            print(response.response)
            print("**> ALAMOFIRE DATA:")
            print(response.data)
            print("**> ALAMOFIRE RESULT:")
            print(response.result)
            
            if let JSON = response.result.value {
                print("**> ALAMOFIRE JSON:")
                print(JSON)
            }
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let attack = dict["attack"] as? Int {
                    self._baseAttack = String(attack)
                    print("attack: \(attack)")
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = String(defense)
                    print("defense: \(defense)")
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                    print("height: \(height)")
                }
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                    print("weight: \(weight)")
                }
                
                if let typesArray = dict["types"] as? [Dictionary<String, String>] where typesArray.count > 0 {
                    self._type = ""
                    
                    for (index, typeDict) in typesArray.enumerate() {
                        if let pokeType = typeDict["name"] {
                            if index > 0 {
                                self._type += " / "
                            }
                            self._type += pokeType.capitalizedString
                        }
                    }
                    
                    print("types: \(self._type)")
                } else {
                    self._type = ""
                }
                
                if let descriptionArray = dict["descriptions"] as? [Dictionary<String, String>] where descriptionArray.count > 0 {
                    
                    self._description = ""
                    
                    // Get the first entry only (even if there is more than 1)
                    if let url = descriptionArray[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            
                            let descriptionResult = response.result
                            if let descriptionDict = descriptionResult.value as? Dictionary<String, AnyObject> {
                                
                                if let pokeDescription = descriptionDict["description"] as? String {
                                    self._description = pokeDescription
                                    print("description: \(self._description)")
                                }
                            }
                            
                            // Call the passed-in completion handler, which was passed in
                            // by the details view controller.
                            completionHandler()
                        }
                    }
                }

                self._moves = ""
                if let movesArray = dict["moves"] as? [Dictionary<String, AnyObject>] where movesArray.count > 0 {
                    
                    for (index, movesDict) in movesArray.enumerate() {
                        if let pokeMove = movesDict["name"] as? String {
                            if index > 0 {
                                self._moves += ", "
                            }
                            self._moves += pokeMove.capitalizedString
                        }
                    }
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    
                    if let evolveTo = evolutions[0]["to"] as? String {
                        
                        // Skip any "Mega" evolutions for now.
                        if evolveTo.rangeOfString("mega") == nil {
                            
                            self._nextEvolutionText = evolveTo
                            print("next evolution text: \(self._nextEvolutionText)")

                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newStr = uri.stringByReplacingOccurrencesOfString(URL_POKEMONAPI_V1, withString: "")
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                self._nextEvolutionID = num
                                print("evolution ID: \(self._nextEvolutionID)")
                                
                                if let evolutionLevel = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLevel = "\(evolutionLevel)"
                                    print("next evolution level: \(self._nextEvolutionLevel)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
