import { Router } from 'express';
import { CompaniesController } from '../controllers/companies.controller.js';
import { authMiddleware } from '../middleware/auth.middleware.js';

const router = Router();
const companiesController = new CompaniesController();

// All routes require authentication
router.use(authMiddleware);

router.get('/', (req, res) => companiesController.getAll(req, res));
router.get('/:id', (req, res) => companiesController.getById(req, res));
router.post('/', (req, res) => companiesController.create(req, res));
router.put('/:id', (req, res) => companiesController.update(req, res));
router.delete('/:id', (req, res) => companiesController.delete(req, res));

export default router;
