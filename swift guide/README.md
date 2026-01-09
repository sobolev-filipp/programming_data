<h1>Справочник SWIFT</h1>

<h2>Оглавление</h2>
<ol>
  <li><a href="#create_app">Создание первого IOS приложения</a></li>
  <li><a href="#let_const">Переменные и константы</a></li>
  <li><a href="#type_date">Типы данных в Swift</li>
  <li><a href="#operator">Операторы в Swift</a></li>
  <li><a href="#controls">Контроль потока выполнения (ветвления)</a></li>
  <li><a href="#functions">Функции в Swift</a></li>
  <li><a href="#collections">Коллекции в Swift</a></li>
</ol>

<h2 id="create_app">Создание первого IOS приложения</h2>
<img width="300" height="300" src="https://terminalroot.com/assets/img/programming/swift.jpg" />

1.	Запустите Xcode.
2.	Выберите пункт <b>“Create a new Xcode project”</b> (создание нового проекта).
3.	В открывшемся окне выберите категорию <b>“Application”</b> слева и шаблон <b>“Application”</b> справа.
4.	Нажмите кнопку <b>“Next”</b>.
5.	Заполните параметры проекта:
  + <b>Product Name:</b> придумайте короткое и запоминающееся название (например FirstApp).
  + <b>Team:</b> оставьте пустым, если у вас нет учётной записи разработчика Apple.
  + <b>Organization Identifier:</b> введите обратный домен (например, com.example).
  + <b>Interface:</b> выберите Storyboard.
  + <b>Language:</b> выберите Swift.
  + <b>Use Core Data</b> / <b>Include Unit Tests </b>/ <b>Include UI Tests</b>: отключите эти опции.
7.	Нажмите <b>“Next”</b> и выберите папку для сохранения проекта. Нажмите “Create”.

<h2 id="let_const">Переменные и константы</h2>
<p>Переменные и константы служат для хранения данных в программе.</p>

<h3>Константы (const)</h3>
<p>Константы объявляются с помощью ключевого слова let и не могут быть изменены после присвоения значения.</p>

<p>Пример:</p>

```swift
let pi = 3.14
pi = 3.15 // Ошибка! Нельзя изменить значение константы.
```

<h2>Переменные (var)</h2>

```swift
var age = 12
age += 1 // Теперь возраст равен 13
```

<h2 id="type_date">Типы данных в Swift</h2>
<p>Swift поддерживает широкий спектр встроенных типов данных:</p>

<ul>
  <li><b>Int</b>: целые числа</li>
  <li><b>Double</b> или <b>Float</b>: дробные числа</li>
  <li><b>Bool</b>: логические значения</li>
  <li><b>String</b>: строки</li>
  <li><b>Array</b>: массивы</li>
  <li><b>Dictionary</b>: словари</li>
  <li><b>Set</b>: множества</li>
</ul>

<p>Примеры объявлений:</p>

```swift
//let имя_переменной: тип_данных = значение
let integerValue: Int = 10
let doubleValue: Double = 3.14
let booleanValue: Bool = true
let stringValue: String = "Привет"
```

<h2 id="operator">Операторы в Swift</h2>
<p>Операторы выполняют стандартные математические и логические операции.</p>

<h3>Арифметические операторы:</h3>
<ul>
  <li><b>+</b> - сложение</li>
  <li><b>-</b> - вычитание</li>
  <li><b>*</b> - умножение</li>
  <li><b>/</b> - деление</li>
  <li><b>%</b> - остаток от  деления</li>
</ul>

<p>Пример:</p>

```swift
let sum = 5 + 3 // Результат: 8
let remainder = 10 % 3 // Остаток: 1
```

<h3>Операторы сравнения:</h3>
<ul>
  <li><b>==</b> - равно</li>
  <li><b>!=</b> - не равно</li>
  <li><b><</b> - меньше</li>
  <li><b>></b> - больше</li>
  <li><b><=</b> - меньше или равно</li>
  <li><b>>=</b> - больше или равно</li>
</ul>

<p>Пример:</p>

```swift
let isEqual = 5 == 5 // Истина
let notEqual = 5 != 3 // Истина
```

<h3>Логические операторы:</h3>
<ul>
  <li><b>&&</b> - логическое <b></b>И</b></li>
  <li><b>||</b> - логическое <b>ИЛИ</b></li>
  <li><b>!</b> - отрицание</li>
</ul>

<p>Пример:</p>

```swift
let result = true && false // Ложь
let anotherResult = !false || true // Истина
```

