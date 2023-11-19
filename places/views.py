from rest_framework.generics import ListAPIView
from django.http import JsonResponse
from rest_framework_gis.filters import DistanceToPointFilter
from django_filters.rest_framework import DjangoFilterBackend
from .models import Place
from .serializers import PlaceSerializer
import osmnx as ox
import networkx as nx

class PlaceList(ListAPIView):
    queryset = Place.objects.all()
    serializer_class = PlaceSerializer
    distance_filter_convert_meters = True
    distance_filter_field = 'location'
    filter_backends =   (DistanceToPointFilter,DjangoFilterBackend)

    def get_queryset(self):
        queryset = Place.objects.all()
        place_type = self.request.query_params.get('type')
        if place_type is not None:
            queryset = queryset.filter(type=place_type)
        return queryset
    
    def get(self, request, *args, **kwargs):
        print(request.query_params)

        response = super().get(request, *args, **kwargs)

        return response

def get_route(request):
    location = ["Palo Alto, California", "Mountain View, California"]
    start = request.GET.get('start').split(',')
    end = request.GET.get('end').split(',')
    G = ox.graph_from_place(location, network_type="drive")
    G = ox.add_edge_speeds(G)
    G = ox.add_edge_travel_times(G)
 
    start_node = ox.distance.nearest_nodes(G, float(start[1]), float(start[0]))
    end_node = ox.distance.nearest_nodes(G, float(end[1]), float(end[0]))
    route = nx.shortest_path(G, start_node, end_node, weight="length")

    route_geometry = ox.utils_graph.route_to_gdf(G, route,"length")
    distance = int(sum(route_geometry["length"]))
    time = int(sum(ox.utils_graph.route_to_gdf(G, route, "travel_time")["travel_time"]))
    return JsonResponse({'route_geojson': route_geometry.to_json(), 'distance':distance, 'time':time})