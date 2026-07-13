import { Response } from 'express';
import { ServicesService } from '../services/services.service.js';
import { AuthRequest } from '../middleware/auth.middleware.js';

const servicesService = new ServicesService();

export class ServicesController {
  async getByCompanyId(req: AuthRequest, res: Response) {
    try {
      const services = await servicesService.getByCompanyId(req.params.companyId as string);
      res.json(services);
    } catch (error: any) {
      console.error('Get services error:', error);
      res.status(500).json({ error: error.message });
    }
  }

  async getById(req: AuthRequest, res: Response) {
    try {
      const service = await servicesService.getById(req.params.id as string);
      res.json(service);
    } catch (error: any) {
      console.error('Get service error:', error);
      res.status(404).json({ error: 'Service not found' });
    }
  }

  async create(req: AuthRequest, res: Response) {
    try {
      const { companyId, serviceType, name, url, username, password, apiKey, expirationDate, monthlyCost, notes } = req.body;

      if (!companyId || !serviceType || !name) {
        res.status(400).json({ error: 'companyId, serviceType, and name are required' });
        return;
      }

      const service = await servicesService.create({
        company_id: companyId,
        service_type: serviceType,
        service_name: name,
        url,
        username,
        password,
        api_key: apiKey,
        expiration_date: expirationDate,
        monthly_cost: monthlyCost,
        notes,
      });

      res.status(201).json(service);
    } catch (error: any) {
      console.error('Create service error:', error);
      res.status(400).json({ error: error.message });
    }
  }

  async update(req: AuthRequest, res: Response) {
    try {
      const service = await servicesService.update(req.params.id as string, req.body);
      res.json(service);
    } catch (error: any) {
      console.error('Update service error:', error);
      res.status(400).json({ error: error.message });
    }
  }

  async delete(req: AuthRequest, res: Response) {
    try {
      await servicesService.delete(req.params.id as string);
      res.status(204).send();
    } catch (error: any) {
      console.error('Delete service error:', error);
      res.status(400).json({ error: error.message });
    }
  }
}
