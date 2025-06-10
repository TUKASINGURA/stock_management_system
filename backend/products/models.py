from django.db import models

# Create your models here.

class Category(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)

    def _str_(self):
        return self.name

class Product(models.Model):
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    category = models.ForeignKey(Category, on_delete=models.SET_NULL, null=True)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    cost = models.DecimalField(max_digits=10, decimal_places=2)
    sku = models.CharField(max_length=50, unique=True)
    barcode = models.CharField(max_length=50, blank=True)
    stock = models.IntegerField(default=0)
    min_stock_level = models.IntegerField(default=10)
    supplier = models.CharField(max_length=200, blank=True)
    last_restocked = models.DateTimeField(auto_now=True)
    image = models.ImageField(upload_to='products/', blank=True)
    is_active = models.BooleanField(default=True)

    def _str_(self):
        return self.name

    @property
    def stock_status(self):
        if self.stock <= 0:
            return 'out_of_stock'
        elif self.stock < self.min_stock_level:
            return 'low_stock'
        return 'in_stock'
