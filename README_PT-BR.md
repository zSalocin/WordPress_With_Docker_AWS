[![en](https://img.shields.io/badge/lang-en-green.svg)](https://github.com/zSalocin/ApacheServer_NFS_Script_in_AWS_EC2/blob/main/README.md)   [![pt-br](https://img.shields.io/badge/lang-pt--br-red.svg)](https://github.com/zSalocin/ApacheServer_NFS_Script_in_AWS_EC2/blob/main/README_PT-BR.md)

# Atividade Docker

Repositório para a atividade de Docker, do programa de bolsas da Compass UOL.

**Objetivo**: Criar um ambiente AWS com uma instância EC2 e configurar o NFS para armazenar dados.

**Escopo**: A atividade incluirá a geração de uma chave pública de acesso, criação de uma instância EC2 com o sistema operacional Amazon Linux 2, geração de um endereço IP elástico e anexá-lo à instância EC2, liberação de portas de comunicação para acesso público, configuração do NFS, criação de um diretório com o nome do usuário no filesystem do NFS, instalação e configuração do Apache, criação de um script para validar se o serviço está online e enviar o resultado para o diretório NFS, e configuração da execução automatizada do script a cada 5 minutos.

**Referências**: [Documentação da Amazon Web Services](https://docs.aws.amazon.com/pt_br/index.html), [Documentação do Amazon Linux 2](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/amazon-linux-2-virtual-machine.html), [Documentação do ApacheServer](https://docs.oracle.com/en/learn/apache-install/#introduction), [Documentação do Contrab](https://docs.oracle.com/en/learn/oracle-linux-crontab/#before-you-begin).

---