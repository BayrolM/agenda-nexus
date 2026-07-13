import { Response } from 'express';
import { BillingService } from '../services/billing.service.js';
import { AuthRequest } from '../middleware/auth.middleware.js';

const billingService = new BillingService();

export class BillingController {
  async getPending(_req: AuthRequest, res: Response) {
    try {
      const records = await billingService.getPending();
      res.json(records);
    } catch (error: any) {
      console.error('Get billing records error:', error);
      res.status(500).json({ error: error.message });
    }
  }

  async getByDateRange(req: AuthRequest, res: Response) {
    try {
      const { startDate, endDate } = req.query;

      if (!startDate || !endDate) {
        res.status(400).json({ error: 'startDate and endDate are required' });
        return;
      }

      const records = await billingService.getByDateRange(
        String(startDate),
        String(endDate)
      );
      res.json(records);
    } catch (error: any) {
      console.error('Get billing by date range error:', error);
      res.status(500).json({ error: error.message });
    }
  }

  async create(req: AuthRequest, res: Response) {
    try {
      const { companyId, reminderDate, amount, status } = req.body;

      if (!companyId || !reminderDate) {
        res.status(400).json({ error: 'companyId and reminderDate are required' });
        return;
      }

      const record = await billingService.create({
        company_id: companyId,
        reminder_date: reminderDate,
        amount,
        status: status || 'pending',
      });

      res.status(201).json(record);
    } catch (error: any) {
      console.error('Create billing record error:', error);
      res.status(400).json({ error: error.message });
    }
  }

  async update(req: AuthRequest, res: Response) {
    try {
      const record = await billingService.update(req.params.id as string, req.body);
      res.json(record);
    } catch (error: any) {
      console.error('Update billing record error:', error);
      res.status(400).json({ error: error.message });
    }
  }

  async delete(req: AuthRequest, res: Response) {
    try {
      await billingService.delete(req.params.id as string);
      res.status(204).send();
    } catch (error: any) {
      console.error('Delete billing record error:', error);
      res.status(400).json({ error: error.message });
    }
  }
}
