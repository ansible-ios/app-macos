# Ansible macOS — память для продолжения

Обновлено 16.11.2026, Europe/Moscow. Это handoff работы из чата владельца. Проверки runtime и сборки ниже выполнены 15.11.2026; их нельзя выдавать за свежую проверку на новом компьютере.

## Где остановились — прочитать первым

Код первого этапа ребрендинга собран и отправлен в master. Переводы уже выкачены через TeamCity и применены. **Визуальная приёмка восьми указанных владельцем экранов НЕ завершена.** Сначала продолжить её, а не начинать новый параллельный ребрендинг.

Последняя остановка: Mac заблокирован. CUA также возвращал `AXError.failure` на строках списков, хотя стандартные меню, кнопка подтверждения и фокус поиска работали. Владелец разрешил самостоятельно управлять приложением и делать скриншоты. Был запрошен unlock и открытие окна «Алмазная реакция». Результат после unlock ещё не наблюдался.

Во время проверки системного предложения языка нажали OK с выбранным English. **Вернуть интерфейс на Russian**, затем проверить en/ru. После новой ad-hoc сборки может появиться запрос Связки ключей: владелец подтверждает его сам; не извлекать пароль и не обходить защиту. Пустое окно при одном из запусков было подтверждено стеком `SecItemCopyMatching` в `PasscodeKeychain.rawRead`, а не ошибкой переводов. После подтверждения доступа интерфейс загрузился.

## Репозитории и изменения

- Этот репозиторий: `https://github.com/ansible-ios/app-macos`, native macOS fork `TelegramMessenger/telegram-macos` (Swift/AppKit), не Qt Telegram Desktop и не сборка iOS через Catalyst.
- На Mac checkout: `/Users/qwe/Documents/ansible/ansible-ios/app-macos`.
- Последние коммиты реализации: `053e16c5` (ребрендинг/совместимые переводы), `441d443a` (проверки кадров/документация). Более ранний `28f988e7` — исходная установка утверждённых PNG, он НЕ завершал весь ребрендинг.
- `as-translations-api`: отдельный репозиторий `https://github.com/ansible-app/as-translations-api`, локально `/Users/qwe/Documents/ansible/ansible-app/as-translations-api`. Выпущенные изменения: `da1bcdd`, `0137f40`, `a84640a`.
- Web reference: `/Users/qwe/Documents/ansible/ansible-web/Ansible-web`.
- Mobile iOS reference: `/Users/qwe/Documents/ansible/ansible-ios/app-ios`.
- `ansible-desktop` — отдельный Qt клиент. Каталоги `app-macos-gpt` в старых `_tmp/media` — черновые медиа/прототипы; актуальный исходник и applied manifest находятся здесь.
- README должен сохранять происхождение от Telegram и лицензионную атрибуцию. Удаление GitHub fork badge раньше не означало удаления атрибуции из README.

На момент handoff в macOS checkout оставались чужие/предшествующие изменения: ` m submodules/telegram-ios` и `?? .vscode/`. Они не включены в наши коммиты. Не сбрасывать, не добавлять gitlink и не удалять их. Перед продолжением снова проверить status, stash и worktrees.

## Решения владельца

- Сохранить текущий **тёмный логотип приложения**. Не возвращать предыдущую светлую рамку и не придумывать новый Dock icon.
- Сохранить точный предоставленный голубой алмаз. Мастер: `branding/masters/diamond-original.webp`, SHA-256 `fe7a413dd32bc80c39822fd4a08504bce96857140b4d7f96a213ba3f4d4a5068`.
- Цветной прозрачный алмаз — для сумм, монохромный template — для меню, квадратная скруглённая плитка — для настроек. Общий стиль native клиента, а не случайные emoji.
- Не рисовать свою анимацию: брать готовый `Diamond.ass` из Web. Начатая трассировка отменена, экспериментальные SVG не входят в реализацию.
- Подарки брать из мобильного iOS, с кристаллами.
- Название платформы: **Crystal Piece**, URL `https://crystalpiece.su`; не Fragment. Протокол приложения `as://`, не `ansible://`. Не переименовывать wire constructors или XTR ради текста UI.
- Старые клиенты должны продолжать работать. Не менять смысл платежей, суммы, auth или слой протокола в задаче ребрендинга. Покупки/реакции не отправлять ради скриншота: проверять предпросмотр без транзакции.

## Что реализовано в клиенте

