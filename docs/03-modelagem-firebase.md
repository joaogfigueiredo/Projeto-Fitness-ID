#  Modelagem do Banco de Dados (Cloud Firestore)

**Projeto:** Fitness ID  
**Versão:** 1.0  
**Status:** Em Planejamento  
**Última atualização:** 16/07/2026

---

# 1. Objetivo

Este documento define a estrutura do banco de dados do projeto Fitness ID utilizando o Cloud Firestore.

Seu objetivo é garantir uma organização consistente dos dados, facilitar a manutenção da aplicação e permitir que o sistema cresça sem necessidade de grandes alterações estruturais.

---

# 2. Filosofia da Modelagem

O Firestore é um banco de dados NoSQL baseado em documentos.

Diferente de bancos relacionais, não utilizaremos tabelas e chaves estrangeiras.

Nossa modelagem seguirá os princípios:

- Baixo acoplamento
- Alta escalabilidade
- Leitura rápida
- Escritas simples
- Evitar consultas complexas
- Separação entre dados de configuração e dados do usuário
- Modelagem orientada à leitura (Read Optimized)
- Evitar duplicação desnecessária de dados

---

# 3. Estrutura Geral

O banco será organizado em coleções.

Coleções principais:

Coleções principais:

- users
- exerciseLibrary
- workoutTemplates
- exerciseLogs
- foodLibrary
- dietPlans
- checkIns
- plans
- subscriptions
- payments
- notifications

---

# 4. Coleção: users

Armazena todos os usuários do sistema.

Tipos:

- aluno
- coach
- administrador

Exemplo:

users/{userId}

Campos:

- id
- name
- email
- phone
- role
- photoUrl
- birthDate
- gender
- coachId
- height
- goal
- activityLevel
- createdAt
- updatedAt
- active

stats:

- currentWeight
- initialWeight
- workoutsCompleted
- currentStreak
- longestStreak
- totalVolume
- totalWorkouts
- lastWorkout
- lastCheckin

---

# 5. Coleção: workouts

Representa um treino criado pelo coach.

Exemplo:

workouts/{workoutId}

Campos:

- coachId
- studentId
- title
- description
- category
- createdAt
- updatedAt
- active

Subcoleção:

workouts/{workoutId}/exercises

Campos:

- exerciseId
- order
- sets
- reps
- rest
- notes

---

# 6 Coleção exerciseLibrary

Responsável por armazenar todos os exercícios disponíveis no sistema.

Essa coleção será utilizada por todos os coaches para montar treinos.

Campos:

- id
- name
- muscleGroup
- equipment
- difficulty
- instructions
- videoUrl
- imageUrl
- active

# 7. Histórico 

O sistema armazenará o histórico detalhado de todas as execuções dos exercícios.

A progressão de carga e repetições NÃO será armazenada.

Ela será calculada automaticamente a partir do histórico de execução.

Esses dados serão utilizados para gerar automaticamente:

- Evolução da carga
- Evolução das repetições
- Volume total levantado
- Frequência semanal
- Frequência mensal
- Recordes pessoais (PR)
- Estimativa de 1RM
- Tempo entre sessões
- Evolução por exercício

Esses indicadores serão apresentados ao aluno e ao coach através de gráficos e estatísticas.

# 8. Coleção: exercise_logs

Armazena o histórico completo da execução de cada exercício realizado pelo aluno.

Cada documento representa uma sessão de um exercício dentro de um treino.

Exemplo:

exercise_logs/{logId}

Campos:

- studentId
- coachId
- workoutId
- exerciseId
- exerciseName
- performedAt
- observations

Subcoleção:

sets/

Cada série executada será armazenada separadamente.

Campos:

- setNumber
- weight
- repetitions
- rir (opcional)
- rpe (opcional)
- completed
- restTime
---

# 9. Coleção: dietsPlan

Plano alimentar do aluno.

Campos:

- coachId
- studentId
- title
- calories
- protein
- carbohydrates
- fat
- createdAt

Subcoleção:

meals

Cada refeição possuirá:

- mealName
- foods
- macros

---

# 10 Coleção: foodLibrary

Biblioteca de alimentos utilizada em todos os planos alimentares.

Campos:

- id
- name
- calories
- protein
- carbohydrates
- fat
- category

# 11. Coleção: checkins

Histórico de check-ins.

Campos:

- studentId
- coachId
- date
- weight
- observations
- satisfaction
- sleep
- hunger
- energy
- progression
- waterIntake

Subcoleção:

photos

Tipos:

- front
- side
- back

Subcoleção:

feedback

Campos:

- text
- videoUrl
- createdAt

---

# 12. Coleção: subscriptions

Plano contratado pelo aluno.

Campos:

- studentId
- planName
- price
- planId
- status
- startDate
- renewalDate
- autoRenew

---

# 13. Coleção: payments

Histórico financeiro.

Campos:

- studentId
- subscriptionId
- amount
- paymentMethod
- status
- transactionId
- paidAt
- gateway
- currency
- receiptUrl

---

# 14. Coleção: notifications

Notificações enviadas ao usuário.

Campos:

- userId
- title
- message
- read
- createdAt

---

# 15. Upload de Arquivos

Os arquivos serão armazenados no Firebase Storage.

Estrutura prevista:

storage/

users/

photos/

videos/

checkins/

exercise_videos/

profile_photos/

---

# 16. Relacionamentos

Coach

↓

possui

↓

Alunos

↓

cada aluno possui

↓

Treinos

↓

cada treino possui

↓

Exercícios

↓

cada exercício gera

↓

Histórico

Aluno

↓

possui

↓

Plano Alimentar

↓

Check-ins

↓

Pagamentos

↓

Assinatura

---

# 17. Regras de Nomenclatura

Coleções:

Sempre em inglês.

Sempre no plural.

Exemplos:

users

workouts

payments

checkins

Campos:

Sempre em camelCase.

Exemplo:

createdAt

photoUrl

studentId

coachId

---

# 18. Campos Padrão

Sempre que possível os documentos possuirão:

id

createdAt

updatedAt

active

---

# 19. Estratégias de Escalabilidade

Sempre utilizar referências por ID.

Evitar documentos muito grandes.

Evitar arrays gigantes.

Utilizar subcoleções quando fizer sentido.

Separar arquivos do banco de dados.

Criar índices apenas quando necessários.

---

# 20. Segurança

O acesso será controlado pelas regras do Firestore.

Cada aluno poderá visualizar apenas seus próprios dados.

Cada coach poderá visualizar apenas os alunos vinculados.

Administradores possuirão acesso total.

Uploads serão protegidos pelas regras do Firebase Storage.

---

# 21. Evolução

O banco foi planejado para permitir futuras integrações:

- Google Fit
- Apple Health
- Smartwatch
- IA para recomendações
- Dashboard analítico
- Modo Offline

Sem necessidade de remodelagem completa.

---

# 22. Considerações Finais

A modelagem apresentada neste documento representa a primeira versão da estrutura do banco de dados.

Novas coleções poderão ser adicionadas conforme o sistema evoluir, sempre respeitando os princípios definidos neste documento.