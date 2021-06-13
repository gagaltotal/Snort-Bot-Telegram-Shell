# Snort Bot Telegram Bash Shell GNU/Linux

## [Gagaltotal.github.io] or [www.gagaltotal666.my.id] ##

![Screen Capture](https://raw.githubusercontent.com/gagaltotal/Snort-Bot-Telegram-Shell/master/log-snort-telegram.png)

![Screen Capture](https://raw.githubusercontent.com/gagaltotal/Snort-Bot-Telegram-Shell/master/snort-running.png)

### installation snort server GNU/Linux ####

#installation package Server Debian,Ubuntu, Mint:

```sh
sudo apt install snort -y
```

#installation package ARCH, Black ARCH, Manjaro:

```sh
sudo pacman -Sy snort
```

#installation snort source:

```sh
wget https://www.snort.org/downloads/snort/snort-2.9.16.1.tar.gz
tar xvzf snort-2.9.16.1.tar.gz
cd snort-2.9.16.1
./configure --enable-sourcefire && make && sudo make install
```

## Bot Telegram
#Get Token and Chat ID, Create Bot Telegram with BotFather :

```sh
- https://api.telegram.org/bot+token/getUpdates
- https://api.telegram.org/bot123456789:jbd78sadvbdy63d37gda37bd8/getUpdates
- https://api.telegram.org/bot(token bot)/sendMessage?chat_id=(chat id)&text=Coba aja
```

## Download Snort Bot Telegram

```sh
git clone https://github.com/gagaltotal/Snort-Bot-Telegram-Shell
cd Snort-Bot-Telegram-Shell
chmod 777 bot-tele.sh
```

## Use Snort bot Telegram
#Interface VM enp0s3 

```sh
sudo snort -i enp0s3 -c /etc/snort/snort.conf -l /var/log/snort -d -A console > /home/username/log-tele.txt
sudo snort -i enp0s3 -c /etc/snort/snort.conf -l /var/log/snort -d -A console > /home/ghost666/log-tele.txt
```

#Interface LAN Ethernet eth0

```sh
sudo snort -i eth0 -c /etc/snort/snort.conf -l /var/log/snort -d -A console > /home/username/log-tele.txt
sudo snort -i eth0 -c /etc/snort/snort.conf -l /var/log/snort -d -A console > /home/ghost666/log-tele.txt
```

#Running Alert Snort Bot Telegram

```sh
./bot-tele.sh
```

## Tutorial Artikel and Video

```sh
https://www.gagaltotal666.my.id/2020/08/ids-snort-bot-telegram-menggunakan-bash.html
https://youtu.be/phyYwlgt3Ec
```
