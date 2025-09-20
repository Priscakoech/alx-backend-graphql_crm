#!/bin/bash
# clean_inactive_customers.sh
# This script deletes customers with no orders in the last year
# and logs the number of deletions.

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Run Django shell command to delete inactive customers
count=$(echo "
from crm.models import Customer, Order
from django.utils.timezone import now
from datetime import timedelta

one_year_ago = now() - timedelta(days=365)
inactive = Customer.objects.exclude(order__order_date__gte=one_year_ago)
deleted, _ = inactive.delete()
print(deleted)
" | python manage.py shell)

# Log deletions with timestamp
echo "$TIMESTAMP - Deleted $COUNT inactive customers" >> /tmp/customer_cleanup_log.txt
