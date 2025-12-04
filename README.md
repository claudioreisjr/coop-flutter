# ☕ Coffee Break Check-in App

Aplicativo desenvolvido para confirmar presença em um evento de Coffee Break e consultar a previsão do tempo via geolocalização.

### 📱 Sobre o Projeto

<p align="center">
  <img src="https://github.com/claudioreisjr/coop-flutter/blob/main/print/page_clima.jpeg" width="230" alt="Tela Clima" />
  <img src="https://github.com/claudioreisjr/coop-flutter/blob/main/print/page_evento.jpeg" width="230" alt="Tela Eventos" />
</p>

Este aplicativo foi desenvolvido utilizando Flutter, com foco em duas funcionalidades principais:

✔️ 1. Confirmação de Presença

O usuário acessa a página de Coffee Break e confirma sua participação no evento.
Ideal para eventos internos, encontros corporativos e reuniões acadêmicas.

🌤️ 2. Clima por Geolocalização

O app utiliza a geolocalização do dispositivo para obter latitude e longitude e, em seguida, consulta a API pública Open-Meteo para exibir:
- Temperatura atual
- Previsão de temperatura para os próximos 7 dias

### 🔧 Tecnologias Utilizadas
- Flutter 3.x
- Dart
- Open-Meteo API
- Geolocator (GPS)
- HTTP Package

### 🏗️ Build do APK
O build do APK para Android foi gerado com sucesso usando o comando:
```bash
flutter build apk --release
```

O arquivo final se encontra em:
/build/app/outputs/flutter-apk/app-release.apk<br>

O APK está pronto para instalação em dispositivos Android.

### 🚀 Como Executar o Projeto
1. Clone o repositório
```bash
git clone https://github.com/claudioreisjr/coop-flutter.git
```
2. Instale as dependências
```bash
flutter pub get
```
3. Execute no emulador ou dispositivo físico
```bash
flutter run
```
#### 🌐 API de Clima (Open-Meteo)

A consulta ao clima utiliza a URL:
https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&current_weather=true

📍 Permissões necessárias

O app solicita:<br>
- Acesso à localização (para consultar o clima)

#### 📦 Estrutura Simplificada do Projeto

/lib<br>
 ├── main.dart<br>
 ├── pages/<br>
 │    ├── clima_page.dart<br>
 │    └── eventos_page.dart<br>
 ├── services/<br>
 │    ├── clima_service.dart
