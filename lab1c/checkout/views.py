from django.shortcuts import render
from django.http import HttpResponse
from django.http import Http404

from .models import User
from .models import Transaction

def home(request):
    user =  User.objects.get(id=1) # Just User 1
    transactions =  Transaction.objects.filter(checkout_time__lte = '2018-09-03') # Transactions before Sept 3, 2018
    return render(request, 'home.html', {'user': user, 'transactions': transactions})
