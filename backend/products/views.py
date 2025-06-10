from django.shortcuts import render
# Create your views here.
from rest_framework import viewsets, filters
from .models import Product
from .serializers import ProductSerializer
from django_filters.rest_framework import DjangoFilterBackend # type: ignore

class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['category', 'stock_status', 'is_active']
    search_fields = ['name', 'sku', 'barcode']
    ordering_fields = ['name', 'price', 'stock', 'last_restocked']
