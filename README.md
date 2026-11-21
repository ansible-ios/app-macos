# Ansible для macOS

<img src="Ansible-Mac/Assets.xcassets/AppIcon.appiconset/Logo_128.png" width="80" alt="Значок Ansible для macOS">

Нативное приложение мессенджера Ansible для Mac. Интерфейс написан на Swift и AppKit. Это независимый **форк Telegram для macOS**, который подключается к серверам Ansible и работает с учётной записью Ansible. [Исходный проект Telegram](https://github.com/TelegramMessenger/telegram-macos).

На Mac также доступен кроссплатформенный клиент на Qt. Его исходники находятся в отдельном репозитории. [Ansible Desktop](https://github.com/ansible-desktop/app-desktop).

## Сборка на Mac

Понадобятся Xcode с инструментами Metal, Homebrew и Rust. Список зависимостей и особенности разных версий Xcode описаны в [инструкции по сборке](INSTALL.md) и [заметках для Xcode 27](XCODE27.md).

```sh
git clone https://github.com/ansible-ios/app-macos.git
cd app-macos
git -c url.https://github.com/.insteadOf=git@github.com: submodule update --init --recursive
cp configurations/Ansible.local.example.xcconfig configurations/Ansible.local.xcconfig
```

Укажите `ANSIBLE_API_ID` и `ANSIBLE_API_HASH` своего приложения Ansible в локальном файле конфигурации. Затем соберите и запустите отладочную версию:

```sh
bash scripts/build-ansible.sh --run
```

Скрипт подготавливает зависимости и создаёт `.build/Ansible/Build/Products/Debug/Ansible.app`. Для проверки расширения «Поделиться» нужна подписанная сборка с настроенной App Group.

## Лицензия и авторство

Клиент распространяется по GNU GPL версии 2. Исходный код Telegram для macOS и сторонние библиотеки сохраняют уведомления об авторах. Ansible развивается отдельно от Telegram. [Лицензия](LICENSE) · [Сведения об авторах](NOTICE) · [Правила участия](CONTRIBUTING.md).

[Сайт Ansible](https://ansible.su) · [Выпуски для macOS](https://github.com/ansible-ios/app-macos/releases)
