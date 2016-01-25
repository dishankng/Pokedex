//
//  Pokemon.swift
//  Pokédex
//
//  Created by Dishank on 1/21/16.
//  Copyright © 2016 Dishank. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _height: String!
    private var _weight: String!
    private var _defense: String!
    private var _attack: String!
    private var _nextEvoTxt: String!
    private var _nextEvoId: String!
    private var _nextEvoLvl: String!
    private var _speed: String!
    private var _hp: String!
    private var _pokemonUrl: String!
    
    var name: String {
        return _name
    }
    var pokedexId: Int {
        return _pokedexId
    }
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    var nextEvoId: String {
        if _nextEvoId == nil {
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    var nextEvoTxt: String {
        if _nextEvoTxt == nil {
            _nextEvoTxt = ""
        }
        return _nextEvoTxt
    }
    var nextEvolvl: String {
        if _nextEvoLvl == nil {
            _nextEvoLvl = ""
        }
        return _nextEvoLvl
    }
    var speed: String {
        if _speed == nil {
            _speed = ""
        }
        return _speed
    }
    var hp: String {
        if _hp == nil {
            _hp = ""
        }
        return _hp
    }
    
    init(name: String, pokedexID: Int) {
        self._name = name
        self._pokedexId = pokedexID
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(pokedexId)/"
        
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _pokemonUrl)!
//        Alamofire.request(.GET, url).responseJSON{(request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) -> Void in//        Alamofire.request(.GET, url).responseJSON { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) -> Void in
//        }
        Alamofire.request(.GET, url).responseJSON { (response) -> Void in
            
            let result = response.result.value
//            print(result.debugDescription)
            
            if let dict = result as? Dictionary<String,AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let speed = dict["speed"] as? Int {
                    self._speed = "\(speed)"
                }
                
                if let health = dict["hp"] as? Int {
                    self._hp = "\(health)"
                }
                
//                print(self._height)
//                print(self._speed)
//                print(self._hp)
//                print(self._weight)
                
                if let types = dict["types"] as? [Dictionary<String,String>] where types.count > 0 {
                    
                    if let type = types[0]["name"] {
                        self._type = type.uppercaseFirst
                    }
                    
                    if types.count > 1 {
                        for var i = 1; i < types.count; i++ {
                            if let type = types[i]["name"] {
                                self._type! += "/\(type.uppercaseFirst)"
                            }
                        }
                    }
                } else {
                    self._type! += ""
                }

//                print(self._type)
                
                if let descArr = dict["descriptions"] as? [Dictionary<String,String>] where descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        
                        Alamofire.request(.GET, nsurl).responseJSON { (response) -> Void in
                            let result = response.result.value
                            
                            if let descDict = result as? Dictionary<String,AnyObject> {
                                
                                if let desc = descDict["description"] as? String {
                                    self._description = desc
//                                    print(self._description)
                                }
                            }
                            completed()
                        }
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] where evolutions.count > 0 {
                    if let nextEvo = evolutions[0]["to"] as? String {
                        //Can't support mega pokemon for now
                        if nextEvo.rangeOfString("mega") == nil {
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let tempStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = tempStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvoTxt = nextEvo
                                self._nextEvoId = num
                            }
                            
                            if let lvl = evolutions[0]["level"] as? Int {
                                self._nextEvoLvl = "\(lvl)"
                            }
//                            print(self._nextEvoId)
//                            print(self._nextEvoLvl)
//                            print(self._nextEvoTxt)
                        }
                    }
                }

            }
        }
        
        
    }
}