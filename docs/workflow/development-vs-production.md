# Separação entre Desenvolvimento e Produção

Este documento define a estratégia da equipe do **iNeed** para gerenciar o código-fonte, garantindo que o ambiente de testes não interfira na versão final que será entregue aos usuários.

## 1. Fluxo de Trabalho Adotado
Para este projeto, a equipe adotará o conceito baseado no **GitHub Flow** com uso de branches (ramificações) de desenvolvimento e produção. 

O repositório será dividido em duas frentes principais:
* **Branch `main` (Produção):** É o ambiente de produção. Contém apenas o código testado, estável e aprovado. É a partir desta branch que serão gerados os instaladores do aplicativo (APK/AAB para Android e IPA para iOS).
* **Branch `develop` (Desenvolvimento):** É o ambiente de homologação e integração. Todos os novos recursos, correções de bugs e testes são agrupados aqui antes de irem para a branch principal.

**Por que essa abordagem foi escolhida?**
Escolhemos essa abordagem porque ela protege o código principal do aplicativo. Se um integrante da equipe fizer um código com erro, ele quebrará apenas a branch de desenvolvimento, mantendo a versão de produção intacta e sempre pronta para distribuição.

## 2. Gerenciamento de Arquivos

### Quais arquivos são apenas de desenvolvimento?
* Toda a pasta `docs/` (planejamento, rascunhos de fluxo e evidências).
* Códigos de testes automatizados e testes de interface.
* Arquivos de configuração de ambiente local.
* Dependências de desenvolvimento no arquivo do Flutter.

### Quais arquivos devem ir para produção?
Para o ambiente de produção (lojas de aplicativos), irão apenas:
* O código-fonte final compilado (`src/`).
* Os assets do aplicativo (ícones, imagens e fontes usadas na interface).

### Como evitamos a publicação de arquivos indevidos?
Para garantir que documentos internos, testes, rascunhos, senhas ou arquivos sensíveis (como chaves de API) não sejam publicados junto com o sistema final, a equipe utilizará rigorosamente o arquivo **`.gitignore`**. 

O `.gitignore` será configurado para ocultar pastas de cache, chaves locais e rascunhos, impedindo que o Git rastreie e envie esses dados para o GitHub. Além disso, a documentação será mantida estritamente dentro da pasta `docs/`, que nunca é empacotada na compilação do Flutter.