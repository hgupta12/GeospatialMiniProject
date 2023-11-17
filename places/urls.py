from django.urls import path
from .views import PlaceList, get_route

urlpatterns = [
    path('',PlaceList.as_view(), name="places_list"),
    path('/route',get_route, name="get_route")
]