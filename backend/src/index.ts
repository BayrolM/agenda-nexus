import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';

import { supabase } from './config/supabase.js';
import authRoutes from './routes/auth.routes.js';
import companiesRoutes from './routes/companies.routes.js';
import servicesRoutes from './routes/services.routes.js';
import billingRoutes from './routes/billing.routes.js';
import { startReminderJob } from './jobs/reminder.job.js';

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Health check
app.get('/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/companies', companiesRoutes);
app.use('/api/services', servicesRoutes);
app.use('/api/billing', billingRoutes);

// Error handler
app.use((err: Error, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
  console.error('Unhandled error:', err);
  res.status(500).json({ error: 'Internal server error' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
  startReminderJob();
});

export { app, supabase };