1. Экспорт 46 PNG из утверждённых мастеров по `branding/asset-manifest.json`. Экспортёр `scripts/branding/export.swift`, запуск из корня: `swift scripts/branding/export.swift`.
2. Цветной/монохромный алмаз, синяя settings tile, роли giveaway/affiliate/refund/inline и знака Ansible. Слоты `preserved-app` пропускаются; тёмная app icon сравнена с baseline `28f988e7`, изменений нет.
3. Обнаружен и исправлен белый квадрат Premium: `generatePremiumIcon` сам рисует подложку; входной PNG теперь прозрачная маска алмаза, без второй плитки. Полный UI результат после этой правки ещё проверить.
4. `DiamondAppearance` в `packages/TelegramUtils/Sources/TelegramUtils/AppConstants.swift`: общие синие foreground/gradient/particle. Применено в ценах подарков, реакциях, радиальном свечении меню и emitters.
5. `CurrencyConstants.swift`: XTR UI icon теперь `Icon_Menu_Star` (слот содержит алмаз). В `Star_ReactionsController.swift` знак у лидеров также заменён на алмаз; кнопка отправки использует общую валютную иконку.
6. `DiamondCurrencySceneView.swift`: currency hero использует готовый Lottie из Web вместо отдельной Metal модели, onceEnd, максимум 30 FPS. Это не замена всех Premium/TON сцен.
7. `FragmentUsernameController.swift`: в collectible-info старый символ TON заменён готовым цветным алмазом.
8. 36 aliases в `branding/localization-aliases.json` и `packages/Localization/Sources/Localization/AnsibleLocalizationKeys.swift`; lookup в `LocalizableExtension.swift` сначала ищет alias, сохраняет original fallback. Они разделяют legacy string/plural collisions и новые Crystal Piece тексты.
9. Native fallback `Ansible-Mac/en.lproj/Localizable.strings` остаётся UTF-16. Исправлены recovery/support URLs и рекламная справка: без скопированных обещаний про сотни миллионов пользователей.

### Точные анимации, без самостоятельного перерисовывания

`branding/animation-manifest.json` содержит пути, роли, размеры, кадры, SHA-256 семи файлов:

- `star_currency_new.tgs`, `star_currency_part_new.tgs`, `star_currency_mono.tgs`: точный Web `src/assets/ass/Diamond.ass`; мастер сохранён в `branding/masters/diamond-web.ass`.
- `premium_reactions/premium_reaction_6.tgs`: Web `src/assets/ass/diamonds/DiamondReaction.ass`.
- `premium_gift_3.tgs`, `premium_gift_6.tgs`, `premium_gift_12.tgs`: серверный `messages.getStickerSet(inputStickerSetPremiumGifts)` — тот же источник, который mobile iOS читает в `IosappUI/Sources/AccountContext.swift`. Получены тестовой сессией. В наборе на момент проверки были эти три срока, не пять.

Расширение bundle `.tgs` сохранено для текущих callers; данные — тот же gzip/Lottie, что `.ass`. Ресурсы не конвертировались художественно. Проверены кадры реакции 0/30/124 и currency 179: на всех алмаз, последний кадр не пустой. Native TLottie отрисовал подарки с кристаллами. Публичные contact sheets в `branding/previews/`; это **не скриншоты всех экранов приложения**.

## Восемь экранов, которые надо принять визуально

Владелец прислал восемь примеров, расширив первоначальную замену статических иконок:

| № | Проверить в новой сборке |
|---|---|
| 1 | Информация о коллекционном username: Crystal Piece в тексте и правильный знак вместо TON |
| 2 | Настройки username бота: ссылка/описание платформы Crystal Piece |
| 3 | Монетизация: кнопка вывода через Crystal Piece; не нажимать финальный вывод |
| 4 | Каталог подарков: синие прозрачные ценовые капсулы, синие частицы и «или 2500/1500/1000» у всех трёх Premium вариантов |
| 5 | Подарок Premium в сообщении/предпросмотре: кристалл вместо звезды, 3/6/12 месяцев |
| 6 | Платная реакция под сообщением: алмаз, синяя капсула и частицы |
| 7 | Панель выбора реакции: алмаз вместо золотой звезды, синее свечение/частицы |
| 8 | Окно «Алмазная реакция»: badge/slider/«Лидеры» синие, знак у лидера и в нижней кнопке — алмаз, правильная анимация |

