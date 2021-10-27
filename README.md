# devops-netology
#devops-netology
#Описние файла gitignore в каталоге terraform  своими словами

#  Игнорирование содержимого директорий terraform любой вложенности
**/.terraform/*

# файлы с расширением tfstate и все архивные версии.
*.tfstate
*.tfstate.*

# Файлы с именем crash.log
crash.log

# Файлы с расширением tfvars
*.tfvars

# игнорирование файлов по заданным именам + файлы по именам с окончанием на _override.tf(.json)
override.tf
override.tf.json
*_override.tf
*_override.tf.json

#игнорирование конфигураций коммандной строки тераформ?!
.terraformrc
terraform.rc

