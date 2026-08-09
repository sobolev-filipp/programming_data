<h1>2D Платформер — враги и препятствия</h1>

<h2>🟥 ЧАСТЬ 1 — СОЗДАЁМ ПРОСТОГО ВРАГА</h2>
<p>В этом уроке мы создадим простого врага для нашей игры. Враг будет двигаться влево и вправо, а также будет взаимодействовать с игроком.</p>
<h3>Шаг 1: Создание врага</h3>
<ol>
    <li>Создайте новый GameObject в Unity и назовите его "Enemy".</li>
    <li>Добавьте компонент Sprite Renderer и выберите спрайт для врага.</li>
    <li>Добавьте компонент Box Collider 2D и настройте его размер так, чтобы он соответствовал спрайту врага.</li>
    <li>Добавьте компонент Rigidbody 2D и установите его Body Type на "Kinematic".</li>
    <li>Freeze Rotation Z → включить</li>
</ol>

> Kinematic — это тип Rigidbody, который не подвержен физическим силам, но может взаимодействовать с другими объектами через коллайдеры. Это идеально подходит для врагов, которые должны двигаться по определённому пути, не влияя на физику игры.

> Freeze Rotation Z — это настройка, которая предотвращает вращение объекта вокруг оси Z. Это полезно для 2D игр, чтобы враг не вращался при столкновениях или движении.

<hr>
<br>
<h2>🟥 ЧАСТЬ 2 — ПАТРУЛИРОВАНИЕ</h2>

<p>Теперь мы добавим патрулирование для нашего врага, чтобы он двигался между двумя точками.</p>

<h3>Шаг 1: Добавление скрипта патрулирования</h3>
<ol>
    <li>Создайте новый C# скрипт и назовите его "EnemyPatrol".</li>
    <li>Откройте скрипт и добавьте следующий код:</li>  
</ol>

```csharp
using UnityEngine;

public class EnemyPatrol : MonoBehaviour
{
    public float speed = 2f;
    private Rigidbody2D rb;
    private bool movingRight = true;

    void Start()
    {
        rb = GetComponent<Rigidbody2D>();
    }

    void Update()
    {
        if (movingRight)
        {
            rb.linearVelocity = new Vector2(speed, rb.linearVelocity.y);
        }
        else
        {
            rb.linearVelocity = new Vector2(-speed, rb.linearVelocity.y);
        }
    }

    void Flip()
    {
        movingRight = !movingRight;

        Vector3 scale = transform.localScale;
        scale.x *= -1;
        transform.localScale = scale;
    }
}
```

<p>Этот скрипт заставляет врага двигаться влево и вправо. Метод Flip() меняет направление движения и зеркально отражает спрайт врага.</p>
<h3>Шаг 2: Настройка точек патрулирования</h3>
<ol>
    <li>Создайте два пустых GameObject и назовите их "PointA" и "PointB".</li>
    <li>Расположите эти объекты по обе стороны от врага, чтобы они определяли границы его патрулирования.</li>
    <li>Добавьте следующий код в скрипт EnemyPatrol для проверки столкновений с этими точками:</li>

```csharp
void OnTriggerEnter2D(Collider2D other)
{
    if (other.gameObject.CompareTag("PointA") || other.gameObject.CompareTag("PointB"))
    {
        Flip();
    }
}
```

<li>Убедитесь, что объекты PointA и PointB имеют тег "PointA" и "PointB" соответственно.</li>   
</ol>

<h4>🧠 Объяснение</h4>
<p>Когда враг сталкивается с одной из точек патрулирования, метод OnTriggerEnter2D вызывается, и враг меняет направление движения с помощью метода Flip(). Это позволяет врагу бесконечно патрулировать между двумя точками.</p>

