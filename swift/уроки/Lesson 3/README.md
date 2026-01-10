<h1>Урок 3: Циклы, случайные числа, специальные операторы и работа с UIPickerView</h1>

<h2>Оглавление</h2>
<ul>
    <li><a target="_blank" href="../../../swift%20guide/README.md#cycle">Циклы в Swift</a></li>
    <li><a target="_blank" href="../../../swift%20guide/README.md#optional">Работа с опционалами и специальными символами</a></li>
    <li><a target="_blank" href="../../../swift%20guide/README.md#generation">Генерация</a></li>
    <li><a target="_blank" href="../../../swift%20guide/README.md#interpolation">Строковая интерполяция</a></li>
    <li><a target="_blank" href="../../../swift%20guide/README.md#guard">guard оператор</a></li>
    <li><a target="_blank" href="../../../swift%20guide/README.md#picker">UIPickerView</a></li>
    <li><a href="#practika">Практический проект: "Генератор случайных историй"</a></li>
</ul>

<h2 id="practika">🎮 Практический проект: "Генератор случайных историй"</h2>
<p>В данном проекте мы будем использовать новый компонент <a target="_blank" href="../../../swift%20guide/README.md#picker">UIPickerView</a>. Он позволит выбирать из списка тематику историй и при помощи словаря и генераций будем создавать различные истории.</p>

<br/>
<h3>Соответствие протоколам</h3>
<p>Класс контроллера должен соответствовать протоколам <b><mark>UIPickerViewDelegate</mark></b> и <b><mark>UIPickerViewDataSource</mark></b>:</p>

```swift
class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
```

<br/>
<h3>Настройка делегата и источника данных</h3>
<p>В методе <b>setupPickerView()</b> устанавливаем делегат и источник данных:</p>

```swift
func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
```

<br/>
<h3>Весь код проекта</h3>

```swift
import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

        // Словарь с тематиками и элементами сюжетов
        var selectedTheme = "Фэнтези"
        let storiesThemes: [String: [String: [String]]] = [
            "Фэнтези": [
                "Characters": ["Принцесса", "Рыцарь", "Дракон"],
                "Actions": ["Исследовал", "Спасал", "Преследовал"],
                "Places": ["Таинственный лес", "Старинный замок", "Темная пещера"],
                "Items": ["Золотой ключ", "Магический меч", "Карта сокровищ"]
            ],
            "Приключения": [
                "Characters": ["Путешественник", "Исследователь", "Капитан корабля"],
                "Actions": ["Исчезал", "Находил", "Искал"],
                "Places": ["Древний храм", "Потерянный город", "Остров сокровищ"],
                "Items": ["Странный амулет", "Старая карта", "Тайный дневник"]
            ],
            "Детектив": [
                "Characters": ["Детектив", "Шпион", "Частный сыщик"],
                "Actions": ["Расследовал", "Следил", "Собирал улики"],
                "Places": ["Городской парк", "Заброшенный особняк", "Скрытая лаборатория"],
                "Items": ["Фотография преступника", "Записка с шифром", "Отпечаток пальца"]
            ]
        ]
    
    
    @IBOutlet weak var storyTextView: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
    }

    func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return storiesThemes.count
        }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(storiesThemes.keys)[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTheme = Array(storiesThemes.keys)[row]
    }
    
    @IBAction func createStoryButtonTapped(_ sender: Any) {
        storyTextView.text = generateStory(theme: selectedTheme)
    }
    
    func generateStory(theme: String) -> String {
        guard let themeDetails = storiesThemes[theme] else {return "Not found"}
                  let characters = themeDetails["Characters"]
                  let actions = themeDetails["Actions"]
                  let places = themeDetails["Places"]
                  let items = themeDetails["Items"]
            
        let character = characters?.randomElement() ?? ""
        let action = actions?.randomElement() ?? ""
        let place = places?.randomElement() ?? ""
        let item = items?.randomElement() ?? ""
            
            return """
            Однажды в далекой стране жил(-а) отважный(-ая) герой по имени \(character), который(-ая) решил(-а) отправиться в путешествие. Он(-а) отправился(-ась) в таинственное место, известное как \(place), где искал(-а) легендарный артефакт, известный как \(item).
            
            Путешествие было полным опасностей и тайн. Герою предстояло преодолеть множество препятствий и сражений. В конечном итоге, после множества приключений, он(-а) успешно завершил(-а) свое приключение и стал(-а) настоящим героем благодаря своей смелости и находчивости.
            """
        }
}
```
