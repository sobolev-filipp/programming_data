//
//  ViewController.swift
//  Animals_Data
//
//  Created by Соболев Филипп on 08.01.2026.
//

import UIKit

class ViewController: UIViewController,AddAnimalDelegate {
    
    @IBOutlet weak var AnimalNamelabel: UILabel!
    @IBOutlet weak var AnimalImage: UIImageView!
    @IBOutlet weak var AnimalDescLabel: UILabel!
    
    
    
    var animal: [String : [String]] = [
        "name":["Lion", "Tiger"],
        "image":["https://avatars.mds.yandex.net/i?id=dbdfbd0f426546fa3a7feed02d0fdc1e_l-6998336-images-thumbs&n=13","https://avatars.mds.yandex.net/i?id=36b88c254db94f5dfcade2d637d7a7d4a21b9634-5231779-images-thumbs&n=13"],
        "description":["The lion is a large carnivorous mammal of the family Felidae, the lions are the largest of the big cats.",
                      "A tiger is a great wild animal of tremendous beauty, grace and strength. A tiger is one of the largest cats on Earth, but the number of these charming animals is decreasing due to the human hunt and industrial activity."]
    ]
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AnimalNamelabel.layer.cornerRadius = 10
        AnimalImage.layer.cornerRadius = 10
        
        LoadData()
    }

    func LoadData(){
        AnimalNamelabel.text = animal["name"]?[index]
        AnimalImage.image = UIImage(data: try! Data(contentsOf: URL(string: animal["image"]?[index] ?? "")!))
        AnimalDescLabel.text = animal["description"]?[index]
    }
    
    @IBAction func NextDataButton(_ sender: Any) {
        index += 1
        if index >= animal["name"]!.count{
            index = 0
        }
        LoadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showAddAnimalScreen" {
                let destinationVC = segue.destination as! SecondViewController
                destinationVC.delegate = self
            }
        }
    
    func didAddAnimal(name: String, image: String, description: String) {
        animal["name"]?.append(name)
        animal["image"]?.append(image)
        animal["description"]?.append(description)
        index = animal.count - 1
        LoadData()
    }
}



