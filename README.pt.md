<div align="center">

<img src="https://img.shields.io/badge/Flutter-3.44.0-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
<img src="https://img.shields.io/badge/Dart-SDK%20^3.12.0-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
<img src="https://img.shields.io/badge/Riverpod-2.6.1-08479E?style=for-the-badge" alt="Riverpod">
<img src="https://img.shields.io/badge/Architecture-MVVM%20%2B%20Clean%20%2B%20Feature--First-green?style=for-the-badge" alt="Architecture">

</div>

<br>

<p align="center">
<strong>Idioma:</strong>
<a href="README.md">English</a> | <strong>Português</strong>
</p>

<h1 align="center">Catch the Cat</h1>

<p align="center">
  Um jogo de estratégia em grade hexagonal — coloque barreiras e encurrale o gato antes que ele escape.
  <br><br>
  <a href="https://github.com/dariomatias-dev/catch_the_cat_app/issues">Reportar Bug</a> ·
  <a href="https://github.com/dariomatias-dev/catch_the_cat_app/issues">Solicitar Funcionalidade</a>
</p>

---

## Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Como Jogar](#como-jogar)
- [Níveis de Dificuldade](#níveis-de-dificuldade)
- [Arquitetura](#arquitetura)
- [Estrutura de Pastas](#estrutura-de-pastas)
- [Tecnologias](#tecnologias)
- [Como Executar](#como-executar)
- [Autores](#autores)

---

## Sobre o Projeto

Catch the Cat é um jogo de estratégia para um jogador em uma grade hexagonal de 11×11. A cada turno o jogador coloca uma barreira; o computador então move o gato um passo em direção à rota de fuga mais próxima. O jogador vence cercando completamente o gato; o computador vence se o gato alcançar a borda do tabuleiro.

O jogo registra vitórias e derrotas entre sessões e oferece três níveis de dificuldade que afetam tanto a configuração inicial do tabuleiro quanto o comportamento da IA do gato.

---

## Como Jogar

1. Toque em uma célula vazia para colocar uma barreira.
2. O gato responde imediatamente, movendo-se um passo em direção à melhor rota de fuga.
3. Continue colocando barreiras para reduzir os caminhos de fuga do gato.
4. **Jogador vence** — o gato é cercado sem movimentos válidos.
5. **Gato vence** — o gato alcança a borda do tabuleiro.

---

## Níveis de Dificuldade

| Nível   | Barreiras Iniciais | Posição Inicial do Gato | Comportamento da IA                                                                                    |
| ------- | ------------------ | ----------------------- | ------------------------------------------------------------------------------------------------------ |
| Fácil   | 6 – 10             | Aleatória               | Move para uma célula vazia aleatória                                                                   |
| Médio   | 9 – 15             | Região central          | Segue o caminho de fuga mais curto                                                                     |
| Difícil | 12 – 16            | Centro fixo (5,5)       | Maximiza a distância de fuga — escolhe a célula de bloqueio que mais aumenta o caminho de fuga do gato |

---

## Arquitetura

O projeto aplica três padrões complementares:

```
Feature-First  →  organização de pastas por domínio de negócio
Clean Arch     →  regras explícitas de dependência entre camadas
MVVM           →  UI e lógica de apresentação desacopladas
```

Fluxo de dados dentro de cada feature:

```
Screen → Provider → ViewModel → Repository (contrato) → RepositoryImpl → DataSource
```

A camada de domínio (`entities`, `repositories`, `services`) é Dart puro sem dependências externas. A UI nunca acessa persistência ou lógica de IA diretamente.

---

## Estrutura de Pastas

```text
lib/src/
├── core/
│   ├── providers/        # Providers globais (áudio, SharedPreferences)
│   ├── services/         # AudioService
│   └── theme/            # Cores e tema da aplicação
└── features/
    └── game/
        ├── data/         # Implementações dos repositórios
        ├── di/           # Injeção de dependência (providers Riverpod)
        ├── domain/
        │   ├── entities/ # CellState, Difficulty, GameResult, Position
        │   ├── repositories/
        │   └── services/ # BoardService (BFS pathfinding), CpuAiService
        └── presentation/
            ├── providers/    # GameProvider (Notifier)
            ├── screens/      # GameScreen
            ├── view_models/  # GameStateViewModel
            └── widgets/      # Tabuleiro, células, cabeçalho, painel de pontuação, banner de status
```

---

## Tecnologias

| Tecnologia         | Versão  | Função                                 |
| ------------------ | ------- | -------------------------------------- |
| Flutter            | 3.44.0  | Framework de UI                        |
| Dart SDK           | ^3.12.0 | Linguagem                              |
| flutter_riverpod   | 2.6.1   | Gerenciamento de estado e DI           |
| audioplayers       | 6.7.0   | Música de fundo e efeitos sonoros      |
| shared_preferences | 2.5.5   | Armazenamento persistente de pontuação |

---

## Como Executar

### Pré-requisitos

- [FVM](https://fvm.app) instalado
- Flutter `3.44.0` gerenciado via FVM

### Instalação

```bash
# Clonar o repositório
git clone https://github.com/dariomatias-dev/catch_the_cat_app.git

# Entrar no diretório do projeto
cd catch_the_cat_app

# Instalar a versão correta do Flutter
fvm install

# Instalar dependências
fvm flutter pub get

# Executar o app
fvm flutter run
```

### Plataformas Suportadas

Android · Web · Desktop

---

## Autores

**Alison Andrade**

- GitHub: [https://github.com/AlisonAndrade123](https://github.com/AlisonAndrade123)
- LinkedIn: [https://www.linkedin.com/in/alison-andrade-b23621308/](https://www.linkedin.com/in/alison-andrade-b23621308/)

**Dário Matias**

- GitHub: [https://github.com/dariomatias-dev](https://github.com/dariomatias-dev)
- LinkedIn: [https://linkedin.com/in/dariomatias-dev](https://linkedin.com/in/dariomatias-dev)

**José Arthur Almeida**

- GitHub: [https://github.com/JoseArthurAlmeida](https://github.com/JoseArthurAlmeida)
- LinkedIn: [https://www.linkedin.com/in/jose-arthur-araujo-almeida/](https://www.linkedin.com/in/jose-arthur-araujo-almeida/)
