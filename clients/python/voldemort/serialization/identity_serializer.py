class IdentitySerializer(object):
    def reads(self, s):
        return buffer(s)

    def writes(self, obj):
        return str(obj)

    @staticmethod
    def create_from_xml(node):
        return IdentitySerializer()
