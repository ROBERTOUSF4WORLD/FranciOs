# 🚀 Guia de Instalação e Build — FranciOS

Este documento explica **tudo que você precisa instalar no seu computador** para rodar o
FranciOS em modo de desenvolvimento e, no fim, gerar um **APK instalável no celular Android**.

> Escrito para quem está começando do zero. Siga na ordem.

---

## 1. Visão geral do que compõe o app

| Parte | Tecnologia | Pasta |
|-------|-----------|-------|
| App mobile (front-end) | Flutter (Dart) | `app/` |
| Back-end (lógica/IA) | Cloud Functions (Node.js 20 + TypeScript) | `backend/functions/` |
| Banco de dados + regras | Firebase (Firestore, Auth, Storage) | `firebase/` |

Para gerar o **APK** você precisa apenas da parte Flutter (`app/`) + a conexão com o Firebase.
O back-end roda na nuvem (Firebase) — não vai dentro do APK.

---

## 2. Programas que você precisa INSTALAR (na ordem)

### 2.1. Git
Para baixar o projeto.
- Windows: https://git-scm.com/download/win
- Verifique: `git --version`

### 2.2. Flutter SDK (obrigatório)
É o motor do app.
1. Baixe em: https://docs.flutter.dev/get-started/install
2. Extraia (ex.: `C:\src\flutter`) e adicione `flutter\bin` ao PATH do Windows.
3. Verifique: `flutter --version` (precisa ser Flutter 3.x, Dart >= 3.3.0)

### 2.3. Android Studio (obrigatório para gerar APK)
Traz o Android SDK, emulador e ferramentas de build.
1. Baixe: https://developer.android.com/studio
2. Na primeira execução, deixe instalar: **Android SDK**, **SDK Platform-Tools**, **build-tools** e um **emulador** (opcional).
3. Aceite as licenças do Android rodando:
   ```
   flutter doctor --android-licenses
   ```

### 2.4. Node.js 20 (só se você for mexer no back-end)
- Baixe a versão 20 LTS: https://nodejs.org
- Verifique: `node --version` (deve mostrar v20.x)

### 2.5. Firebase CLI + FlutterFire CLI (obrigatório para conectar o app ao Firebase)
```
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```
Depois faça login: `firebase login`

### 2.6. Confirme que está tudo certo
```
flutter doctor
```
Todos os itens principais (Flutter, Android toolchain) devem aparecer com ✓.

---

## 3. Baixar o projeto

```
git clone https://github.com/ROBERTOUSF4WORLD/FranciOs.git
cd FranciOs
```

---

## 4. Gerar os arquivos nativos do Android ⚠️ IMPORTANTE

O repositório ainda **não contém** a pasta `app/android/` (arquivos nativos).
O Flutter cria isso automaticamente. Dentro da pasta `app/`:

```
cd app
flutter create .
```

Isso cria `android/`, `ios/`, etc. **sem apagar** o código já existente em `lib/`.

> Sugestão: defina um nome de pacote (applicationId) próprio depois, ex.: `com.francios.app`.

---

## 5. Instalar dependências do app

Ainda dentro de `app/`:
```
flutter pub get
```

---

## 6. Conectar o app ao Firebase (cria o firebase_options.dart faltante)

Hoje **falta** o arquivo `app/lib/firebase_options.dart` — sem ele o app não conecta.

1. Crie um projeto no Firebase Console: https://console.firebase.google.com
2. Ative **Authentication (Email/Senha)**, **Firestore** e **Storage**.
3. Dentro da pasta `app/`, rode:
   ```
   flutterfire configure
   ```
   Selecione seu projeto e a plataforma Android. Isso gera `lib/firebase_options.dart`
   e o `android/app/google-services.json` automaticamente.

---

## 7. Rodar em modo DEBUG (teste rápido)

Com o celular conectado por USB (com "Depuração USB" ligada) OU um emulador aberto:
```
flutter devices        # confirma que o aparelho aparece
flutter run            # instala e roda o app em modo debug
```

---

## 8. Gerar o APK instalável 📱

Dentro da pasta `app/`:

**APK único (mais simples de compartilhar):**
```
flutter build apk --release
```
O arquivo sai em:
```
app/build/app/outputs/flutter-apk/app-release.apk
```

Copie esse `.apk` para o celular e instale (é preciso permitir "instalar de fontes desconhecidas").

**APKs otimizados por arquitetura (menores):**
```
flutter build apk --split-per-abi
```

> Para publicar na Play Store futuramente use `flutter build appbundle` (gera um `.aab`).

---

## 9. (Opcional) Rodar/implantar o back-end

Dentro de `backend/functions/`:
```
npm install          # instala dependências
npm run build        # compila o TypeScript
npm test             # roda os testes (Jest)
```

Para implantar na nuvem (a partir da raiz do projeto, onde está o firebase.json):
```
firebase deploy --only functions
firebase deploy --only firestore:rules
```

Para testar localmente sem gastar nuvem, use os emuladores:
```
firebase emulators:start
```

---

## 10. Resumo do caminho mais curto (só o APK)

```
git clone https://github.com/ROBERTOUSF4WORLD/FranciOs.git
cd FranciOs/app
flutter create .
flutter pub get
flutterfire configure          # cria firebase_options.dart
flutter build apk --release    # gera o APK
```

Arquivo final: `app/build/app/outputs/flutter-apk/app-release.apk`

---

### Checklist rápido de instalação
- [ ] Git
- [ ] Flutter SDK (3.x) no PATH
- [ ] Android Studio + Android SDK + licenças aceitas
- [ ] Node.js 20 (opcional, só back-end)
- [ ] Firebase CLI + FlutterFire CLI
- [ ] `flutter doctor` sem erros críticos
- [ ] Projeto criado no Firebase Console
