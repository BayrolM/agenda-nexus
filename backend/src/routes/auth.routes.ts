import { Router } from 'express';
import { AuthController } from '../controllers/auth.controller.js';
import { authMiddleware } from '../middleware/auth.middleware.js';

const router = Router();
const authController = new AuthController();

router.post('/login', (req, res) => authController.signIn(req, res));
router.post('/register', (req, res) => authController.signUp(req, res));
router.post('/verify-email', (req, res) => authController.verifyEmail(req, res));
router.post('/resend-code', (req, res) => authController.resendCode(req, res));
router.get('/profile', authMiddleware, (req, res) => authController.getProfile(req, res));

export default router;
