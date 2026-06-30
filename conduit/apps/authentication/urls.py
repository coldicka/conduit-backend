from django.urls import re_path as url

from .views import (
    LoginAPIView, RegistrationAPIView, UserRetrieveUpdateAPIView
)

urlpatterns = [
    url(r'^user/?$', UserRetrieveUpdateAPIView.as_view()),
    url(r'^users/?$', RegistrationAPIView.as_view()),
    url(r'^users/login/?$', LoginAPIView.as_view()),
]
