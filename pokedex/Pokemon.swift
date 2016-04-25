//
//  Pokemon.swift
//  pokedex
//
//  Created by William L. Marr III on 4/25/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import Foundation

class Pokemon {
    
    private var _name: String!
    private var _pokedexID: Int!
    
    var name: String {
        return _name
    }
    
    var pokedexID: Int {
        return _pokedexID
    }
    
    init(name: String, pokedexID: Int) {
        self._name = name
        self._pokedexID = pokedexID
    }
}