<hr>
<br>
<h2>🟥 ЧАСТЬ 3 — Чтобы враг не падал с платформы</h2>
<p>Чтобы враг не падал с платформы, мы добавим дополнительный коллайдер, который будет проверять наличие платформы перед врагом.</p>
<h3>Шаг 1: Добавление коллайдера для проверки платформы</h3>
<ol>
    <li>Создайте новый пустой GameObject и назовите его "GroundCheck".</li>
    <li>Расположите его перед врагом, на уровне его ног.</li>
    <li>Добавьте компонент Box Collider 2D и установите его размер так, чтобы он покрывал область перед врагом.</li>
    <li>Установите Is Trigger → true для этого коллайдера.</li>
    <li>Добавьте следующий код в скрипт EnemyPatrol для проверки наличия платформы:</li>

<br>

```csharp
public Transform groundCheck;
public float groundDistance = 0.2f;
public LayerMask groundLayer;
````

```csharp
bool isGrounded = Physics2D.Raycast(groundCheck.position, Vector2.down, groundDistance, groundLayer);

if (!isGrounded)
{
    Flip();
}
```

</ol>

> Убедитесь, что groundCheck ссылается на объект GroundCheck, а groundLayer настроен на слой, который используется для платформ.

<p>Этот код использует луч (Raycast) для проверки наличия платформы перед врагом. Если платформа отсутствует, враг меняет направление движения, чтобы не упасть.</p>

<hr>
<br>
<h2>🟥 ЧАСТЬ 4 — УРОН ИГРОКУ</h2>

<p>Теперь мы добавим возможность врагу наносить урон игроку при столкновении.</p>
<h3>Шаг 1: Добавление скрипта для получения урона у игрока</h3>
<ol>
    <li>Создайте новый C# скрипт и назовите его "PlayerHealth".</li>
    <li>Откройте скрипт и добавьте следующий код:</li>

```csharp
using UnityEngine;

public class PlayerHealth : MonoBehaviour
{
    public int health = 3;

