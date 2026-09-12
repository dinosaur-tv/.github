# Dino TV

Домашний экран Android TV: время, погода, календари, музыка и анимированные темы.
Управление — из Telegram или приложения телефона.

**Один сервер, много домов.** У каждого дома свои участники, календари, устройства и настройки; соседние дома друг для друга невидимы.

## Скачать

- Telegram: [@dino_server_bot](https://t.me/dino_server_bot)
- [APK для телевизора](https://github.com/dinosaur-tv/tv-app/releases/latest)
- [APK пульта для Android](https://github.com/dinosaur-tv/android-app/releases/latest)
- [IPA для iPhone](https://github.com/dinosaur-tv/ios-app/releases/latest)
- [Экран для Windows](https://github.com/dinosaur-tv/app/releases/latest) — portable .exe, установка не нужна
- [Как установить, включая sideload на iOS](https://github.com/dinosaur-tv/.github/blob/main/docs/INSTALL.md)

## Репозитории

| Репозиторий | Назначение |
| --- | --- |
| [backend](https://github.com/dinosaur-tv/backend) | API, бот, дома, календари, подключение устройств |
| [app](https://github.com/dinosaur-tv/app) | Экран ТВ и веб-консоль |
| [tv-app](https://github.com/dinosaur-tv/tv-app) | Android TV |
| [android-app](https://github.com/dinosaur-tv/android-app) | Пульт для Android |
| [ios-app](https://github.com/dinosaur-tv/ios-app) | iPhone |

Свой сервер поднимается по README backend; открытая регистрация включается флагом `REGISTRATION_OPEN`.

Экспериментальный пульт выключен по умолчанию. Музыку воспроизводит установленный плеер, Dino показывает состояние.

Исходники — MIT. У сторонних изображений отдельные лицензии.
