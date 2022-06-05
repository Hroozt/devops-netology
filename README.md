# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.
```commandline
FROM centos:7
#

RUN yum -y install wget \
    && mkdir ES \
    && cd ES \
    && wget -o /dev/null https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.3-linux-x86_64.tar.gz \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.3-linux-x86_64.tar.gz.sha512 \
    && tar -xf elasticsearch-7.17.3-linux-x86_64.tar.gz

ADD elasticsearch.yml /ES/elasticsearch-7.17.3/config/
ENV ES_JAVA_HOME=/ES/elasticsearch-7.17.3/jdk/
ENV ES_HOME=/ES/elasticsearch-7.17.3

RUN groupadd elasticsearch \
    && useradd -g elasticsearch elasticsearch \
    && mkdir /var/lib/logs \
    && chown elasticsearch:elasticsearch /var/lib/logs \
    && mkdir /var/lib/data \
    && chown elasticsearch:elasticsearch /var/lib/data \
    && chown -R elasticsearch:elasticsearch /ES/elasticsearch-7.17.3 \
    && mkdir /ES/elasticsearch-7.17.3/snapshots \
    && chown elasticsearch:elasticsearch /ES/elasticsearch-7.17.3/snapshots

EXPOSE 9200
EXPOSE 9300
USER elasticsearch
#CMD ["/usr/sbin/init"]
CMD ["/ES/elasticsearch-7.17.3/bin/elasticsearch"]

```
**ссыль**
https://hub.docker.com/layers/elk/hroozt/elk/1.7/images/sha256-932384353863b18015ef8d9b29168d7038ab383796f68b53d2d3b89727d683f3?context=explore

```commandline
[root@localhost hroozt]# curl http://172.17.0.2:9200
{
  "name" : "35dffaeb5080",
  "cluster_name" : "netology_test",
  "cluster_uuid" : "VLqssCzDQlWm5vr-xuZO5Q",
  "version" : {
    "number" : "7.17.3",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "5ad023604c8d7416c9eb6c0eadb62b14e766caff",
    "build_date" : "2022-04-19T08:11:19.070913226Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}

```


## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

**файлик для создания индексов**
```commandline
[hroozt@localhost hw65]$ cat addindex
curl -X PUT "172.17.0.2:9200/ind1?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 1,
      "number_of_replicas": 0
    }
  }
}
'
curl -X PUT "172.17.0.2:9200/ind2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 2,
      "number_of_replicas": 1
    }
  }
}
'
curl -X PUT "172.17.0.2:9200/ind3?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 4,
      "number_of_replicas": 2
    }
  }
}

```
**результат выполнения**
```commandline
[hroozt@localhost hw65]$ ./addindex
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind1"
}
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind2"
}
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind3"
}
[hroozt@localhost hw65]$ curl -X GET '172.17.0.2:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases WSadEmHpTxqI1bF0hoIAAw   1   0         40            0     38.2mb         38.2mb
yellow open   ind2             6bs8bbb1S5iuaxn7Q_wSAA   2   1          0            0       415b           415b
green  open   ind1             kgvW6CrfSI2E0-2tgDX74Q   1   0          0            0       226b           226b
yellow open   ind3             v7I3TK2dTbWF0AGKY1T-qg   4   2          0            0       226b           226b

```
**состояние кластера**
```commandline
$ curl -X GET '172.17.0.2:9200/_cluster/health?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
```
**Статус "желтый" так как в индексах есть неназначеные шарды. Так же у нас псевдокластер из 1 ноды и негде размещать реплики. правда 1 индекс подразумевает работу с 1 нодой и у него все хорошо, он зеленый =)**
```commandline
curl -X DELETE '172.17.0.2:9200/_all'
{"acknowledged":true}
curl -X GET '172.17.0.2:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases WSadEmHpTxqI1bF0hoIAAw   1   0         40            0     38.2mb         38.2mb
```
## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

```commandline
[hroozt@localhost hw65]$ cat elasticsearch.yml
cluster.name: netology_test
discovery.type: single-node
path.data: /var/lib/data
path.logs: /var/lib/logs
path.repo: /ES/elasticsearch-7.17.3/snapshots
network.host: 0.0.0.0
discovery.seed_hosts: ["127.0.0.1", "[::1]"]
[hroozt@localhost hw65]$ curl -X POST 172.17.0.2:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/ES/elasticsearch-7.17.3/snapshots" }}'
{
  "acknowledged" : true
}

```
**подправим файлик для создания индекса, для создания теста**
```commandline
[hroozt@localhost hw65]$ ./addindex
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}
[hroozt@localhost hw65]$ curl -X GET '172.17.0.2:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases WSadEmHpTxqI1bF0hoIAAw   1   0         40            0     38.2mb         38.2mb
green  open   test             YqThkIb4RjeHeYpF6kuY-w   1   0          0            0       226b           226b
[hroozt@localhost hw65]$
```
**создаем ручной снапшот**
```commandline
[hroozt@localhost hw65]$ curl -X PUT "172.17.0.2:9200/_snapshot/netology_backup/my_snapshot?wait_for_completion=true&pretty"
{
  "snapshot" : {
    "snapshot" : "my_snapshot",
    "uuid" : "U1fMwy6ERdahgzBFwfAl2w",
    "repository" : "netology_backup",
    "version_id" : 7170399,
    "version" : "7.17.3",
    "indices" : [
      ".geoip_databases",
      ".ds-ilm-history-5-2022.06.03-000001",
      ".ds-.logs-deprecation.elasticsearch-default-2022.06.03-000001",
      "test"
    ],
    "data_streams" : [
      "ilm-history-5",
      ".logs-deprecation.elasticsearch-default"
    ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2022-06-05T17:27:56.476Z",
    "start_time_in_millis" : 1654450076476,
    "end_time" : "2022-06-05T17:27:57.877Z",
    "end_time_in_millis" : 1654450077877,
    "duration_in_millis" : 1401,
    "failures" : [ ],
    "shards" : {
      "total" : 4,
      "failed" : 0,
      "successful" : 4
    },
    "feature_states" : [
      {
        "feature_name" : "geoip",
        "indices" : [
          ".geoip_databases"
        ]
      }
    ]
  }
}
[hroozt@localhost hw65]$
```
**список снапшотов**
```
[hroozt@localhost hw65]$ sudo docker exec hardcore_bartik ls /ES/elasticsearch-7.17.3/snapshots
index-0
index.latest
indices
meta-U1fMwy6ERdahgzBFwfAl2w.dat
snap-U1fMwy6ERdahgzBFwfAl2w.dat
[hroozt@localhost hw65]$
```
**delete&restore**
```commandline
[hroozt@localhost hw65]$ curl -X DELETE "172.17.0.2:9200/test?pretty"
{
  "acknowledged" : true
}
[hroozt@localhost hw65]$ curl -X POST "172.17.0.2:9200/_snapshot/netology_backup/my_snapshot/_restore?pretty" -H 'Content-Type: application/json' -d'
{
  "indices": "test"
}
'
{
  "accepted" : true
}
[hroozt@localhost hw65]$ curl -X GET "172.17.0.2:9200/_cat/indices?v"
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases WSadEmHpTxqI1bF0hoIAAw   1   0         40            5     38.2mb         38.2mb
green  open   test             cLIayD6tSfKojHiiqc6VdA   1   0          0            0       226b           226b
[hroozt@localhost hw65]$


```