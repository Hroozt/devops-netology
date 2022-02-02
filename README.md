# Домашнее задание к занятию "5.1. Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения."
## Задача 1

Опишите кратко, как вы поняли: в чем основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС.
> Аппаратная (Полная) виртуализация - предоставляет прямой доступ к вычеслительным ресурсам для гостевой ОС. Не накладывает ограничения на ядро гостевой ОС.

> Паравиртуализация - Гипервизор установлен на Хостовую ОС. Эмулирует вычислительные можности для гостевой ОС средствами гипервизова. Могут быть проблемы с гостевыми ОС из-за ядра хостовой ОС и вендора гипервизора (Hyper-V имеет много ограничений даже в линейки ОС Windows)

> Виртуализация на основе ОС - разделение вычеслиельных ресурсов ОС хоста. Гостевые ОС \ Сервисы работают с ядром хостовой ОС. 

## Задача 2

Выберите один из вариантов использования организации физических серверов, в зависимости от условий использования.

Организация серверов:
- физические сервера, ``` когда требуется высоконагруженная работа сервиса (СУБД\Майниг\Расчеты\Рендер) с каким либо физическим ресурсом (GPU\SSD\HDD etc), а так же сервис требует определенные драйвера ```
- паравиртуализация, ``` отлично подходит для создания VPS под раздичные вэб сервисы, не чувствительные к дисковой подсистеме и эмулации драйверов. Хорошо работает с сервисами, чуствильными к изменению параметров оборудования (Сервера програмных лицензий 1с например, позволяет мигрировать гостевую ОС без переактивации в некоторых случиях) ```
- виртуализация уровня ОС. ``` подходить для быстрого поднятия микросервисов и их маштабирования. например в среде разработки для подняти песочниц```

Условия использования:
- Высоконагруженная база данных, чувствительная к отказу. `````- Физика. Паравиртуализация - которая позволит без ограничений использовать дисковыую подсистему гостевой ОС.`````
- Различные web-приложения. - `````` Паравиртуализация, виртуализация уровня ОС. VPS для сайтика, Контейнер для песочницы etc ``````
- Windows системы для использования бухгалтерским отделом. - ```Паравиртуализаци и физика.```
- Системы, выполняющие высокопроизводительные расчеты на GPU. ```- Физика.```

Опишите, почему вы выбрали к каждому целевому использованию такую организацию.

## Задача 3

Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.

Сценарии:

1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий.
> Хорошо подойдет IaaS (Облачные сервисы типа Amazon\Даталайн\Яндекс) Имеют балансировщики, позволяют быстро поднимать гостевые ос из шаблонов. Маштабирование.  

2. Требуется наиболее производительное бесплатное open source решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.
> KVM\XEN на вкус и цвет. Если система требует повышенную отказоустойчивость и не требует изменений долгие промежутки времени лучше стабильный XenServer. для более живой и разношерстной системы лучше выбрать KVM так как он имеет более широкий функционал и ольшое количество готовых решений из за большого комьюнити.

3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры.
>Hyper-v server! MS для MS!
> 
>Можно еще XenServer. Имеет набор готовых решений для работы с гостевыми ОС семейства Windows. Xen free имеет ограничения, это явно минус.

4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.
> KVM. Создание нужных шаблонов для разных инсталяций ОС с готовой конфигурацией. Быстрое равертывание гостевой ОС, что безусловно + в тестировании.


## Задача 4

Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, то создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.
> Чем более разношестная инфраструктура, тем более сложнее ее обслуживание. Требуется больше ресурсов на автоматизацию, так как разные системы управления, разные ОС. Много нюансов разных гипервизоров требую более квалифицированых инженеров, или болшее число узкоспециализированных, чтобы исключить самую страшную штуку - человеческий фактор!
> 
> По личным убеждениям стараюсь создавать гомогенную среду, максимально однотипную и стандартизированную, чтобы применять уже отработаные инструменты и использовать уже существующуюю документацию. Так как работая в аутсорсе есть проблемы с обучением инженеров и системных админстраторов.
> 