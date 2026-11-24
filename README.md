# Ansible для macOS

> [!NOTE]
> **Происхождение кода.** Форк [TelegramMessenger/telegram-macos](https://github.com/TelegramMessenger/telegram-macos), который сопровождает проект Ansible Messenger. Сведения об авторах и лицензиях приведены в исходной документации.

<img src="Ansible-Mac/Assets.xcassets/AppIcon.appiconset/Logo_128.png" width="80" alt="Значок Ansible для macOS">

Нативное приложение мессенджера Ansible для Mac. Интерфейс написан на Swift и AppKit. Это независимый **форк Telegram для macOS**, который подключается к серверам Ansible и работает с учётной записью Ansible. [Исходный проект Telegram](https://github.com/TelegramMessenger/telegram-macos).

На Mac также доступен кроссплатформенный клиент на Qt. Его исходники находятся в отдельном репозитории. [Ansible Desktop](https://github.com/ansible-desktop/app-desktop).

## Сборка на Mac

Понадобятся Xcode с инструментами Metal, Homebrew и Rust. Список зависимостей и особенности разных версий Xcode описаны в [инструкции по сборке](INSTALL.md) и [заметках для Xcode 27](XCODE27.md).

```sh
git clone https://github.com/ansible-ios/as-macos.git
cd as-macos
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

[Сайт Ansible](https://ansible.su) · [Выпуски для macOS](https://github.com/ansible-ios/as-macos/releases)

## Происхождение модулей организации

| Модуль Ansible | Исходный проект |
| --- | --- |
| [as-libvoip](https://github.com/ansible-ios/as-libvoip) | [github.com/telegramdesktop/libtgvoip](https://github.com/telegramdesktop/libtgvoip) |
| [as-sparkle](https://github.com/ansible-ios/as-sparkle) | [github.com/macosswift/sparkle](https://github.com/macosswift/sparkle) |
| [as-ios-macos-deps](https://github.com/ansible-ios/as-ios-macos-deps) | [github.com/TelegramMessenger/Telegram-iOS](https://github.com/TelegramMessenger/Telegram-iOS) |
| [as-calls](https://github.com/ansible-ios/as-calls) | [github.com/ali-fareed/tgcalls](https://github.com/ali-fareed/tgcalls) |
| [as-owt](https://github.com/ansible-ios/as-owt) | [github.com/macosswift/tg_owt](https://github.com/macosswift/tg_owt) |
| [as-libprisma](https://github.com/ansible-ios/as-libprisma) | [github.com/TelegramMessenger/libprisma](https://github.com/TelegramMessenger/libprisma) |
| [as-regex](https://github.com/ansible-ios/as-regex) | [github.com/boostorg/regex](https://github.com/boostorg/regex) |
| [as-twidget](https://github.com/ansible-ios/as-twidget) | [github.com/TelegramMessenger/twidget](https://github.com/TelegramMessenger/twidget) |
| [as-tlottie](https://github.com/ansible-ios/as-tlottie) | [github.com/dkaraush/tlottie](https://github.com/dkaraush/tlottie) |
| [as-widget-sandbox](https://github.com/ansible-ios/as-widget-sandbox) | [github.com/TelegramMessenger/widget-sandbox](https://github.com/TelegramMessenger/widget-sandbox) |
