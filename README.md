# 📱 Sistema de Evaluación TBC - App Móvil

Aplicación móvil nativa desarrollada en **Flutter** como extensión directa del portal web del Sistema de Evaluación TBC.

Esta aplicación fue diseñada para cumplir con los requerimientos del proyecto mediante la creación de un Web Service (API REST) en el backend y consumiéndolo de forma eficiente desde una interfaz móvil.

## ✨ Características Principales

- **Consumo de API REST:** Se conecta directamente al endpoint de producción alojado en Railway (`/api/alumnos/{matricula}`) mediante HTTP.
- **Diseño UI/UX:** Interfaz de usuario "pixel-perfect" que iguala la paleta de colores y el diseño moderno del portal web.
- **Visualización de Boleta:** Desglose completo de calificaciones parciales y cálculo visual del promedio general.
- **Manejo de Estados Complejo:** Indicadores de estado visuales dinámicos basados en la información de la base de datos.
- **Tratamiento de Datos en Tiempo Real:** Parseo de cadenas JSON a dobles para validaciones matemáticas en el lado del cliente y renderizado condicional de componentes.

## 🛠 Tecnologías Utilizadas

- **Framework:** Flutter SDK
- **Lenguaje:** Dart
- **Paquetes Externos:** `http` (v1.1.0) para peticiones asíncronas de red.

## Cómo ejecutar el proyecto

1. Asegúrate de tener el entorno de Flutter instalado y configurado correctamente.
2. Clona este repositorio local.
3. Instala las dependencias necesarias:
   ```bash
   flutter pub get
   ```
4. Ejecuta la aplicación en un dispositivo físico, emulador de Android/iOS o navegador Chrome:
   ```bash
   flutter run
   ```

