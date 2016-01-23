//
//  Pokemon.swift
//  Pokédex
//
//  Created by Dishank on 1/21/16.
//  Copyright © 2016 Dishank. All rights reserved.
//

import Foundation

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    
    var name: String {
        return _name
    }
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexID: Int) {
        self._name = name
        self._pokedexId = pokedexID
    }
    
}