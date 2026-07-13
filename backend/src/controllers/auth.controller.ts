import { Request, Response } from 'express';
import { AuthService } from '../services/auth.service.js';
import { AuthRequest } from '../middleware/auth.middleware.js';

const authService = new AuthService();

export class AuthController {
  async signIn(req: Request, res: Response) {
    try {
      const { email, password } = req.body;

      if (!email || !password) {
        res.status(400).json({ error: 'Correo y contrasena son requeridos' });
        return;
      }

      const result = await authService.signIn(email, password);
      res.json(result);
    } catch (error: any) {
      console.error('Sign in error:', error.message);
      res.status(401).json({ error: error.message || 'Credenciales invalidas' });
    }
  }

  async signUp(req: Request, res: Response) {
    try {
      const { email, password, fullName } = req.body;

      if (!email || !password || !fullName) {
        res.status(400).json({ error: 'Correo, contrasena y nombre son requeridos' });
        return;
      }

      const result = await authService.signUp(email, password, fullName);
      res.json(result);
    } catch (error: any) {
      console.error('Sign up error:', error.message);
      res.status(400).json({ error: error.message || 'Error al registrar' });
    }
  }

  async verifyEmail(req: Request, res: Response) {
    try {
      const { pendingId, code } = req.body;

      if (!pendingId || !code) {
        res.status(400).json({ error: 'pendingId y code son requeridos' });
        return;
      }

      const result = await authService.verifyEmail(pendingId, code);
      res.json(result);
    } catch (error: any) {
      console.error('Verify email error:', error.message);
      res.status(400).json({ error: error.message || 'Error al verificar' });
    }
  }

  async resendCode(req: Request, res: Response) {
    try {
      const { pendingId } = req.body;

      if (!pendingId) {
        res.status(400).json({ error: 'pendingId es requerido' });
        return;
      }

      const result = await authService.resendVerificationCode(pendingId);
      res.json(result);
    } catch (error: any) {
      console.error('Resend code error:', error.message);
      res.status(400).json({ error: error.message || 'Error al reenviar codigo' });
    }
  }

  async getProfile(req: AuthRequest, res: Response) {
    try {
      const profile = await authService.getUserProfile(req.userId!);
      res.json(profile);
    } catch (error: any) {
      console.error('Get profile error:', error);
      res.status(404).json({ error: 'Perfil no encontrado' });
    }
  }
}
