<h1>Урок 4: Интерфейсы и Storyboard</h1>

<h2>Оглавление</h2>
<ul>
    <li><a href="#"></a></li>
    <li><a href="#"></a></li>
    <li><a href="#"></a></li>
    <li><a href="#"></a></li>
    <li><a href="#practika">Практический проект: Энциклопедия животных</a></li>
    <li><a href="#homework">Домашнее задание</a></li>
</ul>

<h2 id="#practika">Практический проект: Энциклопедия животных</h2>
<p>В данном проекте мы создадим <b>инциклопедию животных</b>. Он подразумевает, что ребенок продолжит знакомиться с интерфейсом <b>Xcode</b>, а также научитсяя создавать новый <b>ViewController</b></p>

<br>
<h3>🖥️ Интерфейс приложения:</h3>
<p>Наше приложение будет иметь следующий интерфейс:</p>
<ul>
    <li>Главная страница с изображением животного и кнопками <b>"Дальше"</b> и <b>"+"</b></li>
    <li>Экран для добавления нового животного</li>
</ul>

<br>
<h3>🧩 Логика работы приложения:</h3>
<ul>
    <li>Приложение отображает карточку с животным и его описанием.</li>
    <li>При нажатии на кнопку <b>"Дальше"</b> появляется новая карточка.</li>
    <li>Пользователь может добавить новое животное через специальный экран.</li>
</ul>

<br>
<h3>Первая страница</h3>

<h4>Весь код первой страницы</h4>

```swift
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
```

<br>
<h4>Настройка первой страницы</h4>

<p>Откройте файл <b>Main.storyboard</b> и добавьте следующие элементы:</p>
<ul>
    <li><b>UIImageView</b> для отображения изображения животного.</li>
    <li><b>UILabel</b> для отображения названия животного.</li>
    <li><b>UILabel</b> для отображения описания животного.</li>
    <li><b>UIButton</b> с надписью <i>"Дальше"</i></li>
    <li><b>UIButton</b> с надписью <i>"+"</i></li>
</ul>

<h5>Создание словаря для хранения информации о животных</h5>

```swift
var animal: [String : [String]] = [
        "name":["Lion", "Tiger"],
        "image":["https://avatars.mds.yandex.net/i?id=dbdfbd0f426546fa3a7feed02d0fdc1e_l-6998336-images-thumbs&n=13","https://avatars.mds.yandex.net/i?id=36b88c254db94f5dfcade2d637d7a7d4a21b9634-5231779-images-thumbs&n=13"],
        "description":["The lion is a large carnivorous mammal of the family Felidae, the lions are the largest of the big cats.",
                      "A tiger is a great wild animal of tremendous beauty, grace and strength. A tiger is one of the largest cats on Earth, but the number of these charming animals is decreasing due to the human hunt and industrial activity."]
```

> var animal: [String : [String]] 
<p>Данная запись говорит нам о том, что был создан словарь в котором <b>ключи хранятся ввиде строк</b> и в <b>каждом из его ключей также хранятся строки</b></p>