Также переснять настройки: «Мои алмазы», Premium mask после исправления; баланс с Web hero. Снять dark/light, проверить читаемость небольших значков. Не публиковать личные сообщения, контакты и балансы в Git: обрезать или скрывать их. Временные скриншоты со старого Mac не переносились в репозиторий.

## Переводы: что уже на сервере

Для native macOS нужен **свой lang_pack `macos`**, его нельзя подменить iOS или Qt pack. Это задано `ApiEnvironment.language` и передаётся shared network. Native English содержит 9448 keys/forms; остальные `.lproj` в основном placeholders, cloud переводы важны.

В `as-translations-api`:

- Новый `bht_additions.erl` — trusted operator importer `preview/1`, `run/1`, `load/1`. Проверяет manifest/hash/count, platform/language scope и тип string/plural; транзакция, advisory lock, таймаут, `ON CONFLICT DO NOTHING`.
- Пакет `priv/additions/macos-20261115`: 1632 en + 1464 ru строки/формы. Preview rollback, apply добавил 3096, sequence 97. Повтор дал 0.
- Пакет `priv/additions/macos-brand-20261115`: 23 en + 23 ru Crystal Piece presentation aliases. Apply добавил 46, sequence 98. Повтор дал 0.
- Подготовка: `scripts/prepare_macos_additions.py`; брендовый пакет использует `--only-prefix Ansible.MacOS.Brand.`. Проверены позиции/типы printf, неоднозначные plural формы и ручные RU значения.
- Не запускать старый full seed / `update_seed.py` для такого дополнения: sparse input может удалить другие строки. Существующие approved/base/custom/tombstones не перезаписываются новым importer.

### Выпуск и фактическая проверка

