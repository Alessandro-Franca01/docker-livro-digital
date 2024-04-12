# README

# Setup Docker: Livro dos Inspetores

Automatização de app para ambiente de desenvolvimento

## 🚀 Começando

Primeira versão usando o docker-compose 

### 📋 Pré-requisitos

 - Docker (Ultima versão)
 - Docker-compose (Ultima versão)
 - Portainer (Instalação Opcional)

### 🔧 Instalação em ambiente de desenvolvimento

Fazer o clone desse projeto:

```
git clone <repo>
```

Ir para o diretorio raiz do projeto clonado

```
cd docker-livro-digital
```

Fazer o clone do projeto do Livro Digital <br>
Link: https://github.com/Alessandro-Franca01/Livro-de-Inspertores

```
git clone <repo>
```

Voltar para pasta raiz onde esta o docker-compose e subir os containers

```
cd ..
```

```
docker compose up
```

### Importante:
Verfique se está tudo ok com os containers, com portainer ou no seu terminal.<br>
Se deu tudo certo, continue a configuração dentro do projeto laravel do Livro Digital.

Link do projeto: https://github.com/Alessandro-Franca01/Livro-de-Inspertores

### Conectado a Aplicação com a API<br>
Por fim, depois que a API estiver ok, conecte-se com ela:

```
docker network connect api-docker-livro-digital_api <nome_container>
```
Altere a variavel ULR_API para:

```
URL_BASE_API="http://api-dev:8080/"
```

### Pronto, se ocorreu tudo corretamente vc já pode fazer o login!

## 🛠️ Ferramentas

* [Docker & Docker-Compose](https://www.docker.com//) - Programas para trabalhar com containers
* [Portainer - CE](https://docs.portainer.io/start/install-ce/) - Gerenciador de containres web

## 📌 Versão

Versão 1.0.0 

## ✒️ Autor

* **Alessandro França** - *Desenvolvedor Full Stack* - [Github](https://github.com/Alessandro-Franca01)

## 🎁 Agradecimentos

* DITECI & GM Cabdelo;

---
⌨️ feito por [Alessandro Franca](https://github.com/Alessandro-Franca01)


