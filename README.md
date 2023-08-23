[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/README.md)   [![pt-br](https://img.shields.io/badge/lang-pt--br-green.svg)](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/README_PT-BR.md)

# Docker Activity

Repository for the Docker activity, part of the Compass UOL scholarship program.

**Objective**: Set up an environment on AWS with a Load Balancer that directs traffic to an EC2 instance containing a Docker container running WordPress. The static resources of the container will be stored in an Elastic File System (EFS), while the WordPress data will be managed by the Amazon RDS service.

**Scope**: The project scope encompasses a series of interconnected steps to achieve the proposed objective:

- Initial Preparation:
Generate an SSH public key to establish secure access to the instances.

- Infrastructure Creation:
Create EC2 instances based on the Amazon Linux 2 image, intended to host the application.
Configure security groups to allow HTTP/HTTPS and SSH communications.
Associate an Elastic IP address with each instance, ensuring a stable access point.
Implement a Load Balancer to distribute traffic among the EC2 instances.

- EFS File System Configuration:
Establish an EFS file system dedicated to storing the static resources.
Mount the EFS file system on the EC2 instances, enabling resource sharing among instances.

- Docker Compose Configuration for WordPress:
Develop a docker-compose.yml file used to define and configure the WordPress environment.
Adapt the Docker Compose to integrate the static resources of the EFS file system.

- Integration with Amazon RDS:
Configure an Amazon RDS instance to store and manage essential data for WordPress operation.
Adjust WordPress settings to allow connection and interaction with the Amazon RDS database.

- Automation:
Develop a startup script with the purpose of automatically mounting the EFS file system.

- Documentation:
Create a detailed instruction guide, describing step by step the configuration and deployment of the WordPress environment.
Provide clear and comprehensive documentation of the relevant steps for monitoring and solving any issues that may arise in the environment.

By fulfilling this scope, the project will ensure a highly reliable and scalable environment capable of hosting a WordPress site, with static resources efficiently stored and data management ensured by Amazon RDS. The Load Balancer will contribute to balanced traffic distribution, while automation will aid in maintaining service availability.

**Project Architecture**:

![PROJECT_ARCHITECTURE](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/PROJECT_ARCHITECTURE.png)

**References**: [Amazon Web Services Documentation](https://docs.aws.amazon.com/pt_br/index.html), [Amazon Linux 2 Documentation](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/amazon-linux-2-virtual-machine.html), [Docker Documentation](https://docs.docker.com/), [Docker-Compose Documentation.](https://docs.docker.com/compose/).

---
## Passo a Passo

### Criando uma VPC
- Na AWS busque por `VPC`.

![VPC_APP](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/VPC_APP.png)

- No menu de VPC clique em `Criar VPC`.

<details>
<summary>Criar VPC e NAT Gateway</summary>

- Habilite a opção de criação do NAT Gateway ao criar a VPC.

![VPC_NAT](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/VPC_NAT.png)

- Instruções detalhadas de como criar uma VPC podem ser encontradas [Aqui](https://github.com/zSalocin/ApacheServer_NFS_Script_in_AWS_EC2/blob/main/README_PT-BR.md#criando-uma-vpc)

</details>

<details>
<summary>Adicionar NAT Gateway a VPC</summary>

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

- Nomeio o grupo de Auto Scaling.

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