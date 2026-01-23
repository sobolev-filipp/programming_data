import UIKit

protocol AddAnimalDelegate: AnyObject {
    func didAddAnimal(name: String, image:String, description: String)
}

class SecondViewController: UIViewController {

    
    weak var delegate: AddAnimalDelegate?
    
    @IBOutlet weak var NameLabel: UITextField!
    @IBOutlet weak var LinkLabel: UITextField!
    @IBOutlet weak var DesckLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //Получаем данные из текстовых полей и обращаемся к функции делеката которая сохранит все данные
    @IBAction func SaveData(_ sender: Any) {
        guard let name = NameLabel.text, !name.isEmpty,
              let link = LinkLabel.text, !link.isEmpty,
              let desck = DesckLabel.text, !desck.isEmpty else { return }
        
        delegate?.didAddAnimal(name: name, image: link, description: desck)
        navigationController?.popViewController(animated: true)
        ClearData()
    }
    
    //очищаем данные
    func ClearData(){
        NameLabel.text = ""
        LinkLabel.text = ""
        DesckLabel.text = ""
    }
}