- TeamCity config `Ansible_TranslationsApi`, цепочка build/deploy. Выпуск 4134: translations `0137f40`, tools `4248f70d59c24ac3f88c42e3e49f0a8eb141f0ba`, build child 4132, image `sha256:c72ad598c27b20d62e65a5059003935a51320c3c140dd45067903276446cbe52`.
- Выпуск [4156](https://ts.ansible.su/build/4156): translations `a84640a`, тот же tools revision; build child 4154 / deploy 4155; image `sha256:17e031f1d09bbfbaeeb61469a7deb0a0085d0d4787a1b3ccde0431dd199db2fe`.
- Последнее наблюдение: `bh-translations-api`, namespace `ansible-frontend`, generation/observed 18, ready 1/1, restartCount 0, imageID соответствует последнему digest. Это датированное наблюдение, повторно проверить при следующем выпуске.
- Через тестовую сессию сравнены full packs до/после: все прежние **8162 en** и **8329 ru** keys с их значениями/формами сохранены. После обоих пакетов: 9799 en и 9798 ru wire keys. Строки/формы и wire keys — разные единицы подсчёта.
- Full pack/difference от исходных версий сходятся. Wire version — content hash: уменьшение численного значения допустимо, не менять backend на монотонный счётчик ради этого.
- Старые слои **224 и 226** получили тот же корректный пакет. Остальные 23 macOS языка и проверенный iOS en пакет не изменились. Это не полный регресс всех старых приложений.
- До финального выпуска два слишком тяжёлых read-only Erlang eval запроса вызвали OOM restart старой реплики translations. Больше не выбирать весь набор переводов в Erlang и не делать попарный обход. Диагностика заменена ограниченным SQL с rollback; финальная реплика после выпуска была стабильна.

## Сборка и перенос на другой компьютер

На старом Mac: Xcode 27.1/SDK 27, Apple Silicon; итоговый executable ARM64, ad-hoc `codesign --verify --deep --strict` прошёл. Rosetta установлена с разрешения владельца для Intel build-time генератора `tde2e`; это не означает, что само приложение Intel.

На новом Mac сначала изучить README/build scripts и текущие prerequisites. API credentials находятся в игнорируемом `configurations/Ansible.local.xcconfig`, образец `Ansible.local.example.xcconfig`. Они **не находятся в Git**. Использовать безопасный перенос/настройку, не искать секреты в логах и не печатать их.

Обычная команда после настройки окружения:

```sh
bash scripts/build-ansible.sh
```

Скрипт применяет parent-managed Telegram-iOS patches, Xcode 27 compatibility, frameworks, собирает с 2 jobs и ad-hoc подписывает. Для запуска есть `--run`, но не прерывать активную работу владельца без учёта черновиков/медиа. После сборки перед коммитом: `bash scripts/xcode27.sh revert`, затем внимательно проверить status; временные Xcode project modifications не являются частью ребрендинга.

App на старом Mac: `.build/Ansible/Build/Products/Debug/Ansible.app`, bundle ID `com.ansible.macos`. На другом компьютере нужно пересобрать; `.build` не переносится Git.

Старый Mac дополнительно использовал Rust из `ansible-desktop/ThirdParty/rust`, `RUSTUP_HOME`/`CARGO_HOME` там же, Homebrew в `/opt/homebrew/bin`; эти абсолютные пути не предполагать на новом компьютере. Build script задаёт `CMAKE_POLICY_VERSION_MINIMUM=3.5`, `CARGO_PROFILE_RELEASE_STRIP=none`.

Полезные локальные доказательства **только на старом Mac**, не зависеть от них для продолжения:

- `/Users/qwe/Documents/ansible/_tmp/macos-rebrand-20261115/`: reference snapshots 25 macOS языков AS/TG, manifest/hash audit, `verify_translation_release.py`, `release/before`, `dryrun`, `after`, `after-brand`, полученные публичные подарки.
- `/private/tmp/ansible-rebrand-phase1-final-verified.log`: последний build log. Ещё были `ansible-rebrand-phase1-eight-screens.log` и более ранние phase1 logs.
- Standalone Swift проверил 36 aliases, original fallback и три plain/plural collisions. Размеры PNG, alpha Premium, исходный bitmap и hashes семи анимаций проверены. Build завершился с exit 0; в Xcode логах были upstream warnings и диагностические строки `failed with exit code 0`, поэтому заключение основывалось также на результате процесса, бинарнике и проверке подписи.

## Что читать дальше и порядок продолжения

1. Прочитать текущие правила владельца в workspace `AGENTS.md`, этот файл и repo `AGENTS.md`. Для контекста всего Messenger — skill `ansible-context` и `ansible-app/workflow`. Не превращать старые поручения в новые задачи автоматически.
2. Сверить HEAD/status/remotes; не потерять чужие submodule changes и `.vscode`.
3. Прочитать `docs/ansible-rebranding-plan.md`, `docs/ansible-rebranding-backlog.csv`, `docs/ansible-rebranding-phase1.md`, `branding/README.md`. В backlog честно стоят partial/UI-pending, а не всё done.
4. Разблокировать Mac, подтвердить при необходимости Keychain, вернуть Russian, проверить именно новую сборку.
5. Пройти таблицу восьми экранов, сделать обезличенные screenshots и визуальные PASS/FAIL. Проверить отсутствие старого render cache; не сбрасывать аккаунт, базу или историю ради картинки.
6. Если есть дефект — воспроизвести, проследить конкретный caller/asset/tint, исправить и пересобрать. Проверка upstream нужна для багфикса по правилам владельца; собственный ребрендинг имеет явное поручение.
7. После приёмки обновить memory/phase1/backlog. Далее согласованный полный план: оставшиеся 23 языка, light/dark/auto/Reduce Motion, остальные Premium/hero/refund/payment/affiliate/empty/error поверхности, ссылки и реальные capabilities. Не называть весь клиент полностью ребрендированным на основании этих 46 PNG.

Предыдущая история: баг дублирования таблицы в сообщениях исправляли в backend и выкатывали отдельно; пользователь подтвердил, что верхний текст в новом примере — самостоятельная часть сообщения. Не удалять такой текст как «дубль» и не возобновлять этот баг без нового воспроизведения. Точных backend revisions этой работы здесь не зафиксировано — искать в соответствующем workflow/отчёте, не придумывать.

## Постоянные ограничения

Коммиты author/committer только **WhYasha**; подтверждённый email `197002110+WhYasha@users.noreply.github.com`. Перед коммитом проверить effective identities и связь с GitHub, не использовать старую ony identity, не добавлять AI co-author. Этот email не заменяет проверку аккаунта.

Backend/переводы выпускать через TeamCity штатным master запуском без custom revision overrides; проверять push, Changes/revisions, digest, rollout и e2e. Не запускать backend build как безобидный compile check: он выкатывает. Для продолжения только UI приёмки повторный deploy не нужен.

Credentials, токены, SSH keys, auth/session-файлы и личные сообщения в этот файл и Git не включены. Доступы/тестовые сессии со старого компьютера не считать доступными на новом; настраивать безопасно, не вытаскивать секреты из серверных логов.
