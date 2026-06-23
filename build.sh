#!/bin/bash
# Build automatizado APK + AAB - Beto Cat Escapes
# Usa AdMob (IDs já configurados)

set -e

echo "🐱 Beto Cat Escapes — Build"
echo "================================"

# Confere pré-requisitos
command -v node >/dev/null 2>&1 || { echo "❌ Node.js não encontrado. Instala: sudo apt install nodejs"; exit 1; }
command -v java >/dev/null 2>&1 || { echo "❌ Java não encontrado. Instala: sudo apt install openjdk-17-jdk"; exit 1; }
if [ -z "$ANDROID_HOME" ]; then
  echo "⚠️  ANDROID_HOME não setado. Veja README.md passo 4"
  exit 1
fi

echo "✅ Node: $(node --version)"
echo "✅ Java: $(java --version 2>&1 | head -1)"
echo ""

# Instala dependências
[ ! -d "node_modules" ] && { echo "📦 npm install..."; npm install; }

# Adiciona Android se não existir
if [ ! -d "android" ]; then
  echo "📱 Adicionando plataforma Android..."
  npx cap add android

  # Configura AdMob App ID no AndroidManifest.xml
  MANIFEST="android/app/src/main/AndroidManifest.xml"
  if [ -f "$MANIFEST" ]; then
    if ! grep -q "com.google.android.gms.ads.APPLICATION_ID" "$MANIFEST"; then
      sed -i '/<\/application>/i\
        <meta-data\
            android:name="com.google.android.gms.ads.APPLICATION_ID"\
            android:value="ca-app-pub-6497152814228418~7528960636"/>' "$MANIFEST"
      echo "✓ AdMob App ID inserido no AndroidManifest"
    fi
  fi
fi

# Sincroniza
echo "🔄 Sync..."
npx cap sync android

# Pergunta tipo de build
echo ""
echo "Qual tipo de build?"
echo "  1) APK debug (instalar e testar)"
echo "  2) APK release (distribuir, mas precisa assinar)"
echo "  3) AAB release (Play Store)"
echo ""
read -p "Escolha [1]: " BUILD_TYPE
BUILD_TYPE=${BUILD_TYPE:-1}

cd android
chmod +x ./gradlew

case "$BUILD_TYPE" in
  1)
    echo "🔨 Compilando APK debug..."
    ./gradlew assembleDebug
    OUT="app/build/outputs/apk/debug/app-debug.apk"
    ;;
  2)
    echo "🔨 Compilando APK release..."
    ./gradlew assembleRelease
    OUT="app/build/outputs/apk/release/app-release-unsigned.apk"
    ;;
  3)
    echo "🔨 Compilando AAB release..."
    ./gradlew bundleRelease
    OUT="app/build/outputs/bundle/release/app-release.aab"
    ;;
  *)
    echo "Opção inválida"; exit 1
    ;;
esac

cd ..

if [ -f "android/$OUT" ]; then
  SIZE=$(du -h "android/$OUT" | cut -f1)
  echo ""
  echo "✅ Build OK!"
  echo "📦 Arquivo: android/$OUT"
  echo "📏 Tamanho: $SIZE"

  if [ "$BUILD_TYPE" = "1" ]; then
    echo ""
    echo "📲 Pra instalar no celular USB:"
    echo "   adb install android/$OUT"
  fi
else
  echo "❌ Build falhou"
  exit 1
fi
