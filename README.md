# Dino TV · организация

Домашний экран Android TV: время, погода, календари, музыка и темы. Управление — из Telegram или приложением на телефоне. Один сервер обслуживает много независимых домов.

## Скачать

| Что | Ссылка |
| --- | --- |
| Бот и мини-приложение | [@dino_server_bot](https://t.me/dino_server_bot) |
| Приложение для телевизора (APK) | [tv-app · Releases](https://github.com/dinosaur-tv/tv-app/releases/latest) |
| Пульт для Android (APK) | [android-app · Releases](https://github.com/dinosaur-tv/android-app/releases/latest) |
| Приложение для iPhone (IPA) | [ios-app · Releases](https://github.com/dinosaur-tv/ios-app/releases/latest) |
| Как установить APK и загрузить iOS через sideload | [docs/INSTALL.md](docs/INSTALL.md) |

Начните с бота: он создаёт дом, подключает календари и выдаёт код для телевизора. Приложения — по желанию.

## Репозитории

| Репозиторий | Назначение |
| --- | --- |
| [backend](https://github.com/dinosaur-tv/backend) | API, бот, дома, календари, подключение устройств |
| [app](https://github.com/dinosaur-tv/app) | Экран ТВ и веб-консоль мини-приложения |
| [tv-app](https://github.com/dinosaur-tv/tv-app) | Android TV |
| [android-app](https://github.com/dinosaur-tv/android-app) | Пульт для Android |
| [ios-app](https://github.com/dinosaur-tv/ios-app) | iPhone |

## Документы

- [Публичный профиль](profile/README.md)
- [Установка приложений](docs/INSTALL.md)
- [Свой сервер](https://github.com/dinosaur-tv/backend#readme) · [общий сервер](https://github.com/dinosaur-tv/backend/blob/main/docs/HOSTED_SERVICE.md)
- [Перед публикацией](docs/PUBLISHING.md)
- [Безопасность](SECURITY.md)
- [Участие](CONTRIBUTING.md)

Проверка файлов и истории без вывода секретов:

```bash
node scripts/publication-audit.mjs ../backend ../app ../tv-app ../ios-app ../android-app
```

Проверка по шаблонам не заменяет ручной аудит и GitHub secret scanning.
