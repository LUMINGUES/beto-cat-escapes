# 🐱 Beto Cat Escapes — Build APK no Zorin/Ubuntu

Este projeto empacota o jogo HTML num APK Android usando **Capacitor**.

## 📋 Pré-requisitos pra Zorin (Ubuntu)

Abra o terminal e instale tudo:

### 1️⃣ Node.js + npm
```bash
# Atualiza repositórios
sudo apt update

# Instala Node.js 20 (versão LTS)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Confere versões
node --version    # deve mostrar v20.x
npm --version
```

### 2️⃣ Java JDK 17 (necessário pro Android Gradle Plugin)
```bash
sudo apt install -y openjdk-17-jdk

# Confere
java --version    # deve mostrar 17.x
```

### 3️⃣ Android SDK Command-Line Tools

```bash
# Cria pasta pro SDK
mkdir -p ~/Android/Sdk/cmdline-tools
cd ~/Android/Sdk/cmdline-tools

# Baixa as command-line tools (Linux)
wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip

# Extrai e renomeia
unzip commandlinetools-linux-*.zip
mv cmdline-tools latest
rm commandlinetools-linux-*.zip
```

### 4️⃣ Variáveis de ambiente

Adiciona no `~/.bashrc` (ou `~/.zshrc` se usar zsh):

```bash
echo '' >> ~/.bashrc
echo '# Android SDK' >> ~/.bashrc
echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.bashrc
echo 'export ANDROID_SDK_ROOT=$ANDROID_HOME' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc

# Recarrega
source ~/.bashrc
```

### 5️⃣ Aceitar licenças + instalar componentes
```bash
# Aceita todas as licenças
yes | sdkmanager --licenses

# Instala plataforma + build tools
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

---

## 🚀 Compilando o APK

### Passo 1: Entra no projeto
```bash
cd ~/Downloads/BetoCatEscapes   # ou onde você descompactou o zip
```

### Passo 2: Instala dependências
```bash
npm install
```

### Passo 3: Adiciona plataforma Android
```bash
npx cap add android
```

Isso cria a pasta `android/` com o projeto Android Studio nativo.

### Passo 4: Sincroniza o HTML pra dentro do projeto Android
```bash
npx cap sync android
```

### Passo 5: Compila o APK debug
```bash
cd android
chmod +x ./gradlew
./gradlew assembleDebug
```

O APK fica em:
```
android/app/build/outputs/apk/debug/app-debug.apk
```

### Passo 6 (opcional): APK release assinado
Pra publicar na Play Store ou compartilhar como release, precisa **assinar**:

```bash
# Gera uma keystore (faz 1 vez só, guarda em local seguro!)
keytool -genkey -v \
  -keystore ~/beto-cat.keystore \
  -alias beto-cat \
  -keyalg RSA -keysize 2048 -validity 10000

# Compila release
cd android
./gradlew assembleRelease

# Assina manualmente (se não configurar no build.gradle)
$ANDROID_HOME/build-tools/34.0.0/zipalign -v 4 \
  app/build/outputs/apk/release/app-release-unsigned.apk \
  app/build/outputs/apk/release/app-release-aligned.apk

$ANDROID_HOME/build-tools/34.0.0/apksigner sign \
  --ks ~/beto-cat.keystore \
  --out app/build/outputs/apk/release/app-release.apk \
  app/build/outputs/apk/release/app-release-aligned.apk
```

---

## 📱 Instalando no celular

### Via USB (modo desenvolvedor)
```bash
# Ativa modo desenvolvedor no celular (toque 7x em "Número da build" em Configurações > Sobre)
# Ativa "Depuração USB" em Opções do desenvolvedor
# Conecta o cabo USB

# Verifica se aparece
adb devices

# Instala o APK
adb install android/app/build/outputs/apk/debug/app-debug.apk
```

### Sem cabo
Manda o arquivo `.apk` por WhatsApp/Email/Bluetooth pra você mesmo, abre no celular, libera "instalar fontes desconhecidas" e instala.

---

## 🛠️ Editando o jogo

O jogo é o arquivo `www/index.html`. Pra atualizar:

1. Edita `www/index.html`
2. Roda `npx cap sync android` (copia o HTML novo pra dentro do Android)
3. Recompila: `cd android && ./gradlew assembleDebug`

---

## 🐛 Problemas comuns

**`sdkmanager: command not found`**  
Confira se rodou `source ~/.bashrc` e que o PATH tá certo:
```bash
echo $ANDROID_HOME
echo $PATH | tr ':' '\n' | grep Android
```

**`SDK location not found`**  
Cria o arquivo `android/local.properties`:
```
sdk.dir=/home/SEU_USUARIO/Android/Sdk
```

**`Gradle build failed - JVM version`**  
Capacitor 6 precisa JDK 17. Confere:
```bash
java --version
update-alternatives --config java   # escolhe o 17 se tiver outros
```

**APK não instala no celular**  
- Habilita "Fontes desconhecidas" nas Configurações de Segurança
- Se já existe versão instalada com mesma assinatura diferente, desinstala antes

**WebView não carrega o jogo**  
Confira que `www/index.html` existe e que rodou `npx cap sync android` antes de compilar.

---

## 📦 Estrutura do projeto

```
BetoCatEscapes/
├── www/
│   └── index.html         ← O jogo (HTML+Three.js+JS)
├── android/               ← Projeto Android Studio (criado pelo cap add)
│   └── app/build/outputs/apk/debug/app-debug.apk
├── capacitor.config.json  ← Config do Capacitor
├── package.json
└── README.md
```

---

## 🎮 Sobre o jogo

**Beto Cat Escapes** — Endless runner 3D do Beto (gato laranja) fugindo de um cachorro, estilo Subway Surfers. Atravessa 7 mundos temáticos (Egito, China, Brasil, Arábia, França, Londres, Japão) com música sinfônica diferente, inimigos por tema, sistema de 7 vidas, modo turbo (leitinho 🥛), modo garra (Fruit Ninja), e 3 power-ups (Capa 🦇, Laço 🎀, Laser 👁️) com slash na tela.

Idiomas: PT-BR, EN, ES.

**Desenvolvido por** José Lucas Domingues  
📧 lucas.domingues16@gmail.com  
🏢 Wolf Red Games
