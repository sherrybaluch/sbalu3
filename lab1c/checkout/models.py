from django.db import models

class Status(models.Model):
    description = models.TextField()
    created_at  = models.DateTimeField()
    updated_at  = models.DateTimeField()
    class Meta:
        db_table = "status"

    def __str__(self):
        return self.description

class User(models.Model):
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    email = models.CharField(max_length=100)
    password = models.CharField(max_length=128)
    created_at  = models.DateTimeField()
    updated_at  = models.DateTimeField()
    signed_agreement = models.BooleanField()
    class Meta:
        db_table = "users"

    def __str__(self):
        return self.first_name + ' ' + self.last_name

class Inventory(models.Model):
    status = models.ForeignKey(Status, on_delete=models.CASCADE)
    description = models.TextField()
    created_at  = models.DateTimeField()
    updated_at  = models.DateTimeField()
    class Meta:
        db_table = "inventory"

    def __str__(self):
        return self.description

# Create Transaction model
# Create Relationships (ForeignKey)??

class Transaction(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    inventory = models.ForeignKey(Inventory, on_delete=models.CASCADE)
    checkout_time = models.DateTimeField()
    scheduled_checkin_time = models.DateTimeField()
    actual_checkin_time = models.DateTimeField()
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    class Meta:
        db_table = "transactions"

    def __str__(self):
        return self.checkout_time
