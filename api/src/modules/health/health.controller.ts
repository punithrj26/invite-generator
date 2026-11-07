import { Controller, Get } from '@nestjs/common';

import { Public } from '../../common/auth/decorators';

/** ALB liveness probe. Deliberately no DB call: a Mongo blip must not make ECS kill healthy tasks. */
@Public()
@Controller('health')
export class HealthController {
  @Get()
  check() {
    return { status: 'ok' };
  }
}
