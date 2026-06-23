# 📱 Integração AdMob — Beto Cat Escapes

## ✅ IDs já configurados no projeto

| | ID |
|---|---|
| **App ID** | `ca-app-pub-6497152814228418~7528960636` |
| **Rewarded Ad Unit** | `ca-app-pub-6497152814228418/4902797291` |

Configurados em:
- `capacitor.config.json` (plugin AdMob - App ID)
- `www/index.html` (linha ~46-48 - constantes JS)
- `android/app/src/main/AndroidManifest.xml` (inserido pelo `build.sh` no primeiro `cap add`)

## 🎬 Como funciona

O HTML detecta automaticamente se tá rodando:
- **No navegador** → usa AdSense for Games (Web)
- **No APK** → usa AdMob nativo via plugin Capacitor

A função `window.adBreak()` foi sobrescrita pra rotear automaticamente:
- Tipo `'reward'` (continuar após morrer, desbloquear powerup) → **Rewarded Ad** do AdMob
- Tipo `'preroll'` / `'next'` (preroll de primeira partida, intersticial entre mortes, voltar ao menu) → **Interstitial Ad** do AdMob

## 🚧 Modo de teste habilitado

No HTML linha ~95: `isTesting: true`

Quando for pra **produção** (publicar), troca pra `isTesting: false` em todas as ocorrências dentro do bloco "🎬 Sobrescreve adBreak...".

E em `capacitor.config.json`, remove ou marca como false:
```json
"AdMob": {
  "appId": "ca-app-pub-6497152814228418~7528960636",
  "initializeForTesting": false
}
```

## 🧪 Testando o ad no APK

1. Compila APK debug com `./build.sh` (escolha 1)
2. Instala no celular: `adb install android/app/build/outputs/apk/debug/app-debug.apk`
3. Abre o app
4. Joga até morrer
5. Clica em "CONTINUAR · ver anúncio" — vai aparecer **anúncio teste do AdMob** (geralmente um vídeo curto com "Test Ad")
6. Após o ad, ganha o continue

Se aparecer "Test Ad" no canto da tela = está funcionando! Significa que o AdMob tá retornando ads de teste do Google.

## 🚀 Quando estiver pronto pra produção

1. **Verifica que o app foi aprovado** no AdMob console
2. No HTML, troca todos `isTesting: true` por `isTesting: false`
3. Recompila o APK release: `./build.sh` opção 2 ou 3
4. Publica na Play Store
5. Aguarda alguns dias pra começar a aparecer ads reais (AdMob calibra)

## ❓ Troubleshooting

**Ad não aparece no APK**
- Confere que `AdMob.initialize` foi chamado (veja logs com `adb logcat`)
- Confere App ID no AndroidManifest:
  ```bash
  grep APPLICATION_ID android/app/src/main/AndroidManifest.xml
  ```

**Erro "AdMob is not defined"**
- Roda `npx cap sync android` depois de qualquer mudança no HTML
- Confere que o plugin tá instalado: `npm ls @capacitor-community/admob`

**Build falha com "App ID missing"**
- AndroidManifest.xml precisa ter:
  ```xml
  <meta-data
      android:name="com.google.android.gms.ads.APPLICATION_ID"
      android:value="ca-app-pub-6497152814228418~7528960636"/>
  ```

**No emulador funciona, no celular não**
- Apps com AdMob NÃO funcionam em modo debug bem em todos os celulares. Tente release assinado.
