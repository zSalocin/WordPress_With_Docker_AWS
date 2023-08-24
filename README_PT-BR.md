[![en](https://img.shields.io/badge/lang-en-green.svg)](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/README.md)   [![pt-br](https://img.shields.io/badge/lang-pt--br-red.svg)](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/README_PT-BR.md)

# Atividade Docker

Repositório para a atividade de Docker, do programa de bolsas da Compass UOL.

**Objetivo**: Configurar um ambiente na AWS com um Load Balancer que direcione o tráfego para uma instância EC2 contendo um contêiner Docker executando o WordPress. Os recursos estáticos do contêiner serão armazenados em um sistema de arquivos EFS, enquanto os dados do WordPress serão gerenciados pelo serviço Amazon RDS.

**Escopo**: O escopo do projeto abrange uma série de etapas interconectadas para atingir o objetivo proposto:

- Preparação Inicial:
Geração de uma chave pública SSH para estabelecer acesso seguro às instâncias.

- Criação da Infraestrutura:
Criação de instâncias EC2, baseadas na imagem do Amazon Linux 2, destinadas a hospedar a aplicação.
Configuração de grupos de segurança a fim de permitir comunicações HTTP/HTTPS e SSH.
Implementação de um grupo de Auto Scaling para gerenciar as instâncias de acordo com a demanda.
Implementação de um Load Balancer para distribuir o tráfego entre as instâncias EC2.

- Configuração do Sistema de Arquivos EFS:
Estabelecimento de um sistema de arquivos EFS dedicado ao armazenamento dos recursos estáticos.
Montagem do sistema de arquivos EFS nas instâncias EC2, viabilizando o compartilhamento dos recursos entre elas.

- Configuração do Docker Compose para WordPress:
Desenvolvimento de um arquivo docker-compose.yml, utilizado para definir e configurar o ambiente do WordPress.
Adequação do Docker Compose para integrar os recursos estáticos do sistema de arquivos EFS.

- Integração com o Amazon RDS:
Configuração de uma instância no Amazon RDS, destinada a armazenar e gerenciar os dados essenciais para o funcionamento do WordPress.
Ajuste das configurações do WordPress para permitir a conexão e interação com o banco de dados do Amazon RDS.

- Automação:
Desenvolvimento de um script de inicialização, com o propósito de montar automaticamente o sistema de arquivos EFS.
Configuração do Auto Scaling para inicializar e encerrar instâncias conforme a demanda.

- Documentação:
Elaboração de um guia de instruções detalhado, descrevendo passo a passo a configuração e implantação do ambiente WordPress.
Documentação clara e abrangente das etapas relevantes para a monitorização e solução de eventuais problemas que possam surgir no ambiente.

- O projeto, ao cumprir esse escopo, irá assegurar um ambiente altamente confiável e escalável, capaz de hospedar um site WordPress, com recursos estáticos armazenados de forma eficiente e gestão dos dados garantida pelo Amazon RDS. O Load Balancer contribuirá para a distribuição equilibrada do tráfego, enquanto a automação e o Auto Scaling colaborarão para a manutenção da disponibilidade do serviço.

**Arquitetura do Projeto**:

![PROJECT_ARCHITECTURE](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/PROJECT_ARCHITECTURE.png)

**Referências**: [Documentação da Amazon Web Services](https://docs.aws.amazon.com/pt_br/index.html), [Documentação do Amazon Linux 2](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/amazon-linux-2-virtual-machine.html), [Documentação do Docker](https://docs.docker.com/), [Documentação do Docker-Compose](https://docs.docker.com/compose/).

---
## Passo a Passo

### Criando uma VPC
- Na AWS busque por `VPC`.

![VPC_APP](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/VPC_APP.png)

- No menu de VPC clique em `Criar VPC`.

- Ao criar a VPC selecione para criar um NAT Gateway.

- Instruções detalhadas de como criar uma VPC podem ser encontradas [Aqui](https://github.com/zSalocin/ApacheServer_NFS_Script_in_AWS_EC2/blob/main/README_PT-BR.md#criando-uma-vpc)

<details>
<summary>Adicionar NAT Gateway após criar a VPC</summary>

- Após criar a VPC ainda no menu vá até `Gateways NAT`.

- Clique em `Criar gateway NAT`.

- Nomeie o Nat Gateway e em `Sub-rede` selecione uma das sub-redes públicas.

- Mantenha `Tipo de conectividade` como público.

- Em seguida clique em `Criar gateway NAT`.

- Após criar o NAT gateway, acesse `Tabelas de rotas`.

- Na `Tabela de rotas` selecione as rotas privadas, clique em `Ações` e selecione `Editar rotas`, será necessário realizar isso para as duas rotas.

- Em `Editar rotas` em `destino` selecione `0.0.0/0`

- Em Alvo selecione `Gateway NAT` e selecione o NAT gateway criado anteriormente.

- Clique em `Salvar alterações`.

</details>

- Para verificar se sua VPC está correta acesse `Suas VPCs` em seguida selecione a VPC criada anteriormente e a opção `Resource map` e verifique se está de acordo com a imagem abaixo.

![VPC_MAP](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/VPC_MAP.png)

### Criando Securitys Groups
- No menu EC2 procure por `Security groups` na barra de navegação à esquerda.

![SC_BARRA](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/SC_BARRA.png)

- Acesse e clique em `Criar novo grupo de segurança`, e crie os grupos de segurança a seguir.

- Instruções detalhadas de como criar um grupo de segurança podem ser encontradas [Aqui](https://github.com/zSalocin/ApacheServer_NFS_Script_in_AWS_EC2/blob/main/README_PT-BR.md#criando-um-securitygroup)

#### EFS
| Tipo | Protocolo | Intervalo de portas | Origem | Descrição |
| ---|---|---|---|--- |
| TCP personalizado | TCP | 2049 | 0.0.0.0/0 | NFS |
| UDP personalizado | UDP | 2049 | 0.0.0.0/0 | NFS |

#### EC2
| Tipo | Protocolo | Intervalo de portas | Origem | Descrição |
| ---|---|---|---|--- |
| SSH | TCP | 22 | 0.0.0.0/0 | SSH |
| TCP personalizado | TCP | 80 | 0.0.0.0/0 | HTTP |
| TCP personalizado | TCP | 443 | 0.0.0.0/0 | HTTPS |

#### RDS
| Tipo | Protocolo | Intervalo de portas | Origem | Descrição |
| ---|---|---|---|--- |
| TCP personalizado | TCP | 3306 | 0.0.0.0/0 | RDS |

#### Endpoint

Permita somente conexões out bound.

### Criando um EFS
- Busque por `EFS` na Amazon AWS o serviço de arquivos de NFS escalável da AWS.

![EFS_APP](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/EFS_APP.png)

- Na Página de EFS clique em `Criar sistema de arquivos`.

- Instruções detalhadas sobre a criação de um EFS podem ser encontradas [aqui](https://github.com/zSalocin/ApacheServer_NFS_Script_in_AWS_EC2/blob/main/README_PT-BR.md#criando-um-efsnsf-server),  onde estão disponíveis orientações específicas. Certifique-se de utilizar o security group que foi criado anteriormente para assegurar as configurações de segurança. 

### Criando o RDS
- Busque por RDS na Amazon AWS.

![RDS_APP](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/RDS_APP.png)

- Na página de RDS clique em `Criar banco de dados`.

- Na página de `Criar banco de dados` selecione `Criação padrão`.

- Em `Opções do mecanismo` selecione `MySQL`.

- Como `Versão do mecanismo` selecione `MySQL 8.0.33`.

- Em `Modelos` selecione `Nível gratuito`.

- Na aba `Configurações` preencha o `Nome do usuário principal` e a `Senha principal` que serão utilizados no Script.

- Em `Configuração da instância` selecione como classe `db.t3.micro`.

- Na aba `Armazenamento` desabilite a opção `Habilitar escalabilidade automática do armazenamento`.

- Na aba `Conectividade` selecione `Não se conectar a um recurso de computação do EC2` e selecione a VPC criada anteriormente em VPC.

- Na opção `Acesso público` selecione sim.

- Em `Grupo de segurança de VPC (firewall)` selecione o Security group criado anteriormente para o RDS

- Na aba `Configuração adicional` preencha `Nome do banco de dados inicial` será necessário para o Script.

- Clique em `Criar banco de dados`

### Modelo de execução
- No menu EC2 procure por `Modelo de execução` na barra de navegação à esquerda.

![MD_BARRA](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/MD_BARRA.png)

- Acesse e clique em `Criar modelo de execução`.

- Nomeie o modelo de execução, e opcionalmente dê ao modelo uma descrição.

- Em `Imagens de aplicação e de sistema operacional` selecione Amazon Linux 2.

- Na aba `Tipo de instância` selecione t2.micro.

- Selecione uma chave existente ou crie uma nova em `Par de chaves`.

- Em `Configurações de rede` não inclua uma sub-rede no modelo, e selecione o grupo de segurança criado anteriormente. 

- Na aba `Armazenamento` selecione 8GiB de gp2.

- Adicione as tags necessárias a suas instância em `Tags de recurso`.

- A duas opções ao utilizar o Script, utilizar ele e criar o arquivo do docker-compose ou então criar o arquivo do docker-compose fora do Script.

<details>
<summary>Utilizar o Script para a criação do docker-compose</summary>

- Em `Detalhes avançados` copie para `Dados do usúario` o Script que pode ser encontrado [Aqui](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/StartWithDockerCompose.sh) e altere as variaveis necessarias que estão marcadas por <>.

</details>

<details>
<summary>Criar o docker-compose separadamente</summary>

- Em `Detalhes avançados` copie para `Dados do usúario` o Script que pode ser encontrado [Aqui](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/StartWithoutDockerCompose.sh) e altere as variaveis necessarias que estão marcadas por <>.

- Como o Script não criará o arquivo docker-compose necessário para inicialização dos contêineres será necessário alguns passo adicionais.

- Será necessario criar e executar uma instancia EC2 conectada ao EFS criado anteriormente, instuções detalhadas podem ser encontradas [Aqui](https://github.com/zSalocin/ApacheServer_NFS_Script_in_AWS_EC2/blob/main/README_PT-BR.md#criando-uma-instancia-ec2-na-aws).

- Acesse a instância e navegue até o diretório `/mnt/efs`.

- Crie um arquivo através  do comando:

```
vi docker-compose.yml
```

- Copie ou digite para o arquivo o conteúdo a seguir, respeitando a formatação.

```
    services:
      wordpress:
        image: wordpress:latest
        volumes:
          - /mnt/efs/wordpress:/var/www/html
        ports:
          - "80:80"
        environment:
          WORDPRESS_DB_HOST: <RDS End point>
          WORDPRESS_DB_USER: <RDS Master Username>
          WORDPRESS_DB_PASSWORD: <Master Password>
          WORDPRESS_DB_NAME: <RDS name, selected in additional settings>
          WORDPRESS_TABLE_CONFIG: wp_
```

- Altere as variáveis necessárias que estão marcadas com <>.

- Siga os passos restantes até o fim do tutorial e uma vez que as instâncias estejam rodando delete a instância criada para a criação do arquivo docker-compose.

</details>

- Ao terminar de alterar o StartScript clique em `Criar modelo de execução`.

### Target Group
- No menu EC2 procure por `Grupos de destino` na barra de navegação à esquerda.

![TG_BARRA](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/TG_BARRA.png)

- Acesse e clique em `Criar grupo de destino`.

- Em `Escolha um tipo de destino` clique em `Instâncias`.

- Nomeie o grupo de destino.

- Em `Protocolo` mantenha `HTTP` e em `Porta` mantenha a porta `80`.

- Como `VPC` selecione a VPC criada anteriormente.

- Mantenha a `Versão do protocolo` como `HTTP1`.

- A seguir clique em `Próximo`.

- Na página de `Registrar destinos` não selecione nenhuma instância.

- Selecione `Criar grupo de destino`.

### Load Balancer
- No menu EC2 procure por `load Balancer` na barra de navegação à esquerda.

![LB_BARRA](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/LB_BARRA.png)

- Acesse e clique em `Criar load balancer`.

- Selecione `Criar` Application Load Balancer.

- Nomeie o load balancer.

- Em `Esquema` selecione `Voltado para a internet`.

- Em `Tipo de endereço IP` mantenha `IPv4`.

- Na aba `Mapeamento de rede` selecione a rede VPC.

- Selecione as duas subnets públicas criadas anteriormente.

![LB_VPC](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/LB_VPC.png)

- Como `Grupo de segurança` selecione o grupo criado anteriormente para EC2.

- Em `Listeners e roteamento` mantenha `HTTP`:`80` e selecione o grupo de destino criado anteriormente.

![LB_LISTENER](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/LB_LISTENER.png)

- Clique em `Criar load Balancer`.

### Auto Scaling
- No menu EC2 procure por `Auto Scaling` na barra de navegação à esquerda.

![LB_BARRA](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/AU_BARRA.png)

- Acesse e clique em `Criar grupo do Auto Scaling`.

- Nomeie o grupo de Auto Scaling.

- Selecione o modelo de execução criado anteriormente.

- A seguir clique em `Próximo`.

- Selecione a VPC criada anteriormente.

- Selecione as Sub-redes Privadas.

![LB_VPC](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/AU_VPC.png)

- A seguir clique em `Próximo`.

- Marque a opção `Anexar a um balanceador de carga existente`.

- Marque a opção `Escolha entre seus grupos de destino de balanceador de carga`.

- Selecione o grupo de destino criado anteriormente.

- A seguir clique em `Próximo`.

- Em `Tamanho do grupo` selecione:
    - Capacidade desejada: 2
    - Capacidade mínima: 2
    - Capacidade máxima: 3

- A seguir clique em `Pular para a revisão`.

- Clique em `Criar grupo de auto Scaling`.

### Verificando funcionamento
- No menu EC2 procure por `load Balancer` na barra de navegação à esquerda.

- Selecione o Load Balancer criado anteriormente, copie o `Nome do DNS` e cole no navegador, se as instâncias do EC2 já estão rodando deve ser possível acessar o WordPress.

![WP_LG](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/WP_LG.png)

- Em seguida configure o WordPress.

![WP_CR](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/WP_CR.png)

- A partir daí é possível acessar e configurar o WordPress.

- Cheque a integridade acesse `Grupos de destino`.

- Selecione o Grupo de destino criado anteriormente e verifique se as instâncias estão íntegras.

![GP_IN](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/GP_IN.png)

- Para acessar as instâncias e verificá-las é necessário criar um EndPoint para isso busque por `VPC`.

- No menu esquerdo selecione Endpoints.

![VPC_END](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/VPC_END.png)

- Clique em `Criar endpoint`.

- Nomeie o Endpoint e em seguida selecione em `Categoria de serviço` a categoria `EC2 Instance Connect Endpoint`.

- Em `VPC` selecione a VPC criada anteriormente.

- Como `Grupos de segurança` selecione o grupo criado para EndPoint.

- Em `Subnet` selecione uma das subnets privadas da VPC.

- Clique em `Criar endpoint`.

- Após o EndPoint ter sido criado navegue até a instância que deseja conectar.

- Clique em `Conectar`.

- Em `Conexão de instância do EC2` selecione `Conectar-se usando o endpoint do EC2 Instance Connect` e em `Endpoint do EC2 Instance Connect` selecione o EndPoint criado anteriormente e clique em `Conectar`.

<details>
<summary>Testar o docker</summary>

- Verifique a execução de containers com o comando: 

```
docker ps
```

![EC2_DC](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/EC2_DC.png)

- Verifique a instalação do docker-compose com o comando:

```
docker-compose -v
```

- Verifique a config file com o comando:

```
docker-compose ls
```

</details>

<details>
<summary>Testar DataBase</summary>

- Acesse o Container em execução através do comando:

```
docker exec -it <ID_DO_CONTAINER_WORDPRESS> /bin/bash
```

- O `<ID_DO_CONTAINER_WORDPRESS>` pode-ser encontrado utilizando o comando:

```
docker ps
```

- Dentro do Container execute o comando abaixo para atualizar o sistema:

```
apt-get update
```

- Após a atualização do sistema é necessário instalar a biblioteca de cliente do mysql:

```
apt-get install default-mysql-client -y
```

- Agora use o comando abaixo para entrar no banco de dados MySQL:

```
mysql -h <ENDPOINT_DO_SEU_RDS> -P 3306 -u admin -p
```

- O `<ENDPOINT_DO_SEU_RDS>` e o mesmo utilizado no Script que pode-ser encontrado em detalhes após a criação do Database.

![DC_DB](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/DC_DB.png)

</details>

<details>
<summary>Verificar o Mount</summary>

- Verifique se o EFS está montado com o comando:

```
df -h
```

![EC2_DF](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/EC2_DF.png)

- Verifique a persistência do mount, acesse o diretório etc através do comando.

```
cd /etc
```

- leia o arquivo fstab com o comando.

```
cat fstab
```

![EC2_FS](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/EC2_FS.png)

</details>

<details>
<summary>Verificar o Crontab</summary>

- Verifique o crontab através do comando:

```
crontab -l
```

![EC2_CR](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/EC2_CR.png)

</details>