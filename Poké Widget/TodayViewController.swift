//
//  TodayViewController.swift
//  Poké Widget
//
//  Created by Dishank on 1/26/16.
//  Copyright © 2016 Dishank. All rights reserved.
//

import UIKit
import NotificationCenter
import Alamofire

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

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var pokeImg: UIImageView!
    var pokeID: Int!
    var _description: String!
    var names = [String]()          //Names array because I couldn't think of a better way to do it :( as the api doesn't fetch names
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        randomizePokemon()
        parsePokemonCSV()
        downloadPokemonDetails { () -> () in
            self.updateUI()
        }
        
    }
    //PARSE AND APPEND NAMES TO THE ARRAY
    func parsePokemonCSV() {
        if let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv") {
            do {
                let csv = try CSV(contentsOfURL: path)
                let rows = csv.rows
                
                for row in rows {
                    let name = row["identifier"]!
                    names.append(name)
                }
                
            } catch let err as NSError {
                print(err.debugDescription)
            }
            
        }
    }
    
    //DOWNLOAD THE DESCRIPTION FOR WIDGET
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: "\(URL_BASE)\(URL_POKEMON)\(pokeID)/")!
        
        Alamofire.request(.GET, url).responseJSON { (response) -> Void in
            let result = response.result.value
            if let dict = result as? Dictionary<String,AnyObject> {
                if let descArr = dict["descriptions"] as? [Dictionary<String,String>] where descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
//                        print(url)
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                    
                        Alamofire.request(.GET, nsurl).responseJSON { (response) -> Void in
                            let result = response.result.value
                        
                            if let descDict = result as? Dictionary<String,AnyObject> {
                            
                                if let desc = descDict["description"] as? String {
                                    self._description = desc
//                                  print(self._description)
                                }
                            }
                            completed()
                        }
                    }
                } else {
                self._description = ""
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //RANDOMIZE THE POKEDEX ID
    func randomizePokemon() {
        self.pokeID = Int(arc4random_uniform(710)) + 1
    }
    
    
    func updateUI() {
        descLbl.text = _description
//        print(_description)

    }
    
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        pokeImg.image = UIImage(named: "\(pokeID)")
        nameLbl.text = names[pokeID - 1].uppercaseFirst // -1 to sync the pokedex id with names array

        completionHandler(NCUpdateResult.NewData)
        
        
    }
    
}
