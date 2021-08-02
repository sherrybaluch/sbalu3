from django.contrib import admin

from .models import Inventory
from .models import User
from .models import Status
from .models import Transaction

class InventoryAdmin(admin.ModelAdmin):
    list_display = ['status', 'description', 'created_at', 'updated_at']

class UserAdmin(admin.ModelAdmin):
    list_display = ['first_name', 'last_name', 'email', 'password', 'created_at', 'updated_at', 'signed_agreement']

class StatusAdmin(admin.ModelAdmin):
    list_display = ['description', 'created_at', 'updated_at']

class TransactionAdmin(admin.ModelAdmin):
    list_display = ['user', 'inventory', 'checkout_time', 'scheduled_checkin_time', 'actual_checkin_time', 'created_at', 'updated_at']

admin.site.register(Inventory, InventoryAdmin)
admin.site.register(User, UserAdmin)
admin.site.register(Status, StatusAdmin)
admin.site.register(Transaction, TransactionAdmin)
