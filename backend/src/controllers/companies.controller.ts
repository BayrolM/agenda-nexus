import { Response } from 'express';
import { CompaniesService } from '../services/companies.service.js';
import { BillingService } from '../services/billing.service.js';
import { AuthRequest } from '../middleware/auth.middleware.js';

const companiesService = new CompaniesService();
const billingService = new BillingService();

export class CompaniesController {
  async getAll(_req: AuthRequest, res: Response) {
    try {
      const companies = await companiesService.getAll();
      res.json(companies);
    } catch (error: any) {
      console.error('Get companies error:', error);
      res.status(500).json({ error: error.message });
    }
  }

  async getById(req: AuthRequest, res: Response) {
    try {
      const company = await companiesService.getById(req.params.id as string);
      res.json(company);
    } catch (error: any) {
      console.error('Get company error:', error);
      res.status(404).json({ error: 'Company not found' });
    }
  }

  async create(req: AuthRequest, res: Response) {
    try {
      const { name, description, contactEmail, contactPhone, billingDay, billingAmount, currency, notes } = req.body;

      if (!name) {
        res.status(400).json({ error: 'Name is required' });
        return;
      }

      const company = await companiesService.create({
        user_id: req.userId!,
        name,
        description,
        contact_email: contactEmail,
        contact_phone: contactPhone,
        billing_day: billingDay,
        billing_amount: billingAmount,
        currency: currency || 'MXN',
        notes,
        is_active: true,
      });

      res.status(201).json(company);
    } catch (error: any) {
      console.error('Create company error:', error);
      res.status(400).json({ error: error.message });
    }
  }

  async update(req: AuthRequest, res: Response) {
    try {
      const companyId = req.params.id as string;

      const oldCompany = await companiesService.getById(companyId);

      const company = await companiesService.update(companyId, req.body);

      if (
        oldCompany.billing_day !== req.body.billingDay ||
        oldCompany.billing_amount !== req.body.billingAmount
      ) {
        if (req.body.billingDay != null) {
          await billingService.regenerateForCompany(
            companyId,
            req.body.billingDay,
            req.body.billingAmount ?? null,
          );
        } else {
          await billingService.deleteByCompanyId(companyId);
        }
      }

      res.json(company);
    } catch (error: any) {
      console.error('Update company error:', error);
      res.status(400).json({ error: error.message });
    }
  }

  async delete(req: AuthRequest, res: Response) {
    try {
      await companiesService.delete(req.params.id as string);
      res.status(204).send();
    } catch (error: any) {
      console.error('Delete company error:', error);
      res.status(400).json({ error: error.message });
    }
  }
}
