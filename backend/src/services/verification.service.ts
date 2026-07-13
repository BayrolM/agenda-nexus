import crypto from 'crypto';
import { supabase } from '../config/supabase.js';

const CODE_LENGTH = 6;
const CODE_EXPIRY_MINUTES = 15;

export class VerificationService {
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

  async getLatestCode(userId: string): Promise<{ code: string; expires_at: string } | null> {
    const { data, error } = await supabase
      .from('email_verifications')
      .select('code, expires_at')
      .eq('user_id', userId)
      .eq('verified', false)
      .order('created_at', { ascending: false })
      .limit(1)
      .single();

    if (error || !data) return null;
    return data;
  }

  async isEmailVerified(userId: string): Promise<boolean> {
    const { data, error } = await supabase
      .from('users')
      .select('email_verified')
      .eq('id', userId)
      .single();

    if (error || !data) return false;
    return data.email_verified;
  }

  private _generateNumericCode(): string {
    const bytes = crypto.randomBytes(4);
    const num = bytes.readUInt32BE(0);
    return String(num % 1_000_000).padStart(CODE_LENGTH, '0');
  }
}
