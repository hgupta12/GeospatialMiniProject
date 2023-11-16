from rest_framework_gis.serializers import GeoFeatureModelSerializer
from .models import Place

class PlaceSerializer(GeoFeatureModelSerializer):
    """ A class to serialize places as GeoJSON compatible data"""
    
    class Meta:
        model = Place
        geo_field = "location"
        fields = '__all__'
