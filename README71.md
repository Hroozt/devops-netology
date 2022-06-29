# Домашнее задание к занятию "7.1. Инфраструктура как код"

## Задача 1. Выбор инструментов. 
 
### Легенда
 
Через час совещание на котором менеджер расскажет о новом проекте. Начать работу над которым надо 
будет уже сегодня. 
На данный момент известно, что это будет сервис, который ваша компания будет предоставлять внешним заказчикам.
Первое время, скорее всего, будет один внешний клиент, со временем внешних клиентов станет больше.

Так же по разговорам в компании есть вероятность, что техническое задание еще не четкое, что приведет к большому
количеству небольших релизов, тестирований интеграций, откатов, доработок, то есть скучно не будет.  
   
Вам, как девопс инженеру, будет необходимо принять решение об инструментах для организации инфраструктуры.
На данный момент в вашей компании уже используются следующие инструменты: 
- остатки Сloud Formation, 
- некоторые образы сделаны при помощи Packer,
- год назад начали активно использовать Terraform, 
- разработчики привыкли использовать Docker, 
- уже есть большая база Kubernetes конфигураций, 
- для автоматизации процессов используется Teamcity, 
- также есть совсем немного Ansible скриптов, 
- и ряд bash скриптов для упрощения рутинных задач.  

Для этого в рамках совещания надо будет выяснить подробности о проекте, что бы в итоге определиться с инструментами:

1. Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или не изменяемый?
1. Будет ли центральный сервер для управления инфраструктурой?
1. Будут ли агенты на серверах?
1. Будут ли использованы средства для управления конфигурацией или инициализации ресурсов? 
 
В связи с тем, что проект стартует уже сегодня, в рамках совещания надо будет определиться со всеми этими вопросами.

```
1. Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или не изменяемый?
    Изменяемый тип. Так как этот сервис планирется предоставлять другим клиентам, с адаптацией.
    Так как принцип IaC подразумевает хорошую документированность и "Идемпотентность" то правки будут быстрыми.
1. Будет ли центральный сервер для управления инфраструктурой?
    Мне кажется, Можно использовать центральный сервер, если это будет действительно маштабный проект в рамках одного заказчика.
    Если же это будет небольшой сервис, но будет расправстранять по большому колличеству заказчиков, то не уверен что централизация это хорошо, можно сломать всем сразу и правки будут нужны не всем.
       
1. Будут ли агенты на серверах?
    Вопрос религии скорее всего. ТАк как комманда активно работает с тераформом и начала использовать Ansible, то возможно обойтись без агентов.
    Но в случае с централизованной системой управления - без агентов не обойтись.
1. Будут ли использованы средства для управления конфигурацией или инициализации ресурсов? 
    Да, так как система будет продвергаться постоянным изменениям, потребуется управление конфигурацие и ресурсов.

```

### В результате задачи необходимо

1. Ответить на четыре вопроса представленных в разделе "Легенда". 
1. Какие инструменты из уже используемых вы хотели бы использовать для нового проекта? 
1. Хотите ли рассмотреть возможность внедрения новых инструментов для этого проекта? 

Если для ответа на эти вопросы недостаточно информации, то напишите какие моменты уточните на совещании.


## Задача 2. Установка терраформ. 

Официальный сайт: https://www.terraform.io/

Установите терраформ при помощи менеджера пакетов используемого в вашей операционной системе.
В виде результата этой задачи приложите вывод команды `terraform --version`.


![image](https://user-images.githubusercontent.com/92970717/175947783-dad13291-3734-417c-b3d6-87c3faada2c7.png)



## Задача 3. Поддержка легаси кода. 

В какой-то момент вы обновили терраформ до новой версии, например с 0.12 до 0.13. 
А код одного из проектов настолько устарел, что не может работать с версией 0.13. 
В связи с этим необходимо сделать так, чтобы вы могли одновременно использовать последнюю версию терраформа установленную при помощи
штатного менеджера пакетов и устаревшую версию 0.12. 

В виде результата этой задачи приложите вывод `--version` двух версий терраформа доступных на вашем компьютере 
или виртуальной машине.

---


**Был скачен еще один файл**
![image](https://user-images.githubusercontent.com/92970717/175953944-527065e8-2fd4-48ae-90fd-5a297e635ce2.png)


### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---