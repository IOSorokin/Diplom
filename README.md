# Дипломный практикум в Yandex.Cloud.

## Цели:
    Этапы выполнения:
     1.   Создание облачной инфраструктуры.
     2.   Создание Kubernetes кластера.
     3.  Создание тестового приложения
     4.   Подготовка cистемы мониторинга и деплой приложения
     5.   Установка и настройка CI/CD
    Что необходимо для сдачи задания?
    Как правильно задавать вопросы дипломному руководителю?

Перед началом работы над дипломным заданием изучите Инструкция по экономии облачных ресурсов.  https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD

## Цели:
   1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
   2. Запустить и сконфигурировать Kubernetes кластер.
   3. Установить и настроить систему мониторинга.
   4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
   5. Настроить CI для автоматической сборки и тестирования.
   6. Настроить CD для автоматического развёртывания приложения.

## Этапы выполнения:
### Создание облачной инфраструктуры
    Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи Terraform.

Особенности выполнения:

   * Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов; Для облачного k8s используйте региональный мастер(неотказоустойчивый). Для self-hosted k8s минимизируйте ресурсы ВМ и долю ЦПУ. В обоих вариантах используйте прерываемые ВМ для worker nodes.
   * Следует использовать версию Terraform не старше 1.5.x .

Предварительная подготовка к установке и запуску Kubernetes кластера.

   1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя
   2. Подготовьте backend для Terraform:
    а. Рекомендуемый вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)
    б. Альтернативный вариант: Terraform Cloud
   3. Создайте VPC с подсетями в разных зонах доступности.
   4. Убедитесь, что теперь вы можете выполнить команды terraform destroy и terraform apply без дополнительных ручных действий.
   5. В случае использования Terraform Cloud в качестве backend убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Ожидаемые результаты:

   1. Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
   2. Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

### Создание Kubernetes кластера

На этом этапе необходимо создать Kubernetes кластер на базе предварительно созданной инфраструктуры. Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

    1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.
    а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.
    б. Подготовить ansible конфигурации, можно воспользоваться, например Kubespray
    в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
    2. Альтернативный вариант: воспользуйтесь сервисом Yandex Managed Service for Kubernetes
    а. С помощью terraform resource для kubernetes создать региональный мастер kubernetes с размещением нод в разных 3 подсетях
    б. С помощью terraform resource для kubernetes node group

Ожидаемый результат:

    1. Работоспособный Kubernetes кластер.
    2. В файле ~/.kube/config находятся данные для доступа к кластеру.
    3. Команда kubectl get pods --all-namespaces отрабатывает без ошибок.

### Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:
    1. Рекомендуемый вариант:
    а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.
    б. Подготовьте Dockerfile для создания образа приложения.
    2. Альтернативный вариант:
    а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

    1. Git репозиторий с тестовым приложением и Dockerfile.
    2. Регистри с собранным docker image. В качестве регистри может быть DockerHub или Yandex Container Registry, созданный также с помощью terraform.

# Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:

    1. Задеплоить в кластер prometheus, grafana, alertmanager, экспортер основных метрик Kubernetes.
    2. Задеплоить тестовое приложение, например, nginx сервер отдающий статическую страницу.

Способ выполнения:

    1. Воспользовать пакетом kube-prometheus, который уже включает в себя Kubernetes оператор для grafana, prometheus, alertmanager и node_exporter. При желании можете собрать все эти приложения отдельно.
    2. Для организации конфигурации использовать qbec, основанный на jsonnet. Обратите внимание на имеющиеся функции для интеграции helm конфигов и helm charts
    3. Если на первом этапе вы не воспользовались Terraform Cloud, то задеплойте и настройте в кластере atlantis для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

Ожидаемый результат:

    1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
    2. Http доступ к web интерфейсу grafana.
    3. Дашборды в grafana отображающие состояние Kubernetes кластера.
    4. Http доступ к тестовому приложению.

### Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

    1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
    2. Автоматический деплой нового docker образа.

Можно использовать teamcity, jenkins, GitLab CI или GitHub Actions.

Ожидаемый результат:

    1. Интерфейс ci/cd сервиса доступен по http.
    2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
    3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes.

### Что необходимо для сдачи задания?

    1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля.
    2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud или вашего CI-CD-terraform pipeline.
    3. Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.
    4. Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.
    5. Репозиторий с конфигурацией Kubernetes кластера.
    6. Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.
    7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)

