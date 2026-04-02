# Claude Landing Kit

Skills e regras para criar landing pages profissionais com Claude Code — sem precisar saber programar.

## O que vem no kit

```
claude-landing-kit/
  commands/
    landing.md          ← skill principal: cria e edita landing pages
    landing-review.md   ← review automático sem poluir contexto
  project-template/
    CLAUDE.md           ← regras do projeto (tokens, DRY, SEO, etc.)
  setup.sh              ← instala tudo com um comando
  README.md             ← este arquivo
```

---

## Instalação (1 minuto)

### Pré-requisitos
- [Claude Code](https://claude.ai/code) instalado (`npm install -g @anthropic-ai/claude-code`)
- Node.js 18+ instalado
- Conta na [Vercel](https://vercel.com) (gratuita)

### Instalar as skills

```bash
# Clone o repositório
git clone https://github.com/[seu-usuario]/claude-landing-kit
cd claude-landing-kit

# Instala as skills no Claude Code
bash setup.sh
```

Pronto. As skills `/landing` e `/landing-review` estão disponíveis em qualquer projeto.

---

## Como usar

### Criar uma landing page do zero

```bash
# Crie uma pasta para o projeto (em qualquer lugar)
mkdir ~/minha-landing && cd ~/minha-landing

# Abra o Claude Code e chame a skill
claude
```

Dentro do Claude Code:
```
/landing crie uma landing page para X
```

Pronto. Não precisa copiar nenhum arquivo — as skills são globais.

---

### (Opcional) Reforçar regras para prompts livres

Se quiser que as regras de tokens e componentes valham mesmo em conversas sem usar a skill:

```bash
cp ~/claude-landing-kit/project-template/CLAUDE.md ~/meu-projeto/CLAUDE.md
```

Isso faz o Claude seguir as regras em qualquer mensagem, não só quando você chama `/landing`.

Dentro do Claude Code:

```
/landing crie uma landing page para um app de finanças pessoais chamado
"Finly". Cor roxa. Seções: hero, features (6 recursos), how it works
(3 passos), depoimentos, pricing (3 planos), FAQ, CTA final.
```

O Claude vai:
1. Scaffoldar o projeto Next.js completo
2. Criar o sistema de design tokens
3. Criar componentes compartilhados reutilizáveis
4. Construir todas as seções pedidas
5. Configurar dark mode, animações e responsividade
6. Te dar os comandos para rodar e fazer deploy

### Adicionar uma seção

```
/landing adicione uma seção de logos de clientes entre o hero e o features
```

### Melhorar o visual

```
/landing melhore os visuais — quero mais premium, mais espaço, animações mais suaves
```

### Fazer review de qualidade

```
/landing-review
```

Vai checar automaticamente (em paralelo, sem poluir o contexto):
- **Tokens**: algum valor hardcoded que deveria ser token?
- **DRY**: algum componente duplicado que deveria ser extraído?
- **SEO**: metadados, og tags, h1 único, alt text?
- **Performance & A11y**: images, fonts, lazy loading, aria labels?

---

## O sistema de qualidade (como funciona por baixo)

O kit usa **subagentes paralelos** para fazer reviews — isso significa que o Claude principal não "suja" seu contexto com logs de análise. Cada subagente roda de forma isolada, analisa os arquivos, e retorna só os problemas encontrados.

```
Você: /landing-review
      ↓
Claude dispara 4 subagentes em paralelo:
  [Agent 1] Tokens Audit  →  analisa tokens
  [Agent 2] DRY Audit     →  analisa componentes
  [Agent 3] SEO Audit     →  analisa metadados
  [Agent 4] Perf & A11y   →  analisa performance
      ↓
Claude coleta resultados e mostra tabela resumida
```

---

## Regras aplicadas automaticamente

Quando você copia o `CLAUDE.md` para seu projeto, o Claude segue estas regras em todas as interações:

| Regra | O que significa |
|-------|----------------|
| **Design Tokens** | Nenhum valor visual hardcoded (`bg-blue-500` → `bg-primary`) |
| **Component DRY** | Mesmo padrão em 2+ lugares → extrair componente compartilhado |
| **Tamanho de arquivo** | Seção > 120 linhas → decompor em sub-componentes |
| **page.tsx** | Só imports e ordem das seções (< 50 linhas) |
| **Animações** | Sempre com `viewport: { once: true }` |
| **Dark mode** | Sempre implementado, nunca opcional |
| **Imagens** | Sempre `next/image` com `width`, `height` e `alt` |
| **HTML semântico** | Exatamente um `<h1>`, seções com `<section>`, nav com `<nav>` |

---

## Stack usado

| Camada | Ferramenta |
|--------|-----------|
| Framework | Next.js 15 (App Router + TypeScript) |
| CSS | Tailwind CSS v4 |
| Componentes | shadcn/ui |
| Animações | motion/react |
| Ícones | Lucide React |
| Dark mode | next-themes |
| Deploy | Vercel |

---

## FAQ

**Preciso saber programar?**
Não. O Claude escreve todo o código. Você só precisa saber descrever o que quer e substituir os textos placeholder pelo conteúdo real.

**Como faço deploy?**
O Claude te dará os comandos ao final. Resumindo: `npx vercel --prod` ou importar o repositório no [vercel.com](https://vercel.com).

**Posso usar outra stack?**
Sim. Diga pro Claude qual stack você quer usar no início da conversa.

**Preciso do CLAUDE.md no projeto?**
Sim. Ele garante que o Claude siga as regras de tokens, DRY e qualidade durante toda a construção.

**Como atualizar o kit quando sair uma versão nova?**
```bash
git pull
bash setup.sh
```

---

## Contribuindo

PRs são bem-vindos para melhorar as skills, adicionar novos padrões de seção, ou corrigir regras que não funcionaram bem na prática.
