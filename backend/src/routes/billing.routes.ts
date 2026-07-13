import { Router } from 'express';
import { BillingController } from '../controllers/billing.controller.js';
import { authMiddleware } from '../middleware/auth.middleware.js';

const router = Router();
const billingController = new BillingController();

// All routes require authentication
router.use(authMiddleware);

router.get('/pending', (req, res) => billingController.getPending(req, res));
router.get('/range', (req, res) => billingController.getByDateRange(req, res));
router.post('/mark-overdue', (req, res) => billingController.markOverdue(req, res));
router.post('/', (req, res) => billingController.create(req, res));
router.put('/:id', (req, res) => billingController.update(req, res));
router.delete('/:id', (req, res) => billingController.delete(req, res));

export default router;
