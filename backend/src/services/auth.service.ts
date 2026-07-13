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
    // Check if email already exists in users table
    const { data: existingUser } = await supabase
      .from('users')
      .select('id')
      .eq('email', email)
      .single();

    if (existingUser) {
      throw new Error('Este correo ya esta registrado');
    }

    // Hash password and store in pending_registrations (NOT in users yet)
    const hashedPassword = await bcrypt.hash(password, 10);

    const { pendingId, code } = await verificationService.generatePendingCode(
      email,
      hashedPassword,
      fullName,
    );

    // Send verification email
    await emailService.sendVerificationCode(email, code, fullName);

    return {
      pendingId,
      requiresVerification: true,
    };
  }

  async verifyEmail(pendingId: string, code: string) {
    // Verify the code against pending_registrations
    const pendingData = await verificationService.verifyPendingCode(pendingId, code);

    if (!pendingData) {
      throw new Error('Codigo invalido o expirado');
    }

    // Now create the user in users table
    const { data: user, error } = await supabase
      .from('users')
      .insert({
        email: pendingData.email,
        password: pendingData.passwordHash,
        full_name: pendingData.fullName,
        role: 'user',
        email_verified: true,
      })
      .select()
      .single();

    if (error) throw error;

    // Generate JWT token
    const token = jwt.sign(
      { userId: user.id, role: user.role },
      JWT_SECRET,
      { expiresIn: '30d' }
    );

    return {
      verified: true,
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

  async resendVerificationCode(pendingId: string) {
    const pending = await verificationService.getPendingRegistration(pendingId);

    if (!pending) {
      throw new Error('Registro no encontrado');
    }

    const code = await verificationService.resendPendingCode(pendingId);

    if (!code) {
      throw new Error('No se pudo reenviar el codigo');
    }

    try {
      await emailService.sendVerificationCode(pending.email, code, pending.full_name);
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