<h2 id="controls">Контроль потока выполнения (ветвления)</h2>
<p>Управляющие конструкции позволяют изменять порядок выполнения программы в зависимости от условий.</p>

<h3>Конструкция if-else:</h3>
<p>Выполняет блок кода, если условие истинно.</p>
<p>Пример:</p>

```swift
let temperature = 25

if temperature >= 30 {
    print("Жарко")
} else if temperature >= 20 {
    print("Тепло")
} else {
    print("Прохладно")
}
```

<h3>Конструкция switch-case:</h3>
<p>Альтернативный способ ветвления, позволяющий проверять множество возможных значений.</p>
<p>Пример:</p>

```swift
let day = "суббота"

switch day {
case "понедельник", "вторник", "среда", "четверг", "пятница":
    print("Будний день")
case "суббота", "воскресенье":
    print("Выходной")
default:
    print("Неправильный день")
}
```

<h2 id="functions">Функции в Swift</h2>
<p>Функции позволяют группировать фрагменты кода и многократно использовать их.</p>

<h3>Простая функция:</h3>

```swift
func greet(name: String) {
    print("Здравствуйте, $name)")
}

greet(name: "Иван") // Вывод: "Здравствуйте, Иван"
```

<h3>Функция с возвратом значения:</h3>

```swift
func addNumbers(a: Int, b: Int) -> Int {
    return a + b
}

let result = addNumbers(a: 5, b: 3) // Результат: 8
```

<h2 id="collections">Коллекции в Swiftd</h2>
<p>Коллекции позволяют хранить группы данных.</p>

<h3>Массивы (Array):</h3>
<p>Хранят упорядоченные последовательности элементов одного типа.</p>

<p>Пример:</p>

```swift
var numbers = [1, 2, 3, 4, 5]
numbers.append(6) // Добавляет элемент в конец массива
```

<h4>Основные операции</h4>
<h5>Создание массива</h5>

```swift
let array = [1, 2, 3]
```

<p>или пустой массив определенного типа:</p>

```swift
var emptyArray: [Int] = []
```

<h5>Добавление элементов</h5>
<ul>
  <li><b>append</b> - добавляет элемент в конец массива:</li>

```swift
array.append(4)
```
  
  <li><b>insert(at)</b> - вставляет элемент в указанную позицию:</li>

```swift
array.insert(0, аи: 0)
```

</ul>

<h5>Удаление элементов</h5>
<ul>
  <li><b>removeLast()</b> - удаляет последний элемент:</li>

```swift
array.removeLast()
```
  
  <li><b>removeFirst()</b> - удаляет первый элемент:</li>

```swift
array.removeFirst()
```
  
  <li><b>remove(at)</b> - удаляет элемент по индексу:</li>

```swift
array.remove(at: 1)
```
  
</ul>

<h5>Доступ к элементам</h5>
<ul>
  <li><b>first</b>,<b>last</b> - доступ к первому и последнему элементам соответственно:</li>

```swift
if let firstElement = array.first {
    print(firstElement)
}
```
  
  <li><b>count</b> - возвращает количество элементов в массиве:</li>

```swift
print(array.count)
```
  
</ul>

<h5>Обход элементов</h5>
<ul>
  <li>Через цикл <b>for</b>:</li>

```swift
for element in array {
    print(element)
}
```
  
  <li>Использование индексов:</li>

```swift
for index in array.indices {
    print("Index: $index), Value: $array[index])")
}
```
  
</ul>

<h5>Изменение порядка элементов</h5>
<ul>
  <li><b>reverse()</b> - переворачивает порядок элементов:</li>

```swift
let reversedArray = array.reversed()
```
  
  <li><b>sort(by:)</b> - сортирует элементы по заданному критерию:</li>

```swift
let sortedArray = array.sorted { $0 < $1 }
```
  
</ul>

<h5>Поиск элемента</h5>
<ul>
  <li><b>contains()</b> - проверяет наличие элемента:</li>

```swift
if array.contains(3) {
    print("Есть!")
}
```
  
  <li><b>filter()</b> - фильтрует элементы по условию:</li>

```swift
let filteredArray = array.filter { $0 > 2 }
```
  
</ul>

<h2>Словари (Dictionary):</h2>
<p>Хранят пары ключ-значение.</p>
<p>Пример:</p>

```swift
var studentGrades = ["Иван": 5, "Марина": 4]
studentGrades["Сергей"] = 3 // Добавляет новую оценку
```
