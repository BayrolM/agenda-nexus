import { Router } from 'express';
import { ServicesController } from '../controllers/services.controller.js';
import { authMiddleware } from '../middleware/auth.middleware.js';

const router = Router();
const servicesController = new ServicesController();

// All routes require authentication
router.use(authMiddleware);

router.get('/:companyId', (req, res) => servicesController.getByCompanyId(req, res));
router.get('/detail/:id', (req, res) => servicesController.getById(req, res));
router.post('/', (req, res) => servicesController.create(req, res));
router.put('/:id', (req, res) => servicesController.update(req, res));
router.delete('/:id', (req, res) => servicesController.delete(req, res));

export default router;