## Выполнение дипломного практикума:

Для выполнения работы, я буду использовать уже настроенную рабочую машину, со следующими компонентами:

     Terraform v1.5.7
     Ansible 2.16.2
     Python 3.10.12
     Docker 26.1.3
     Git 2.34.1
     Kubectl v1.30.2
     Helm v3.16.1
     Yandex Cloud CLI 0.130.0

![изображение](https://github.com/user-attachments/assets/16207aec-ffba-416e-8af2-b27bf9c9a39b)

## Создание облачной инфраструктуры

1. Создам сервисный аккаунт с необходимыми правами для работы с облачной инфраструктурой:

    # Создаем сервисный аккаунт для Terraform
    resource "yandex_iam_service_account" "service" {
      folder_id = var.folder_id
      name      = var.account_name
    }

    # Выдаем роль editor сервисному аккаунту Terraform
    resource "yandex_resourcemanager_folder_iam_member" "service_editor" {
      folder_id = var.folder_id
      role      = "editor"
      member    = "serviceAccount:${yandex_iam_service_account.service.id}"
    }

2. Подготавливаю backend для Terraform. Использовать буду S3-bucket:

    # Создаем статический ключ доступа для сервисного аккаунта
    resource "yandex_iam_service_account_static_access_key" "terraform_service_account_key" {
      service_account_id = yandex_iam_service_account.service.id
    }

    # Используем ключ доступа для создания бакета
    resource "yandex_storage_bucket" "tf-bucket" {
      bucket     = "forstate2024"
      access_key = yandex_iam_service_account_static_access_key.terraform_service_account_key.access_key
      secret_key = yandex_iam_service_account_static_access_key.terraform_service_account_key.secret_key

      anonymous_access_flags {
        read = false
        list = false
     }

     force_destroy = true

    provisioner "local-exec" {
     command = "echo export AWS_ACCESS_KEY=${yandex_iam_service_account_static_access_key.terraform_service_account_key.access_key} > ../terraform/backend.tfvars"
    }

    provisioner "local-exec" {
      command = "echo export AWS_SECRET_KEY=${yandex_iam_service_account_static_access_key.terraform_service_account_key.secret_key} >> ../terraform/backend.tfvars"
    }
    }

Применю код:

![изображение](https://github.com/user-attachments/assets/46967c21-a282-4a80-a78f-d2b1698fd7f2)


В результате применения этого кода Terraform был создан сервисный аккаунт с правами для редактирования, статический ключ доступа и S3-bucket. Переменные AWS_ACCESS_KEY и AWS_SECRET_KEY будут записаны в файл backend.tfvars. Сделано так потому, что эти данные являются очень чувствительными и не рекомендуется их хранить в облаке. Эти переменные будут в экспортированы в оболочку рабочего окружения.

Проверю, создался ли S3-bucket и сервисный аккаунт:

![изображение](https://github.com/user-attachments/assets/e6e8e80b-8b91-48bb-a65e-b5ea7712c5a9)

Сервисный аккаунт и S3-bucket созданы.


После создания S3-bucket, выполню настройку для его использования в качестве backend для Terraform. Для этого пишу следующий код:

        terraform {
          backend "s3" {
            endpoint = "storage.yandexcloud.net"
            bucket = "for-state"
            region = "ru-central1"
            key = "for-state/terraform.tfstate"
            skip_region_validation = true
            skip_credentials_validation = true
          }
        }

Этот код настраивает Terraform на использование Yandex Cloud Storage в качестве места для хранения файла состояния terraform.tfstate, который содержит информацию о конфигурации и состоянии управляемых Terraform ресурсов. Чтобы код был корректно применен и Terraform успешно инициализировался, задам параметры для доступа к S3 хранилищу. Как писал выше, делать это я буду с помощью переменных окружения:

![изображение](https://github.com/user-attachments/assets/18fe7690-3a9d-478b-aedd-879f565bd716)


3. Создаю VPC с подсетями в разных зонах доступности:

        resource "yandex_vpc_network" "diplom" {
          name = var.vpc_name
        }
        resource "yandex_vpc_subnet" "diplom-subnet1" {
          name           = var.subnet1
          zone           = var.zone1
          network_id     = yandex_vpc_network.diplom.id
          v4_cidr_blocks = var.cidr1
        }

        resource "yandex_vpc_subnet" "diplom-subnet2" {
          name           = var.subnet2
          zone           = var.zone2
          network_id     = yandex_vpc_network.diplom.id
          v4_cidr_blocks = var.cidr2
        }

        variable "zone1" {
          type        = string
          default     = "ru-central1-a"
          description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
        }
        
        variable "zone2" {
          type        = string
          default     = "ru-central1-b"
          description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
        }
        
        variable "cidr1" {
          type        = list(string)
          default     = ["10.0.10.0/24"]
          description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
        }
        
        variable "cidr2" {
          type        = list(string)
          default     = ["10.0.20.0/24"]
          description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
        }
        
        variable "vpc_name" {
          type        = string
          default     = "diplom"
          description = "VPC network&subnet name"
        }

        variable "bucket_name" {
          type        = string
          default     = "ft-state"
          description = "VPC network&subnet name"
        }

        variable "subnet1" {
          type        = string
          default     = "diplom-subnet1"
          description = "subnet name"
        }

        variable "subnet2" {
          type        = string
          default     = "diplom-subnet2"
          description = "subnet name"
        }

    Описываю код Terraform для создания виртуальных машин для Kubernetes кластера. Буду использовать одну Master ноду и две Worker ноды, для экономии ресурсов и бюджета купона.

Инициализирую Terraform:

![image](https://github.com/user-attachments/assets/577a0aa1-b5d1-4fab-987a-5adf6f677696)

![image](https://github.com/user-attachments/assets/8b0cde22-337e-4624-9218-1fabeba22435)


Видно, что Terraform успешно инициализирован, backend с типом s3 успешно настроен. Terraform будет использовать этот backend для хранения файла состояния terraform.tfstate.

Для проверки правильности кода, можно использовать команды terraform validate и terraform plan. В моём коде ошибок не обнаружено:

![image](https://github.com/user-attachments/assets/e79c3de3-4b81-41fc-9ae0-1775a7ed12c9)

Применю код для создания облачной инфраструктуры, состоящей из одной Master ноды, двух Worker нод, сети и подсети:

![image](https://github.com/user-attachments/assets/4301d16b-3658-45cf-a070-261709d04acd)

Кроме создания сети, подсетей и виртуальных машин, создается ресурс из файла ansible.tf, который по шаблону hosts.tftpl создает inventory файл. Этот inventory файл в дальнейшем будет использоваться для развёртывания Kubernetes кластера из репозитория Kubespray.

Также при развёртывании виртуальных машин буду использовать файл cloud-init.yml, который установит на них полезные в дальнейшем пакеты. Например, curl, Git, MC, atop и другие.

Код для создания Master ноды находится в файле master.tf

Код для создания Worker нод находится в файле worker.tf

Код для установки необходимых пакетов на виртуальные машины при их развертывании находится в файле cloud-init.yml

Проверю, создались ли виртуальные машины:

![image](https://github.com/user-attachments/assets/bf6e7419-cd9b-438e-b9a9-77904d45d050)

Виртуальные машины созданы в разных подсетях и разных зонах доступности.

Также проверю все созданные ресурсы через графический интерфейс:

    Сервисный аккаунт:

![image](https://github.com/user-attachments/assets/854ec5d1-ef28-4f87-a7fa-a2f820a278ce)

    S3-bucket:

![image](https://github.com/user-attachments/assets/9690ff62-02bb-48eb-98fd-dc978ab62242)


    Сеть и подсети:

![image](https://github.com/user-attachments/assets/e4e481d6-e691-4142-baf6-fd9e1db94cdc)

    Виртуальные машины:

![image](https://github.com/user-attachments/assets/e444b912-3eb4-4c19-a0f8-febdacd67905)


Проверю удаление созданных ресурсов:

![image](https://github.com/user-attachments/assets/68d239f1-c470-4451-8243-87e0876e223a)

![image](https://github.com/user-attachments/assets/983abd6a-0645-4f63-bc21-d6b9b037727a)



Созданные виртуальные машины, сеть, подсети, сервисный аккаунт, статический ключ и S3-bucket удаляются успешно.

Настрою автоматическое применение, удаление и обновление кода Terraform. Для этого воспользуюсь GitHub Actions. Пишу Workflow, который позволит запускать применение и удаление кода Terraform по условиям через события workflow_dispatch. При нажатии на кнопку Run workflow видим два условия, одно из них при введении true запустит создание инфраструктуры, другое при введении true запустит её удаление:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img007.png)

Также при git push кода Terraform в main ветку репозитория запустится автоматическое применение этого кода. Это необходимо для автоматического обновления облачной конфигурации при изменении каких либо ресурсов.

Скриншот работы Workflow при обновлении конфигурации облачной инфраструктуры:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img008.png)

Код Workflow доступен по ссылке: https://github.com/IOSorokin/Diplom/blob/main/.github/workflows/terraform-work.yml

Выполненные GitHub Actions доступны по ссылке: hhttps://github.com/IOSorokin/Diplom/actions

Полный код Terraform для создания сервисного аккаунта, статического ключа и S3-bucket доступен по ссылке:

https://github.com/IOSorokin/Diplom/tree/main/terraform-s3

Полный код Terraform для создания сети, подсетей, виртуальных машин доступен по ссылке:

https://github.com/IOSorokin/Diplom/tree/main/terraform

В ходе выполнения работы код может быть изменен и дополнен.

# Создание Kubernetes кластера

После развёртывания облачной инфраструктуры, приступаю к развёртыванию Kubernetes кластера.

Разворачивать буду из репозитория Kubespray.

Клонирую репозиторий на свою рабочую машину:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img009.png)

При разворачивании облачной инфраструктуры с помощью Terraform применяется следующий код:

    resource "local_file" "hosts_cfg_kubespray" {
      content  = templatefile("${path.module}/hosts.tftpl", {
        workers = yandex_compute_instance.worker
        masters = yandex_compute_instance.master
      })
      filename = "../../kubespray/inventory/mycluster/hosts.yaml"
    }

Этот код по пути /data/kubespray/inventory/mycluster/ создаст файл hosts.yaml и по шаблону автоматически заполнит его ip адресами нод.

Сам файл шаблона выглядит следующим образом:

all:
  hosts:%{ for idx, master in masters }
    master:
      ansible_host: ${master.network_interface[0].nat_ip_address}
      ip: ${master.network_interface[0].ip_address}
      access_ip: ${master.network_interface[0].nat_ip_address}%{ endfor }%{ for idx, worker in workers }
    worker-${idx + 1}:
      ansible_host: ${worker.network_interface[0].nat_ip_address}
      ip: ${worker.network_interface[0].ip_address}
      access_ip: ${worker.network_interface[0].nat_ip_address}%{ endfor }
  children:
    kube_control_plane:
      hosts:%{ for idx, master in masters }
        ${master.name}:%{ endfor }
    kube_node:
      hosts:%{ for idx, worker in workers }
        ${worker.name}:%{ endfor }
    etcd:
      hosts:%{ for idx, master in masters }
        ${master.name}:%{ endfor }
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}

Перейду в директорию /data/kubespray/ и запущу установку kubernetes кластера командой

ansible-playbook -i inventory/mycluster/hosts.yaml -u ubuntu --become --become-user=root --private-key=~/.ssh/id_ed25519 -e 'ansible_ssh_common_args="-o StrictHostKeyChecking=no"' cluster.yml --flush-cache

Спустя некоторое время установка Kubernetes кластера методом Kubespray завершена:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img010.png)

Далее нужно создать конфигурационный файл кластера Kubernetes.

Для этого подключаюсь к Master ноде и выполняем следующие команды:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img011.png)

Эти команды создадут директорию для хранения файла конфигурации, копируют созданный при установке Kubernetes кластера конфигурационный файл в созданную директорию. Так же назначаем права для пользователя на директорию и файл конфигурации.

Конфигурационный файл создан. Теперь можно проверить доступность подов и нод кластера:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img012.png)

Поды и ноды кластера доступны и находятся в состоянии готовности, следовательно развёртывание Kubernetes кластера успешно завершено.

# Создание тестового приложения

  Создаю отдельный репозиторий для тестового приложения:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img013.png)

Клонирую репозиторий на свою рабочую машину:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img014.png)

Создаю статичную страничку, которая будет показывать картинку и текст:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img016.png)

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img015.png)

Сделаю коммит и отправлю созданную страницу в репозиторий:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img017.png)

Ссылка на репозиторий: https://github.com/DemoniumBlack/diplom-test-site

    Пишу Dockerfile, который создаст контейнер с nginx и отобразит созданную страницу:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img018.png)

    FROM nginx:1.27.0
    RUN rm -rf /usr/share/nginx/html/*
    COPY content/ /usr/share/nginx/html/
    EXPOSE 80

Авторизуюсь в Docker Hub:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img019.png)

Создаю Docker образ:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img020.png)

Образ создался:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img021.png)

Образ создан.

Опубликую созданный образ реестре Docker Hub:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img022.png)

Проверю наличие образа в реестре Docker Hub:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img023.png)

Ссылка на реестр Docker Hub: https://hub.docker.com/repository/docker/iosorokin/diplom/general

Образ опубликован, подготовка тестового приложения закончена.
Подготовка системы мониторинга и деплой приложения

Добавлю репозиторий prometheus-community для его установки с помощью helm:

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img026.png)

Для доступа к Grafana снаружи кластера Kubernetes буду использовать тип сервиса NodePort.

Сохраню значения по умолчанию Helm чарта prometheus-community в файл и отредактирую его:

helm show values prometheus-community/kube-prometheus-stack > helm-prometheus/values.yaml

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img027.png)

Изменю пароль по умолчанию для входа в Grafana:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img028.png)

Изменю сервис и присвою ему порт 30050:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img029.png)

Используя Helm и подготовленный файл значений values.yaml выполню установку prometheus-community:

helm upgrade --install monitoring prometheus-community/kube-prometheus-stack --create-namespace -n monitoring -f helm-prometheus/values.yaml

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img030.png)

При установке был создан отдельный Namespace с названием monitoring.

Проверю вывод установки:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img031.png)

Установка была выполнена с заданными в values.yaml значениями.

Файл значений values.yaml, использованный при установке prometheus-community доступен по ссылке: https://github.com/DemoniumBlack/fedorchukds-devops-33-56/blob/main/helm-prometheus/values.yaml

Открою web-интерфейс Grafana:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img032.png)

Авторизуюсь в Grafana с заранее заданным в values.yaml паролем:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img033.png)

Авторизация проходит успешно, данные о состоянии кластера отображаются на дашбордах:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img034.png)

Развёртывание системы мониторинга успешно завершено.

Приступаю к развёртыванию тестового приложения на Kubernetes кластере.

Создаю отдельный Namespace, в котором разверну мое тестовое приложение:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img035.png)

Пишу манифест Deployment с тестовым приложением:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img036.png)

Применю манифест Deployment и проверю результат:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img037.png)

Deployment создан и запущен. 

Ссылка на манифест Deployment: https://github.com/DemoniumBlack/fedorchukds-devops-33-56/blob/main/k8s-app/deployment.yaml

Пишу манифест сервиса с типом NodePort для доступа к web-интерфейсу тестового приложения:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img038.png)

Применю манифест сервиса и проверю результат:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img039.png)

Сервис создан. Теперь проверю доступ к приложению извне:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img040.png)

Сайт открывается, приложение доступно.

Ссылка на манифест сервиса: https://github.com/DemoniumBlack/fedorchukds-devops-33-56/blob/main/k8s-app/service.yaml

# Развёртывание системы мониторинга и тестового приложения завершено.
Установка и настройка CI/CD

Для организации процессов CI/CD буду использовать GitLab.

Создаю в GitLab новый пустой проект с именем diplom-cicd.

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img041.png)

Отправлю созданную ранее статичную страницу и Dockerfile из старого репозитория GitHub в новый проект на GitLab:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img042.png)

Для автоматизации процесса CI/CD мне нужен GitLab Runner, который будет выполнять задачи, указанные в файле .gitlab-ci.yml.

На странице настроек проекта в разделе подключения GitLab Runner создаю Runner. Указанные на странице данные понадобятся для регистрации и аутентификации Runner'а в проекте.

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img043.png)

Выполню подготовку Kubernetes кластера к установке GitLab Runner'а. Создам отдельный Namespace, в котором будет располагаться GitLab Runner и создам Kubernetes secret, который будет использоваться для регистрации установленного в дальнейшем GitLab Runner:

kubectl create ns gitlab-runner

kubectl --namespace=gitlab-runner create secret generic runner-secret --from-literal=runner-registration-token="<token>" --from-literal=runner-token=""

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img044.png)

Также понадобится подготовить файл значений values.yaml, для того, чтобы указать в нем количество Runners, время проверки наличия новых задач, настройка логирования, набор правил для доступа к ресурсам Kubernetes, ограничения на ресурсы процессора и памяти.

Файл значений values.yaml, который будет использоваться при установке GitLab Runner доступен по ссылке: https://github.com/DemoniumBlack/fedorchukds-devops-33-56/blob/main/helm-runner/values.yaml

Приступаю к установке GitLab Runner. Устанавливать буду используя Helm:

helm repo add gitlab https://charts.gitlab.io

helm install gitlab-runner gitlab/gitlab-runner -n gitlab-runner -f helm-runner/values.yaml

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img045.png)

Проверю результат установки:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img046.png)

GitLab Runner установлен и запущен. Также можно через web-интерфейс проверить, подключился ли GitLab Runner к GitLab репозиторию:

![image](https://github.com/IOSorokin/Diplom/blob/main/images/img047.png)

Подключение GitLab Runner к репозиторию GitLab завершено.

Для выполнения GitLab CI/CD Pipeline мне понадобится в настройках созданного проекта в разделе Variables указать переменные:

img_62

В переменных указан адрес реестра Docker Hub, данные для авторизации в нем, а также имя собираемого образа и конфигурационный файл Kubernetes для доступа к развёрнутому выше кластеру. Для большей безопасности конфигурационный файл Kubernetes буду размещать в формате base64. Также часть переменных будет указана в самом файле .gitlab-ci.yml.

Пишу конфигурайионный файл .gitlab-ci.yml для автоматической сборки docker image и деплоя приложения при изменении кода.

Pipeline будет разделен на две стадии:

    На первой стадии (build) будет происходить авторизация в Docker Hub, сборка образа и его публикация в реестре Docker Hub. Сборка образа будет происходить только для main ветки и только в GitLab Runner с тегом diplom. Сам процесс сборки происходит следующим образом - если при git push указан тег, то Docker образ будет создан именно с этим тегом. Если при git push тэг не указывать, то Docker образ будет собран с тегом latest'. Поскольку мне не удалось запустить Docker-in-Dpcker в GitLab Rinner и я получал ошибку доступа к docker.socket, сборка будет происходить на основе контейнера gcr.io/kaniko-project/executor:v1.22.0-debug`.

    На второй стадии (deploy) будет применяться конфигурационный файл для доступа к кластеру Kubernetes и манифесты из git репозитория. Также будет перезапущен Deployment методом rollout restart для применения обновленного приложение. Такой метод обновления может быть полезен, например, если нужно обновить Frontend часть приложения незаметно для пользователя этого приложения. Эта стадия выполняться только для ветки main и на GitLab Runner с тегом diplom и только при условии, что первая стадия build была выполнена успешно.

Проверю работу Pipeline. Исходная страница приложения:

img_63

Внесу в репозиторий изменения и отправлю из в Git с указанием тега:

img_64

Проверю, с каким тегом создался образ в Docker Hub:

img_65

Образ создался с тегом v0.2.

Проверю, обновилась ли страница приложения:

img_66

Страница приложения также обновилась.

Теперь проверю создание образа с тегом latest при отсутствии тега при git push:

img_67

Проверю, с каким тегом создался образ в Docker Hub:

img_68

Образ создался с тегом latest.

Также обновилась страница приложения:

img_69

Ссылка на выполненные Pipelines: https://gitlab.com/DemoniumBlack/diplom-test-site/-/pipelines
Итоги выполненной работы:

    Репозиторий с конфигурационными файлами Terraform:

https://github.com/DemoniumBlack/fedorchukds-devops-33-56/blob/main/terraform-s3/

https://github.com/DemoniumBlack/fedorchukds-devops-33-56/blob/main/terraform/

    CI-CD-terraform pipeline:

https://github.com/DemoniumBlack/fedorchukds-devops-33-56/blob/main/.github/workflows/terraform-cloud.yml

    Репозиторий с конфигурацией ansible:

Был использован обычный репозиторий Kubespray - https://github.com/kubernetes-sigs/kubespray

    Репозиторий с Dockerfile тестового приложения:

https://gitlab.com/DemoniumBlack/diplom-test-site

    Ссылка на собранный Docker Image:

https://hub.docker.com/repository/docker/demonium1988/diplom-test-site/tags

    Ссылка на тестовое приложение:

http://158.160.171.65/

    Ссылка на web-интерфейс Grafana с данными доступа:

http://158.160.175.47:3000/login

login: admin

password: AdminSuperPass
