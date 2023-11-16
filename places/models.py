from django.db import models
from django.contrib.gis.db import models as gis_models
import uuid
from django.utils.translation import gettext_lazy as _

class PlaceTypeChoices(models.TextChoices):
    RESTAURANT = 'R', _('Restaurant')
    TOURIST_SPOT = 'T', _('Tourist Spot')
    SHOP = 'S', _('Shop')
    OTHERS = 'O', _('Others')

class Place(models.Model):
    id = models.UUIDField(default=uuid.uuid4, primary_key=True, editable=False)
    name = models.CharField(max_length=100)
    location = gis_models.PointField()
    description = models.TextField(max_length=1000, blank=True)
    type = models.CharField(max_length=1, choices=PlaceTypeChoices.choices, default=PlaceTypeChoices.OTHERS)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
