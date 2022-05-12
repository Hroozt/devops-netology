# Домашнее задание к занятию "6.1. Типы и структура СУБД"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Архитектор ПО решил проконсультироваться у вас, какой тип БД 
лучше выбрать для хранения определенных данных.

Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:

- Электронные чеки в json виде
```БД с типом КЛЮЧ-ЗНАЧЕНИЕ. Формат записи и логика соответствует JSON ```
- Склады и автомобильные дороги для логистической компании
```Здесь могут быть полезны графовые БД. Для выстраивания оптимальых маршрутов по весу ребра графа например ио по количеству промежуточных связей...```
- Генеалогические деревья
```Отлично подойдут Иерархические модели БД. По своей структуре.```
- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации
```Redis? Хранит данные в оперативной памяти, что достаточно быстро будет выдавать данные. На то он и Кэш.```
- Отношения клиент-покупка для интернет-магазина
```считаю что подойдет Реляционная модель. Так как данных о покупке может быть большое колличество. Также должна храниться информация и о самом клиенте. И это все должно быть связано.```
Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.

## Задача 2

Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно 
CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если 
(каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):

- Данные записываются на все узлы с задержкой до часа (асинхронная запись)

``` PA/EL - данные согласуются на всех узлах с задержкой в час, что исключает (C)Консистентность. Но доступны все узлы в любой момент (PA) и скорее всего при асинхронной записи будет высокодоступная и быстрая система (EL). А может и нет, если приоритет будет отдан не скорости, а какой-либо консистентности то возможно и (EL)```

``` AP - Скорее всего так. Запись идет на одну доступную ноду, при этом на все остальные ноды СУБД синхронизирует данные потом. Вывод такой - что ответы с разных нод могут быть разными, что не притендует на (C) Консистентность. Но зато гарантирует Высокую доступность и скорость чтения\записи в отсутствии блокировок```

-При сетевых сбоях, система может разделиться на 2 раздельных кластера

```PA/EC - Может разделиться и продолжать работать, устойчива к разделению и при этом доступность выше консистентности. При штатном режиме работы допустим что приоритет отдан консистентности (EC).```

``` AP - Так как разделение на 2 кластера не гарантирует (С)Конситентность. Но доступность и устойчивость к разделению должны быть гарантированы```

- Система может не прислать корректный ответ или сбросить соединение

```PC/EC - Доступность и скорость - жертва косистентности и устойчивости к разделению.```

``` СP - Ответ система не присылает пока не удостоверится в соблюдении (C) Консистентности данных. Из-за чего могу возникать блокировки доступа пока не пройдет полная процедура записи данных на все ноды (P) из за чего в жертву приносят (A) доступноссть ```

- А согласно PACELC-теореме, как бы вы классифицировали данные реализации?

## Задача 3

Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?

```
Кажется это фантастика. Если своими словами как понял:
BASE - Быстро и всегда, неважно что
ACID - Очень важно что, а вот когда и вообще получешь ли, не важно.
Эти принципы не совместимы.
```

## Задача 4

Вам дали задачу написать системное решение, основой которого бы послужили:

- фиксация некоторых значений с временем жизни
- реакция на истечение таймаута

```redis - возможно пойдойдет```

Вы слышали о key-value хранилище, которое имеет механизм [Pub/Sub](https://habr.com/ru/post/278237/). 
Что это за система? Какие минусы выбора данной системы?

```Ну если посмотреть со стороны Сетевого инженера, это как TCP и UDP. PubSub как UDP - быстро много, но не факт что доставил =)```

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

