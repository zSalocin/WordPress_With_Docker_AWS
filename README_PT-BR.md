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

- O projeto, ao cumprir esse escopo, assegurará um ambiente altamente confiável e escalável, capaz de hospedar um site WordPress, com recursos estáticos armazenados de forma eficiente e gestão dos dados garantida pelo Amazon RDS. O Load Balancer contribuirá para a distribuição equilibrada do tráfego, enquanto a automação e o Auto Scaling colaborarão para a manutenção da disponibilidade do serviço.

**Arquitetura do Projeto**:

![PROJECT_ARCHITECTURE](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/PROJECT_ARCHITECTURE.png)

**Referências**: [Documentação da Amazon Web Services](https://docs.aws.amazon.com/pt_br/index.html), [Documentação do Amazon Linux 2](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/amazon-linux-2-virtual-machine.html), [Documentação do Docker](https://docs.docker.com/), [Documentação do Docker-Compose](https://docs.docker.com/compose/).

---
## Passo a Passo

### Criando uma VPC
- Na AWS busque por `VPC`.

![VPC_APP](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/VPC_APP.png)

- No menu de VPC clique em `Criar VPC`.

- Instruções detalhadas de como criar uma VPC podem ser encontradas [Aqui](https://github.com/zSalocin/ApacheServer_NFS_Script_in_AWS_EC2/blob/main/README_PT-BR.md#criando-uma-vpc)

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

- Na Pagina de RDS clique em `Criar banco de dados`.

## falta coisa

### Modelo de execução
- No menu EC2 procure por `Modelo de execução` na barra de navegação à esquerda.

![MD_BARRA](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/MD_BARRA.png)

- Acesse e clique em `Criar modelo de execução`.

- Nomeie o modelo de execução, e opcionalmente de ao modelo uma descrição.

- Em `Imagens de aplicação e de sistema operacional` selecione Amazon Linux 2.

- Na aba `Tipo de instância` selecione t2.micro.

- Selecione uma chave existente ou crie uma nova em `Par de chaves`.

- Em `Configurações de rede` não inclua uma sub-rede no modelo, e selecione o grupo de segurança criado anteriormente. 

- Na aba `Armazenamento` selecione 8GiB de gp2.

- Adicione as tags necessarias a suas instancia em `Tags de recurso`.

- Em `Detalhes acançados` copie para `Dados do usúario` o [Script](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/StartScript.sh) e altere as variaveis necessarias que estão marcadas por <>.

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

- Na pagina de `Registrar destinos` não selecione nenhuma instancia.

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

- Selecione as duas subnets publicas criadas anteriormente.

![LB_VPC(https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/LB_VPC.png)

- Como `Grupo de segurança` selecione o grupo criado anteriormente para EC2.

- Em `Listeners e roteamento` mantenha `HTTP`:`80` e selecione o grupo de destino criado anteriormente.

![LB_LISTENER(https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/LB_LISTENER.png)

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

![LB_BARRA](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/AU_VPC.png)

- A seguir clique em `Próximo`.

- Marque a opção `Anexar a um balanceador de carga existente`.

- Marque a opção `Escolha entre seus grupos de destino de balanceador de carga`.

- Selecione o grupo de destino criado anteriormente.

- A seguir clique em `Próximo`.

- Em `Tamanho do grupo` selecione:
-- Capacidade desejada: 1
-- Capacidade mínima: 2
-- Capacidade máxima: 3

- A seguir clique em `Pular para a revisão`.

- Clique em `Criar grupo de auto Scaling`.