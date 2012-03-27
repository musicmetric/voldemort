from common import SerializationException
from json_serializer import JsonTypeSerializer
from string_serializer import StringSerializer
from unimplemented_serializer import UnimplementedSerializer
from identity_serializer import IdentitySerializer

SERIALIZER_CLASSES = {
    "string": StringSerializer,
    "json": JsonTypeSerializer,
    "identity": IdentitySerializer,
}