    public void TakeDamage(int damage)
    {
        health -= damage;

        if (health <= 0)
        {
            Destroy(gameObject);
        }
    }
}
```

<li>Добавьте этот скрипт на объект игрока.</li>
</ol>

<h3>Шаг 2: Добавление урона от врага</h3>
<ol>
    <li>Добавьте следующий код в скрипт EnemyPatrol для нанесения урона игроку при столкновении:</li>

```csharp
void OnCollisionEnter2D(Collision2D other)
{
    if (other.gameObject.CompareTag("Player"))
    {
        PlayerHealth playerHealth = other.gameObject.GetComponent<PlayerHealth>();
        if (playerHealth != null)
        {
            playerHealth.TakeDamage(1);
        }
    }
}
```

</ol>

> Убедитесь, что объект игрока имеет тег "Player".

<h4>🧠 Объяснение</h4>
<p>Когда враг сталкивается с игроком, метод <b>OnCollisionEnter2D</b> вызывается, и враг наносит урон игроку, вызывая метод <b>TakeDamage()</b> из скрипта <b>PlayerHealth</b>. Если здоровье игрока достигает нуля, объект игрока уничтожается.</p>

<hr>
<br>
<h2>🟥 ЧАСТЬ 5 — УБИЙСТВО ВРАГА ПРЫЖКОМ</h2>

<p>Теперь мы добавим возможность игроку убивать врага, прыгая на него сверху.</p>
<h3>Шаг 1: Добавление проверки для убийства врага</h3>
<ol>

```csharp
public int health = 3;
```

<li>Исправим код в скрипте EnemyPatrol для проверки, был ли враг убит прыжком:</li>

```csharp
void OnCollisionEnter2D(Collision2D other)
{
    if (other.gameObject.CompareTag("Player"))
    {
        PlayerHealth playerHealth = other.gameObject.GetComponent<PlayerHealth>();
        if (playerHealth != null)
        {
            // Проверяем, был ли игрок сверху врага
            if (other.contacts[0].normal.y > 0.5f)
            {
                Destroy(gameObject);
            }
            else
            {
                playerHealth.TakeDamage(1);
            }
        }
    }
}
```

</ol>

<h4>🧠 Объяснение</h4>
<p>В этом коде мы проверяем направление столкновения между игроком и врагом. Если нормаль контакта указывает вверх (y > 0.5), это означает, что игрок прыгнул на врага, и враг уничтожается. В противном случае игрок получает урон.</p>


<hr>
<br>
<h2>🟥 ЧАСТЬ 6 — Система здоровья врага</h2>
<p>Теперь мы добавим систему здоровья для врага, чтобы он не умирал от одного прыжка, а мог выдержать несколько ударов.</p>
<h3>Шаг 1: Добавление системы здоровья для врага</h3>
<ol>
    <li>Добавьте следующие переменные в скрипт EnemyPatrol для управления здоровьем врага:</li>

```csharp
public int health = 3;
```

<li>Исправим код в методе OnCollisionEnter2D для уменьшения здоровья врага при прыжке игрока:</li>

```csharp
void OnCollisionEnter2D(Collision2D other)
{
    if (other.gameObject.CompareTag("Player"))
    {
        PlayerHealth playerHealth = other.gameObject.GetComponent<PlayerHealth>();
        if (playerHealth != null)
        {
            // Проверяем, был ли игрок сверху врага
            if (other.contacts[0].normal.y > 0.5f)
            {
                health -= 1;
                if (health <= 0)
                {
                    Destroy(gameObject);
                }
            }
            else
            {
                playerHealth.TakeDamage(1);
            }
        }
    }
}
```

</ol>
<hr>
<br>
<h2>🟥 ЧАСТЬ 7 — Подключаем урон от атаки игрока</h2>
<p>Теперь мы добавим возможность игроку атаковать врага с помощью оружия, например, меча или пули.</p>
<h3>Шаг 1: Добавление оружия для игрока</h3>
<ol>
    <li>Создайте новый GameObject для оружия игрока, например, "Sword".</li>
    <li>Добавьте компонент Sprite Renderer и выберите спрайт для оружия.</li>
    <li>Добавьте компонент Box Collider 2D и установите его размер так, чтобы он соответствовал спрайту оружия.</li>
    <li>Установите Is Trigger → true для этого коллайдера.</li>
    <li>Добавьте следующий код в новый скрипт "PlayerAttack" для нанесения урона врагу при столкновении с оружием:</li>

```csharp
using UnityEngine;
public class PlayerAttack : MonoBehaviour
{
    public int damage = 1;

    void OnTriggerEnter2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Enemy"))
        {
            EnemyPatrol enemyHealth = other.gameObject.GetComponent<EnemyPatrol>();
            if (enemyHealth != null)
            {
                enemyHealth.health -= damage;
                if (enemyHealth.health <= 0)
                {
                    Destroy(other.gameObject);
                }
            }
        }
    }
}
```

<li>Добавьте этот скрипт на объект оружия игрока.</li>
</ol>

<h4>🧠 Объяснение</h4>
<ul>
    <li>Когда оружие игрока сталкивается с врагом, метод <b>OnTriggerEnter2D</b> вызывается, и враг получает урон, уменьшая его здоровье.</li>
    <li>Если здоровье врага достигает нуля, он уничтожается.</li>
</ul>

<p>Теперь, когда игрок атакует врага с помощью оружия, враг получает урон, и если его здоровье достигает нуля, он уничтожается. Это добавляет дополнительный способ взаимодействия между игроком и врагами в игре.</p>

<hr>
<br>
<h2>🟥 ЧАСТЬ 8 — Система очков</h2>
<p>Теперь мы добавим систему очков, чтобы игрок получал очки за убийство врагов.</p>
<h3>Шаг 1: Добавление системы очков</h3>
<ol>
    <li>Создайте новый C# скрипт и назовите его "ScoreManager".</li>
    <li>Откройте скрипт и добавьте следующий код для управления очками:</li>

```csharp
using UnityEngine;
using UnityEngine.UI;
public class ScoreManager : MonoBehaviour
{
    public static ScoreManager instance;
    public int score = 0;
    public Text scoreText;

