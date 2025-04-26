# Django Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Basic Commands](#basic-commands)
- [Models](#models)
- [CRUD Operations](#crud-operations)
- [Migrations](#migrations)
- [Admin Interface](#admin-interface)
- [Views](#views)
- [URL Routing](#url-routing)
- [Templates](#templates)
- [Forms](#forms)
- [Authentication](#authentication)
- [Class-Based Views](#class-based-views)
- [Middlewares](#middlewares)
- [Static Files and Media](#static-files-and-media)
- [Django Rest Framework (DRF)](#django-rest-framework-drf)
- [Testing](#testing)
- [Deployment](#deployment)
- [Security Best Practices](#security-best-practices)
- [References](#references)

## Introduction
Django is a high-level Python web framework that encourages rapid development and clean, pragmatic design.

## Installation
```bash
pip install django
```

## Project Structure
```bash
django-admin startproject myproject
cd myproject
django-admin startapp myapp
```

Structure:
```
myproject/
    manage.py
    myproject/
        settings.py
        urls.py
        wsgi.py
    myapp/
        models.py
        views.py
        urls.py
        templates/
        static/
```

## Basic Commands
```bash
python manage.py runserver            # Start development server
python manage.py migrate              # Apply migrations
python manage.py makemigrations       # Create migrations
python manage.py createsuperuser      # Create admin user
python manage.py shell                # Django shell
```

## Models
```python
from django.db import models

class Item(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField()
    price = models.DecimalField(max_digits=10, decimal_places=2)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name
```

## CRUD Operations

### Create
```python
item = Item.objects.create(name="Book", description="A novel", price=19.99)
```

### Read
```python
items = Item.objects.all()            # Retrieve all
item = Item.objects.get(id=1)          # Retrieve single item
items = Item.objects.filter(price__lt=50)  # Filter items
```

### Update
```python
item = Item.objects.get(id=1)
item.name = "Updated Book"
item.save()
```

### Delete
```python
item = Item.objects.get(id=1)
item.delete()
```

## Migrations
```bash
python manage.py makemigrations app_name
python manage.py migrate app_name
```

## Admin Interface
```python
from django.contrib import admin
from .models import Item

admin.site.register(Item)
```

```bash
python manage.py createsuperuser
```

## Views
### Function-Based View
```python
from django.http import HttpResponse

def home(request):
    return HttpResponse("Hello, World!")
```

### Template-Based View
```python
from django.shortcuts import render

def home(request):
    return render(request, 'home.html')
```

## URL Routing
```python
from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
]
```

Project urls.py:
```python
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('myapp.urls')),
]
```

## Templates
Directory structure:
```
myapp/
    templates/
        myapp/
            home.html
```

Example `home.html`:
```html
<!DOCTYPE html>
<html>
<body>
  <h1>Welcome to Django</h1>
</body>
</html>
```

## Forms
```python
from django import forms

class ItemForm(forms.ModelForm):
    class Meta:
        model = Item
        fields = ['name', 'description', 'price']
```

View:
```python
from django.shortcuts import render, redirect
from .forms import ItemForm

def create_item(request):
    if request.method == 'POST':
        form = ItemForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('home')
    else:
        form = ItemForm()
    return render(request, 'item_form.html', {'form': form})
```

## Authentication
```python
from django.contrib.auth import authenticate, login, logout

# Login view
user = authenticate(request, username='john', password='secret')
if user is not None:
    login(request, user)

# Logout
logout(request)
```

Built-in views:
```python
from django.contrib.auth import views as auth_views

urlpatterns = [
    path('login/', auth_views.LoginView.as_view(), name='login'),
    path('logout/', auth_views.LogoutView.as_view(), name='logout'),
]
```

## Class-Based Views
```python
from django.views.generic import ListView, DetailView, CreateView, UpdateView, DeleteView
from .models import Item

class ItemListView(ListView):
    model = Item
    template_name = 'item_list.html'

class ItemDetailView(DetailView):
    model = Item
    template_name = 'item_detail.html'

class ItemCreateView(CreateView):
    model = Item
    fields = ['name', 'description', 'price']
    template_name = 'item_form.html'
    success_url = '/'

class ItemUpdateView(UpdateView):
    model = Item
    fields = ['name', 'description', 'price']
    template_name = 'item_form.html'
    success_url = '/'

class ItemDeleteView(DeleteView):
    model = Item
    template_name = 'item_confirm_delete.html'
    success_url = '/'
```

## Middlewares
Custom Middleware example:
```python
class SimpleMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)
        return response
```
Add to `settings.py`:
```python
MIDDLEWARE = [
    ...,
    'myapp.middleware.SimpleMiddleware',
]
```

## Static Files and Media
`settings.py`:
```python
STATIC_URL = '/static/'
MEDIA_URL = '/media/'
MEDIA_ROOT = BASE_DIR / 'media'
```

urls.py:
```python
from django.conf import settings
from django.conf.urls.static import static

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
```

## Django Rest Framework (DRF)
```bash
pip install djangorestframework
```

`settings.py`:
```python
INSTALLED_APPS = [
    ..., 
    'rest_framework',
]
```

Basic API View:
```python
from rest_framework.decorators import api_view
from rest_framework.response import Response

@api_view(['GET'])
def api_home(request):
    return Response({"message": "Hello, API!"})
```

## Testing
```python
from django.test import TestCase
from .models import Item

class ItemModelTest(TestCase):
    def test_str_representation(self):
        item = Item(name="Test Item")
        self.assertEqual(str(item), item.name)
```

Run tests:
```bash
python manage.py test
```

## Deployment
- Use Gunicorn + Nginx
- Configure `ALLOWED_HOSTS`
- Set `DEBUG = False`
- Collect static files:
```bash
python manage.py collectstatic
```
- Use services like AWS, Heroku, DigitalOcean

## Security Best Practices
- Always set `DEBUG = False` in production
- Use environment variables for secrets
- Enable HTTPS
- Keep Django and dependencies updated
- Sanitize user inputs

## References
- [Django Official Documentation](https://docs.djangoproject.com/en/stable/)
- [Django Rest Framework](https://www.django-rest-framework.org/)

