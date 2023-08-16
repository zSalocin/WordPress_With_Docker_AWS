[![en](https://img.shields.io/badge/lang-en-green.svg)](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/README.md)   [![pt-br](https://img.shields.io/badge/lang-pt--br-red.svg)](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/README_PT-BR.md)

# Atividade Docker

Repositório para a atividade de Docker, do programa de bolsas da Compass UOL.

**Objetivo**: Configurar um ambiente na AWS com um Load Balancer que direcione o tráfego para uma instância EC2 contendo um contêiner Docker executando o WordPress. Os recursos estáticos do contêiner serão armazenados em um sistema de arquivos EFS, enquanto os dados do WordPress serão gerenciados pelo serviço Amazon RDS.

**Escopo**: O escopo do projeto abrange uma série de etapas interconectadas para atingir o objetivo proposto:

- Preparação Inicial:
Geração de uma chave pública SSH para estabelecer acesso seguro às instâncias.

- Criação da Infraestrutura:
Criação de instâncias EC2, baseadas na imagem do Amazon Linux 2, destinadas a hospedar a aplicação WordPress.
Configuração de grupos de segurança a fim de permitir comunicações HTTP/HTTPS e SSH.
Associação de um endereço IP elástico a cada instância, garantindo um ponto de acesso estável.
Implementação de um Load Balancer para distribuir o tráfego entre as instâncias EC2.

- Configuração do Sistema de Arquivos EFS:
Estabelecimento de um sistema de arquivos EFS, dedicado ao armazenamento dos recursos estáticos do WordPress.
Montagem do sistema de arquivos EFS nas instâncias EC2, viabilizando o compartilhamento dos recursos entre as instâncias.

- Configuração do Docker Compose para WordPress:
Desenvolvimento de um arquivo docker-compose.yml, utilizado para definir e configurar o ambiente do WordPress.
Adequação do Docker Compose para integrar os recursos estáticos do sistema de arquivos EFS.

- Integração com o Amazon RDS:
Configuração de uma instância no Amazon RDS, destinada a armazenar e gerenciar os dados essenciais para o funcionamento do WordPress.
Ajuste das configurações do WordPress para permitir a conexão e interação com o banco de dados do Amazon RDS.

- Automação e Monitoramento:
Desenvolvimento de um script de inicialização, com o propósito de montar automaticamente o sistema de arquivos EFS.
Configuração de um sistema de monitoramento capaz de identificar e alertar sobre possíveis falhas nas instâncias EC2.
Implementação de um script de validação para verificar continuamente a disponibilidade do serviço WordPress, emitindo alertas no caso de indisponibilidade.

- Documentação:
Elaboração de um guia de instruções detalhado, descrevendo passo a passo a configuração e implantação do ambiente WordPress.
Documentação clara e abrangente das etapas relevantes para a monitorização e solução de eventuais problemas que possam surgir no ambiente.

O projeto, ao cumprir esse escopo, assegurará um ambiente altamente confiável e escalável, capaz de hospedar um site WordPress, com recursos estáticos armazenados de forma eficiente e gestão dos dados garantida pelo Amazon RDS. O Load Balancer contribuirá para a distribuição equilibrada do tráfego, enquanto a automação e monitorização colaborarão para a manutenção da disponibilidade do serviço.

**Arquitetura do Projeto**:

![PROJECT_ARCHITECTURE](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/PROJECT_ARCHITECTURE.png)

**Referências**: [Documentação da Amazon Web Services](https://docs.aws.amazon.com/pt_br/index.html), [Documentação do Amazon Linux 2](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/amazon-linux-2-virtual-machine.html), [Documentação do Docker](https://docs.docker.com/), [Documentação do Docker-Compose](https://docs.docker.com/compose/).

---
## Passo a Passo

### Criando uma VPC
- Na AWS busque por VPC.

![VPC_APP](https://github.com/zSalocin/ApacheServer_NFS_Script_in_AWS_EC2/blob/main/Assets/VPC_APP.png)

- No menu de VPC clique em `Criar VPC`.

- Para instruções detalhadas podem ser encotradas [Aqui](https://github.com/zSalocin/ApacheServer_NFS_Script_in_AWS_EC2/blob/main/README_PT-BR.md#criando-uma-vpc)

### Criando Securitys Groups
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

- Acesse o console da AWS e navegue até a seção EFS para dar início ao processo de criação do Elastic File System. Você pode encontrar instruções detalhadas sobre como executar essa etapa neste [link](https://github.com/zSalocin/ApacheServer_NFS_Script_in_AWS_EC2/blob/main/README_PT-BR.md#criando-um-efsnsf-server),  onde estão disponíveis orientações específicas. Certifique-se de utilizar o security group que foi criado anteriormente para assegurar as configurações de segurança. 

### Criando o RDS


### Criando uma Instancia EC2

- Acesse o console da AWS e navegue até a seção EC2 para dar início ao processo de criação da instância. Você pode encontrar instruções detalhadas sobre como executar essa etapa neste [link](https://github.com/zSalocin/ApacheServer_NFS_Script_in_AWS_EC2/blob/main/README_PT-BR.md#criando-uma-instancia-ec2-na-aws),  onde estão disponíveis orientações específicas. Certifique-se de utilizar o security group que foi criado anteriormente para assegurar as configurações de segurança. 
//checar essa ultima frase
- Após concluir o processo de criação da instância, no campo de user data, insira o seguinte shell script:

shellscript


### Configurando Docker Compose

### IAM

### Auto Scaling

### Configurando Load Balancer