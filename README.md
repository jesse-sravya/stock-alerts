# Stock Alerts
Fetch currency updates using a cron and notify subscribed users.
Download and import the postman collection to view api usage

## Modules
1. Rails app - ruby 3.0.0, rails 6.0.6.1
2. Postgres
3. Rake tasks with crontab (runs every 1 minute)

---
## Docker setup
```
$  docker-compose up --build
```

## To Be Done
- optimise external API calls
- move cron based price fetching to websocket based price fetching
- add documentation for api endpoints, move away from postman collection
- move notifications from console log to email / sms notifications
- use queues for processing notifications
