from rest_framework.generics import ListAPIView
from rest_framework_gis.filters import DistanceToPointFilter
from django_filters.rest_framework import DjangoFilterBackend
from .models import Place
from .serializers import PlaceSerializer

class PlaceList(ListAPIView):
    queryset = Place.objects.all()
    serializer_class = PlaceSerializer
    distance_filter_convert_meters = True
    distance_filter_field = 'location'
    filter_backends =   (DistanceToPointFilter,DjangoFilterBackend)

    def get_queryset(self):
        queryset = self.queryset
        place_type = self.request.query_params.get('type')
        if place_type is not None:
            queryset = queryset.filter(type=place_type)
        return queryset
    
    def get(self, request, *args, **kwargs):
        print(request.query_params)

        response = super().get(request, *args, **kwargs)

        return response
