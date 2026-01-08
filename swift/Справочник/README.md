<h1>Справочник SWIFT</h1>

<h2>Оглавление</h2>
<ol>
<li><a href="#create_app">Первое знакомство с интерфейсом Xcode</a></li>
<li><a href="#let_const">Переменные и константы</a></li>
<li><a href="#type_date">Типы данных в Swift</li>
</ol>

<h2 id="create_app">Первое знакомство с интерфейсом Xcode</h2>
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
