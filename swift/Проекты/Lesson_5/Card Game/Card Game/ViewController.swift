//
//  ViewController.swift
//  Card Game
//
//  Created by Соболев Филипп on 28.01.2026.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var Card: UIImageView!
    @IBOutlet weak var Score_Label: UILabel!
    
    var card_list: [String] = ["cube1","cube2","cube3","cube4","cube5","cube6"]
    var index: Int = 0
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func generation(){
        index = Int.random(in:0..<card_list.count)
        Card.image = UIImage(named: card_list[index])
    }

    @IBAction func Add_Score(_ sender: Any) {
        generation()
        score += index + 1
        Score_Label.text = "Счет: \(score)"
    }
}

