import crypto from 'crypto';
import { supabase } from '../config/supabase.js';

const CODE_LENGTH = 6;
const CODE_EXPIRY_MINUTES = 15;

export class VerificationService {
  async generatePendingCode(
    email: string,
    passwordHash: string,
    fullName: string,
  ): Promise<{ pendingId: string; code: string }> {
    const code = this._generateNumericCode();

    const expiresAt = new Date();
    expiresAt.setMinutes(expiresAt.getMinutes() + CODE_EXPIRY_MINUTES);

    // Delete any existing pending registration for this email
    await supabase
      .from('pending_registrations')
      .delete()
      .eq('email', email);

    const { data, error } = await supabase
      .from('pending_registrations')
      .insert({
        email,
        password_hash: passwordHash,
        full_name: fullName,
        code,
        expires_at: expiresAt.toISOString(),
        verified: false,
      })
      .select()
      .single();

    if (error) throw error;
    return { pendingId: data.id, code };
  }

  async verifyPendingCode(
    pendingId: string,
    code: string,
  ): Promise<{ email: string; passwordHash: string; fullName: string } | null> {
    const { data: record, error: fetchError } = await supabase
      .from('pending_registrations')
      .select('*')
      .eq('id', pendingId)
      .eq('code', code)
      .eq('verified', false)
      .single();

    if (fetchError || !record) {
      return null;
    }

    if (new Date(record.expires_at) < new Date()) {
      return null;
    }

    // Mark as verified
    const { error: updateError } = await supabase
      .from('pending_registrations')
      .update({ verified: true })
      .eq('id', record.id);

    if (updateError) throw updateError;

    return {
      email: record.email,
      passwordHash: record.password_hash,
      fullName: record.full_name,
    };
  }

  async getPendingRegistration(pendingId: string) {
    const { data, error } = await supabase
      .from('pending_registrations')
      .select('id, email, full_name, expires_at')
      .eq('id', pendingId)
      .single();

    if (error || !data) return null;
    return data;
  }

  async resendPendingCode(pendingId: string): Promise<string | null> {
    const { data: record, error: fetchError } = await supabase
      .from('pending_registrations')
      .select('*')
      .eq('id', pendingId)
      .eq('verified', false)
      .single();

    if (fetchError || !record) return null;

    const code = this._generateNumericCode();
    const expiresAt = new Date();
    expiresAt.setMinutes(expiresAt.getMinutes() + CODE_EXPIRY_MINUTES);

    const { error: updateError } = await supabase
      .from('pending_registrations')
      .update({ code, expires_at: expiresAt.toISOString() })
      .eq('id', record.id);

    if (updateError) throw updateError;
    return code;
  }

  // Legacy methods for existing users (if needed)
  async generateCode(userId: string): Promise<string> {
    const code = this._generateNumericCode();

    const expiresAt = new Date();
    expiresAt.setMinutes(expiresAt.getMinutes() + CODE_EXPIRY_MINUTES);

    const { error } = await supabase
      .from('email_verifications')
      .insert({
        user_id: userId,
        code,
        expires_at: expiresAt.toISOString(),
        verified: false,
      });

    if (error) throw error;
    return code;
  }

  async verifyCode(userId: string, code: string): Promise<boolean> {
    const { data: record, error: fetchError } = await supabase
      .from('email_verifications')
      .select('*')
      .eq('user_id', userId)
      .eq('code', code)
      .eq('verified', false)
      .order('created_at', { ascending: false })
      .limit(1)
      .single();

    if (fetchError || !record) {
      return false;
    }

    if (new Date(record.expires_at) < new Date()) {
      return false;
    }

    const { error: updateError } = await supabase
      .from('email_verifications')
      .update({ verified: true })
      .eq('id', record.id);

    if (updateError) throw updateError;

    const { error: userError } = await supabase
      .from('users')
      .update({ email_verified: true })
      .eq('id', userId);

    if (userError) throw userError;

    return true;
  }

  private _generateNumericCode(): string {
    const bytes = crypto.randomBytes(4);
    const num = bytes.readUInt32BE(0);
    return String(num % 1_000_000).padStart(CODE_LENGTH, '0');
  }
}
