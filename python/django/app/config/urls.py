from django.http import JsonResponse
from django.urls import path


def index(request):
    return JsonResponse({"Hello": "World"})


def health(request):
    return JsonResponse({"status": "ok"})


urlpatterns = [
    path("", index),
    path("health", health),
]
