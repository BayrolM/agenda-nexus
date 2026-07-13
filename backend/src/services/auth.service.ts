import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import { supabase } from '../config/supabase.js';
import { VerificationService } from './verification.service.js';
import { EmailService } from './email.service.js';

const JWT_SECRET = process.env.JWT_SECRET || 'default-secret';

const verificationService = new VerificationService();
const emailService = new EmailService();

export class AuthService {
  async signIn(email: string, password: string) {
    const { data: user, error } = await supabase
      .from('users')
      .select('*')
      .eq('email', email)
      .single();

    if (error || !user) {
      throw new Error('Correo o contrasena incorrectos');
    }

    const valid = await bcrypt.compare(password, user.password);
    if (!valid) {
      throw new Error('Correo o contrasena incorrectos');
    }

    if (!user.email_verified) {
      throw new Error('Tu correo no ha sido verificado. Revisa tu bandeja de entrada.');
    }

    const token = jwt.sign(
      { userId: user.id, role: user.role },
      JWT_SECRET,
      { expiresIn: '30d' }
    );

    return {
      user: {
        id: user.id,
        email: user.email,
        full_name: user.full_name,
        role: user.role,
        email_verified: user.email_verified,
        created_at: user.created_at,
      },
      token,
    };
  }

  async signUp(email: string, password: string, fullName: string) {
    const { data: existing } = await supabase
      .from('users')
      .select('id')
      .eq('email', email)
      .single();

    if (existing) {
      throw new Error('Este correo ya esta registrado');
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const { data: user, error } = await supabase
      .from('users')
      .insert({
        email,
        password: hashedPassword,
        full_name: fullName,
        role: 'user',
        email_verified: false,
      })
      .select()
      .single();

    if (error) throw error;

    const code = await verificationService.generateCode(user.id);
    await emailService.sendVerificationCode(email, code, fullName);

    return {
      user: {
        id: user.id,
        email: user.email,
        full_name: user.full_name,
        role: user.role,
        email_verified: false,
        created_at: user.created_at,
      },
      requiresVerification: true,
    };
  }

  async verifyEmail(userId: string, code: string) {
    const success = await verificationService.verifyCode(userId, code);
    if (!success) {
      throw new Error('Codigo invalido o expirado');
    }
    return { verified: true };
  }

  async resendVerificationCode(userId: string) {
    const { data: user, error } = await supabase
      .from('users')
      .select('id, email, full_name, email_verified')
      .eq('id', userId)
      .single();

    if (error || !user) {
      throw new Error('Usuario no encontrado');
    }

    if (user.email_verified) {
      throw new Error('El correo ya esta verificado');
    }

    const code = await verificationService.generateCode(userId);

    try {
      await emailService.sendVerificationCode(user.email, code, user.full_name);
    } catch (emailError: any) {
      console.error('Warning: Could not resend verification email:', emailError.message);
      throw new Error('Error al enviar el correo. Intenta de nuevo.');
    }

    return { sent: true };
  }

  async getUserProfile(userId: string) {
    const { data, error } = await supabase
      .from('users')
      .select('id, email, full_name, role, email_verified, created_at')
      .eq('id', userId)
      .single();

    if (error) throw error;
    return data;
  }
}