    void Awake()
    {
        if (instance == null)
        {
            instance = this;
        }
        else
        {
            Destroy(gameObject);
        }
    }

    public void AddScore(int points)
    {
        score += points;
        UpdateScoreText();
    }

    void UpdateScoreText()
    {
        scoreText.text = "Score: " + score.ToString();
    }
}
```

<h4>🧠 Объяснение</h4>
<ul>
    <li>Этот скрипт использует паттерн Singleton для обеспечения единственного экземпляра ScoreManager в игре.</li>
    <li>Метод AddScore() позволяет добавлять очки и обновлять текст на экране.</li>
    <li>Метод UpdateScoreText() обновляет отображение очков на экране.</li>
    <li>Awake() — это метод, который вызывается при создании объекта, и он используется для инициализации переменных.</li>
</ul>

<li>Добавьте этот скрипт на новый GameObject в сцене, например, "GameManager".</li>
<li>Создайте UI Text элемент для отображения очков и назначьте его переменной scoreText в скрипте ScoreManager.</li>
<li>Исправим код в скрипте PlayerAttack для добавления очков при убийстве врага:</li>

```csharp
using UnityEngine;

public class PlayerAttack : MonoBehaviour
{
    public int damage = 1;

    void OnTriggerEnter2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Enemy"))
        {
            EnemyPatrol enemyHealth = other.gameObject.GetComponent<EnemyPatrol>();
            if (enemyHealth != null)
            {
                enemyHealth.health -= damage;
                if (enemyHealth.health <= 0)
                {
                    Destroy(other.gameObject);
                    ScoreManager.instance.AddScore(10); // Добавляем 10 очков за убийство врага
                }
            }
        }
    }
}
```
</ol>

<h4>🧠 Объяснение</h4>
<ul>
    <li>Когда враг уничтожается, мы вызываем метод AddScore() из ScoreManager, чтобы добавить очки за убийство врага.</li>
    <li>EnemyPatrol — это скрипт, который управляет здоровьем врага.</li>
    <li>В данном примере мы добавляем 10 очков за каждого убитого врага, но вы можете настроить это значение по своему усмотрению.</li>
</ul>

<p>Теперь, когда игрок убивает врага, он получает очки, которые отображаются на экране. Это добавляет элемент вознаграждения и мотивации для игрока в игре.</p>

<hr>
<br>
<h2>🟥 ЧАСТЬ 9 — ШИПЫ</h2>
<p>Теперь мы добавим шипы, которые будут наносить урон игроку при столкновении.</p>
<h3>Шаг 1: Создание шипов</h3>
<ol>
    <li>Создайте новый GameObject и назовите его "Spike".</li>
    <li>Добавьте компонент Sprite Renderer и выберите спрайт для шипов.</li>
    <li>Добавьте компонент Box Collider 2D и настройте его размер так, чтобы он соответствовал спрайту шипов.</li>
    <li>Установите Is Trigger → true для этого коллайдера.</li>
    <li>Добавьте следующий код в новый скрипт "SpikeDamage" для нанесения урона игроку при столкновении с шипами:</li>

```csharp
using UnityEngine;
public class SpikeDamage : MonoBehaviour
{
    public int damage = 1;

