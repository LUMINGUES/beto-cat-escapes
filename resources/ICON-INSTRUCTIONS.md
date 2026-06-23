# 🎨 Como adicionar o ícone do app

## Opção 1: Manualmente (mais simples)

1. Baixa a imagem do ícone que você forneceu (PNG quadrado, mín. 512x512)
2. Salva como `resources/icon.png` aqui
3. Instala `capacitor-assets`:
   ```bash
   npm install -g @capacitor/assets
   ```
4. Gera todos os tamanhos automaticamente:
   ```bash
   npx @capacitor/assets generate --android
   ```
5. Sincroniza:
   ```bash
   npx cap sync android
   ```

Isso vai gerar todos os mipmap-* (ldpi, mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi) automaticamente em:
`android/app/src/main/res/mipmap-*/`

## Opção 2: Manual (sem ferramenta)

Cria essas versões da sua imagem em PNG e cola nos respectivos pastas:

| Pasta | Tamanho |
|---|---|
| `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` | 48x48 |
| `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` | 72x72 |
| `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` | 96x96 |
| `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` | 144x144 |
| `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` | 192x192 |

Site online pra gerar: https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html

## Splash screen (opcional)

Mesma coisa pro splash:
1. Salva `resources/splash.png` (2732x2732 com o logo centralizado)
2. Roda `npx @capacitor/assets generate --android`
