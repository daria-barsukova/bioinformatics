# Установка и использование GNU Make

GNU Make — это инструмент автоматизации сборки, который управляет зависимостями и последовательным выполнением команд, описанных в специальном файле `Makefile`.

## 1. Проверка установки

Прежде чем устанавливать GNU Make, проверьте, возможно, он уже установлен на вашей системе. Введите в терминале:

```bash
make --version
```

Если вы видите номер версии, например `GNU Make 4.3`, значит `make` уже установлен. Перейдите к разделу [5. Как пользоваться GNU Make](#5-как-пользоваться-gnu-make).

## 2. Установка на Linux (Debian/Ubuntu)

Откройте терминал и выполните следующие команды:

```bash
sudo apt update
sudo apt install make
```

## 3. Проверка установки

После завершения установки снова выполните:

```bash
make --version
```

Вы должны увидеть номер версии GNU Make — это подтверждает, что установка прошла успешно.

## 4. Альтернативные способы установки

### macOS:

```bash
brew install make
```

### Arch Linux:

```bash
sudo pacman -S make
```

### Windows:

Вы можете установить GNU Make с помощью [MSYS2](https://www.msys2.org/) или [GnuWin32](http://gnuwin32.sourceforge.net/packages/make.htm).

## 5. Как пользоваться GNU Make

Для работы создайте файл с именем `Makefile`, содержащий описание целей и зависимостей. Пример структуры:

```make
<цель>: <зависимости>
    <команда #1>
    ...
    <команда #N>
```

**Пример:**

```make
all: output.txt

output.txt: input.txt
    cat input.txt > output.txt
```

Здесь:

- **Что делаем? (цель)** → `output.txt`
- **Из чего делаем? (зависимости)** → `input.txt`
- **Как делаем? (команды)** → `cat input.txt > output.txt`

## 6. Ресурсы

- [Официальный сайт GNU Make](https://www.gnu.org/software/make/)
- [Документация](https://www.gnu.org/software/make/manual/)
- [Примеры и туториалы](https://makefiletutorial.com/)