    void OnTriggerEnter2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            PlayerHealth playerHealth = other.gameObject.GetComponent<PlayerHealth>();
            if (playerHealth != null)
            {
                playerHealth.TakeDamage(damage);
            }
        }
    }
}
```

<li>Добавьте этот скрипт на объект шипов.</li>
</ol>

>> Trigger — это тип коллайдера, который не вызывает физические столкновения, а вместо этого вызывает события при входе, выходе или нахождении другого объекта внутри него. Это идеально подходит для объектов, которые должны взаимодействовать с игроком без физического воздействия, таких как шипы.

<p>Теперь, когда игрок сталкивается с шипами, он получает урон, не взаимодействуя физически с ними. Это добавляет дополнительный элемент сложности в игру, заставляя игрока избегать шипов.</p>

<hr>
<br>
<h2>🟥 ЧАСТЬ 10 — ДВИЖУЩАЯСЯ ПЛАТФОРМА</h2>

<p>Теперь мы добавим движущуюся платформу, которая будет перемещаться между двумя точками, подобно врагу.</p>
<h3>Шаг 1: Создание движущейся платформы</h3>
<ol>
    <li>Создайте новый GameObject и назовите его "MovingPlatform".</li>
    <li>Добавьте компонент Sprite Renderer и выберите спрайт для платформы.</li>
    <li>Добавьте компонент Box Collider 2D и настройте его размер так, чтобы он соответствовал спрайту платформы.</li>
    <li>Добавьте компонент Rigidbody 2D и установите его Body Type на "Kinematic".</li>
    <li>Freeze Rotation Z → включить</li>
    <li>Добавьте следующий код в новый скрипт "MovingPlatform" для перемещения платформы между двумя точками:</li>

```csharp
using UnityEngine;
public class MovingPlatform : MonoBehaviour
{
    public Transform pointA;
    public Transform pointB;
    public float speed = 2f;
    private bool movingToB = true;

    void Update()
    {
        if (movingToB)
        {
            transform.position = Vector3.MoveTowards(transform.position, pointB.position, speed * Time.deltaTime);
            if (transform.position == pointB.position)
            {
                movingToB = false;
            }
        }
        else
        {
            transform.position = Vector3.MoveTowards(transform.position, pointA.position, speed * Time.deltaTime);
            if (transform.position == pointA.position)
            {
                movingToB = true;
            }
        }
    }
}
```

<li>Создайте два пустых GameObject и назовите их "PlatformPointA" и "PlatformPointB".</li>
<li>Расположите эти объекты по обе стороны от платформы, чтобы они определяли границы её движения.</li>
<li>Убедитесь, что переменные pointA и pointB в скрипте MovingPlatform ссылаются на объекты PlatformPointA и PlatformPointB соответственно.</li>
</ol>

<p>Теперь платформа будет плавно перемещаться между двумя точками, создавая динамическую среду для игрока. Игрок может использовать эту платформу для преодоления препятствий или достижения новых областей в игре.</p>

<hr>
<br>
<h2>🟥 ЧАСТЬ 11 — Layers</h2>

<p>Теперь мы рассмотрим использование слоёв (Layers) в Unity для управления взаимодействиями между различными объектами в игре.</p>
<h3>Шаг 1: Создание слоёв</h3>
<ol>
    <li>Перейдите в Unity и откройте окно "Layers" (Слои) в верхней части редактора.</li>
    <li>Нажмите на "Edit Layers" (Редактировать слои) и добавьте новые слои, например, "Player", "Enemy", "Platform", "Spike".</li>
    <li>Назначьте соответствующие слои для объектов в вашей игре. Например, игроку присвойте слой "Player", врагам — слой "Enemy", платформам — слой "Platform", а шипам — слой "Spike".</li>   
</ol>

<hr>
<br>
<h2>Практика для самостоятельного выполнения</h2>
<p>Теперь, когда мы рассмотрели основные механики для создания 2D платформера, попробуйте самостоятельно реализовать следующие функции:</p>
<ol>
    <li>Добавьте новый тип врага, который будет стрелять в игрока.</li>
    <li>Создайте новый уровень с различными платформами и препятствиями.</li>
    <li>Добавьте систему жизней для игрока, чтобы он мог пережить несколько ударов от врагов или шипов.</li>
    <li>Сделать врага быстрее</li>
    <li>Сделать врага с 5 жизнями</li>
    <li>Сделать врага который даёт 50 очков</li>
</ol>