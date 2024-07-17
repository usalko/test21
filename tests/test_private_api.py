from fastapi.testclient import TestClient
from unittest import TestCase
from private_api import private_app


class TestrivateAPI(TestCase):
    
    def setUp(self) -> None:
        self.client = TestClient(private_app)
        return super().setUp()
    
    def test_home(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)