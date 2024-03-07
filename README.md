# Caixa Eletrônico API

Esta é uma API para um caixa eletrônico que permite carregar dinheiro no caixa eletrônico e realizar saques. A API foi desenvolvida em Ruby on Rails.

## Funcionalidades

- Carregar dinheiro no caixa eletrônico.
- Realizar saques com o menor número de notas possível.

## Instalação e Configuração

1. Certifique-se de ter o Ruby instalado em seu sistema. Você pode baixá-lo em [ruby-lang.org](https://www.ruby-lang.org/).
2. Navegue até o diretório do projeto.
3. Execute o comando `bundle install` para instalar as dependências.
4. Execute o comando `rails server` para iniciar o servidor

## Realizando requisições para a API
Uso da API poderá ser feito utilizando `Curl`, `Postman` ou `isonomia`

### Estado inicial da aplicação
O caixa eletrônico já conterá uma quantidade padrão para cada nota.

### Carregando mais notas no caixa eletrônico

### Endpoint: `POST /load_cash`

### Payload:

``` bash
{
  "caixa": {
    "caixaDisponivel": true,
    "notas": {
      "notasDez": 10,
      "notasVinte": 20,
      "notasCinquenta": 10,
      "notasCem": 5
    }
  }
}
```

### Exemplo de resposta:

```bash
{
  "caixa": {
    "caixaDisponivel": true,
    "notas": {
      "notasDez": 110,
      "notasVinte": 120,
      "notasCinquenta": 110,
      "notasCem": 105
    }
  },
  "erros": []
}
```

### Realizar saque

### Endpoint: `POST /withdraw`

### Payload:

```bash
{
  "saque": {
    "valor": 100
  }
}
```

### Exemplo de resposta:

```bash
{
  "notas_retiradas": {
    "notasCem": 1
  }
}
```

# Itens adicionais
### É possível fazer a criação de contas pra usuário através da rota abaixo:

### Endpoint: `POST /accounts`

### Payload:
Inicialmente não é necessária adição de payload neste primeiro momento, visto que trata-se de um app de testes e iste gera um UUID randômico para fins didáticos e caso haja a necessidade expansão futura, pois será possível fazer o relacionamento entre account e usuário, transações e tudo o que pode envolver a interação do usuário com o sistema.