# Agenda Nexus

Aplicación móvil para gestionar empresas, sus servicios/cuentas y recordatorios de cobro.

## Stack Tecnológico

### Frontend (mobile/)
- **Flutter** 3.44+ / **Dart** 3.12+
- **Riverpod** - Estado
- **GoRouter** - Navegación
- **Supabase Flutter** - Cliente Supabase
- **flutter_local_notifications** - Notificaciones locales
- **table_calendar** - Calendario de cobros

### Backend (backend/)
- **Node.js** + **TypeScript**
- **Express** - Framework HTTP
- **Supabase JS** - Cliente Supabase
- **Zod** - Validación

### Base de Datos
- **Supabase** (PostgreSQL)

---

## Estructura del Proyecto

```
agenda-nexus/
├── mobile/                    # Frontend Flutter
│   ├── lib/
│   │   ├── core/              # Config, tema, router, servicios
│   │   ├── features/          # Auth, companies, services, billing
│   │   └── shared/            # Widgets reutilizables
│   ├── .env                   # Variables de entorno
│   └── pubspec.yaml
│
├── backend/                   # API Node.js
│   ├── src/
│   │   ├── config/            # Supabase client
│   │   ├── controllers/       # Lógica de cada endpoint
│   │   ├── middleware/        # Auth middleware
│   │   ├── routes/            # Definición de rutas
│   │   ├── services/          # Acceso a datos
│   │   └── types/             # Tipos TypeScript
│   ├── .env                   # Variables de entorno
│   └── package.json
│
└── README.md
```

---

## Configuración

### 1. Supabase

1. Crear proyecto en [supabase.com](https://supabase.com)
2. Ir a **SQL Editor** y ejecutar el schema:
   ```sql
   -- Ver backend/database/schema.sql
   ```
3. Ir a **Settings → API** y copiar:
   - **Project URL**
   - **anon public key**
   - **service_role key**

### 2. Frontend (Flutter)

```bash
cd mobile

# Configurar .env
# Editar mobile/.env con tus credenciales

# Instalar dependencias
flutter pub get

# Ejecutar
flutter run
```

**mobile/.env:**
```
SUPABASE_URL=https://TU-PROYECTO.supabase.co
SUPABASE_ANON_KEY=tu-anon-key
SUPABASE_ENV=development
```

### 3. Backend (Node.js)

```bash
cd backend

# Configurar .env
# Editar backend/.env con tus credenciales

# Instalar dependencias
npm install

# Desarrollo
npm run dev

# Producción
npm run build
npm start
```

**backend/.env:**
```
SUPABASE_URL=https://TU-PROYECTO.supabase.co
SUPABASE_SERVICE_ROLE_KEY=tu-service-role-key
PORT=3000
NODE_ENV=development
```

---

## Endpoints del Backend

### Auth
| Método | Ruta | Descripción |
|--------|------|-------------|
| POST | `/api/auth/login` | Iniciar sesión |
| POST | `/api/auth/register` | Registrar usuario |
| GET | `/api/auth/profile` | Obtener perfil |

### Companies
| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/companies` | Listar empresas |
| GET | `/api/companies/:id` | Detalle de empresa |
| POST | `/api/companies` | Crear empresa |
| PUT | `/api/companies/:id` | Actualizar empresa |
| DELETE | `/api/companies/:id` | Eliminar empresa |

### Services
| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/services/:companyId` | Servicios de una empresa |
| GET | `/api/services/detail/:id` | Detalle de servicio |
| POST | `/api/services` | Crear servicio |
| PUT | `/api/services/:id` | Actualizar servicio |
| DELETE | `/api/services/:id` | Eliminar servicio |

### Billing
| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/billing/pending` | Cobros pendientes |
| GET | `/api/billing/range?startDate=&endDate=` | Cobros por rango de fechas |
| POST | `/api/billing` | Crear recordatorio |
| PUT | `/api/billing/:id` | Actualizar recordatorio |
| DELETE | `/api/billing/:id` | Eliminar recordatorio |

---

## Funcionalidades

### Auth
- Registro de usuarios
- Login con email/password
- Perfil de usuario con rol (admin/user)

### Empresas
- CRUD completo de empresas
- Información de contacto
- Día y monto de cobro
- Notas adicionales

### Servicios
- Gestión de cuentas por empresa
- Tipos: Google, GitHub, Base de Datos, Hosting, Backend, Correo, Dominio, Otro
- Credenciales: URL, usuario, contraseña, API key
- Fecha de expiración
- Costo mensual

### Cobros
- Calendario visual de cobros
- Recordatorios pendientes
- Marcar como pagado
- Filtrado por rango de fechas

### Notificaciones
- Recordatorios locales al abrir la app
- Configuración de permisos

---

## Desarrollo

### Frontend
```bash
cd mobile
flutter run                    # Ejecutar en dispositivo/emulador
flutter analyze                # Verificar código
dart run build_runner build    # Generar código (freezed)
```

### Backend
```bash
cd backend
npm run dev                    # Desarrollo con hot-reload
npm run typecheck              # Verificar tipos
npm run build                  # Compilar para producción
```

---

## Licencia

Privado - Solo para uso interno.
