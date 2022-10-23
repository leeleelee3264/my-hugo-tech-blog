+++
title = "Implement Netflix On-Air Twitter Bot witt Github Action"
date = "2021-04-16"
description = "Github action으로 넷플릭스 상영 알림 트위터 봇 만들기에 대해 다룬다."
tags = ["Project"]
+++


<br>
<br> 

> Twitter API 와 Github Action을 사용하는 트위터 봇을 Python으로 구현한다.
> > [[github]](https://github.com/leeleelee3264/twitter_project)  
> > [[트위터 계정]](https://twitter.com/DevLeelee)

<br> 

**Index**
1. 프로젝트 목표
2. 프로젝트 구현
3. 다음 프로젝트 목표 

<br> 

# 프로젝트 목표 

### 프로젝트 진행 동기 
예전부터 자동으로 응답을 해주는 카톡봇이나 자동으로 트윗을 해주는 트윗봇을 만드는 프로젝트를 하고 싶었는데 어떤걸 만들면 좋을지 몰라 미뤄두고 있었다. 그런데 얼마전에 다음에서 넷플릭스 상영 예정작을 알려주는 페이지를 만든걸 보고 일주일에 한 번씩 넷플릭스 상영 예정작을 트위터 자동봇으로 만들면 편할 것 같아 프로젝트를 진행했다. 

<br> 

> Github Action? 

깃허브에서 CI/CD를 위해 사용되는 기능이다. Action을 등록할 때 파이썬을 지원해주고 있었다. 때문에 Action에 파이썬으로 작성한 스크립트를 등록하면 _별도의 서버를 만들지 않고도_ 크롤링을 해서 트위터에 게시할 수 있기에 프로젝트에서 사용하기로 결정했다. 

<br> 

> 개발 목표
- [x] 별도의 서버를 띄우지 않기 위해 github action을 트리거로 사용한다. 
- [x] python과  tweepy 라이브러리를 사용한다. 
- [x] Twitter 에서 개발자 계정을 발급받아 API를 사용한다. 

<br> 

### Dev Stack 
| stack      | info |
|-----------------|------------|
| Backend language       |   python         |
| Backend api | twitter api |  
| Server | server less |  
| Scheduler | github action |  

<br> 

# 프로젝트 구현

### Twitter Bot Flow
트위터 봇 플로우는 _[Picture 1]_ 과 같다.

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/twitter_flow.png" >
<figcaption align = "center">[Picture 1] Twitter Bot Flow</figcaption>


<br> 


### 리소스
프로젝트에서 활용할 리소스들을 정리했다. 

- [[Twitter API]](https://developer.twitter.com/en/docs/twitter-api/v1)
- [[Python tweepy 라이브러리]](https://docs.tweepy.org/ko/latest/api.html)
- [[다음 넷플릭스 페이지]](https://movie.daum.net/premovie/netflix?flag=Y)


<br>

### 트위터 api와 tweepy로 트윗하기


트위터 api 계정을 만들고 대시보드에 들어가면 총 네개의 인증키를 받을 수 있다. 현재 트위터 api에서는 Oauth1, 2와 기본인증법 여러개의 인증을 지원하기 때문에 사용할 인증법을 선택해주면 된다. 트위터 auth에 대한 [[더 자세한 사항]](https://developer.twitter.com/en/docs/authentication/overview)을 확인해보자. 

<br> 

> 발급되는 키 

- Api key
- Api key secret
- Bearer Token
- Access Token Secret

<br> 

#### tweepy 라이브러리 인증 코드

트위터가 지원하는 인증 방법이 다양하기 때문에 tweepy도 이에 맞춰 다양한 지원을 한다. tweepy에서 제공하는 [[인증 기능 문서]](https://docs.tweepy.org/en/latest/auth_tutorial.html) 에서 자세히 살필 수 있다.  

<details>
 <summary>auth.py 더보기</summary> 

{{< highlight python  "linenos=true,hl_inline=false" >}}
# Tweepy
# Copyright 2009-2020 Joshua Roesslein
# See LICENSE for details.

import logging

import requests
import six
from requests.auth import AuthBase
from requests_oauthlib import OAuth1, OAuth1Session
from six.moves.urllib.parse import parse_qs

from tweepy.api import API
from tweepy.error import TweepError

WARNING_MESSAGE = """Warning! Due to a Twitter API bug, signin_with_twitter
and access_type don't always play nice together. Details
https://dev.twitter.com/discussions/21281"""

log = logging.getLogger(__name__)

class AuthHandler(object):

    def apply_auth(self, url, method, headers, parameters):
        """Apply authentication headers to request"""
        raise NotImplementedError

    def get_username(self):
        """Return the username of the authenticated user"""
        raise NotImplementedError

class OAuthHandler(AuthHandler):
    """OAuth authentication handler"""
    OAUTH_HOST = 'api.twitter.com'
    OAUTH_ROOT = '/oauth/'

    def __init__(self, consumer_key, consumer_secret, callback=None):
        if type(consumer_key) == six.text_type:
            consumer_key = consumer_key.encode('ascii')

        if type(consumer_secret) == six.text_type:
            consumer_secret = consumer_secret.encode('ascii')

        self.consumer_key = consumer_key
        self.consumer_secret = consumer_secret
        self.access_token = None
        self.access_token_secret = None
        self.callback = callback
        self.username = None
        self.request_token = {}
        self.oauth = OAuth1Session(consumer_key,
                                   client_secret=consumer_secret,
                                   callback_uri=self.callback)

    def _get_oauth_url(self, endpoint):
        return 'https://' + self.OAUTH_HOST + self.OAUTH_ROOT + endpoint

    def apply_auth(self):
        return OAuth1(self.consumer_key,
                      client_secret=self.consumer_secret,
                      resource_owner_key=self.access_token,
                      resource_owner_secret=self.access_token_secret,
                      decoding=None)

    def _get_request_token(self, access_type=None):
        try:
            url = self._get_oauth_url('request_token')
            if access_type:
                url += '?x_auth_access_type=%s' % access_type
            return self.oauth.fetch_request_token(url)
        except Exception as e:
            raise TweepError(e)

    def set_access_token(self, key, secret):
        self.access_token = key
        self.access_token_secret = secret

    def get_authorization_url(self,
                              signin_with_twitter=False,
                              access_type=None):
        """Get the authorization URL to redirect the user"""
        try:
            if signin_with_twitter:
                url = self._get_oauth_url('authenticate')
                if access_type:
                    log.warning(WARNING_MESSAGE)
            else:
                url = self._get_oauth_url('authorize')
            self.request_token = self._get_request_token(access_type=access_type)
            return self.oauth.authorization_url(url)
        except Exception as e:
            raise TweepError(e)

    def get_access_token(self, verifier=None):
        """
        After user has authorized the request token, get access token
        with user supplied verifier.
        """
        try:
            url = self._get_oauth_url('access_token')
            self.oauth = OAuth1Session(self.consumer_key,
                                       client_secret=self.consumer_secret,
                                       resource_owner_key=self.request_token['oauth_token'],
                                       resource_owner_secret=self.request_token['oauth_token_secret'],
                                       verifier=verifier, callback_uri=self.callback)
            resp = self.oauth.fetch_access_token(url)
            self.access_token = resp['oauth_token']
            self.access_token_secret = resp['oauth_token_secret']
            return self.access_token, self.access_token_secret
        except Exception as e:
            raise TweepError(e)

    def get_xauth_access_token(self, username, password):
        """
        Get an access token from an username and password combination.
        In order to get this working you need to create an app at
        http://twitter.com/apps, after that send a mail to api@twitter.com
        and request activation of xAuth for it.
        """
        try:
            url = self._get_oauth_url('access_token')
            oauth = OAuth1(self.consumer_key,
                           client_secret=self.consumer_secret)
            r = requests.post(url=url,
                              auth=oauth,
                              headers={'x_auth_mode': 'client_auth',
                                       'x_auth_username': username,
                                       'x_auth_password': password})

            credentials = parse_qs(r.content)
            return credentials.get('oauth_token')[0], credentials.get('oauth_token_secret')[0]
        except Exception as e:
            raise TweepError(e)

    def get_username(self):
        if self.username is None:
            api = API(self)
            user = api.verify_credentials()
            if user:
                self.username = user.screen_name
            else:
                raise TweepError('Unable to get username,'
                                 ' invalid oauth token!')
        return self.username

class OAuth2Bearer(AuthBase):
    def __init__(self, bearer_token):
        self.bearer_token = bearer_token

    def __call__(self, request):
        request.headers['Authorization'] = 'Bearer ' + self.bearer_token
        return request

class AppAuthHandler(AuthHandler):
    """Application-only authentication handler"""

    OAUTH_HOST = 'api.twitter.com'
    OAUTH_ROOT = '/oauth2/'

    def __init__(self, consumer_key, consumer_secret):
        self.consumer_key = consumer_key
        self.consumer_secret = consumer_secret
        self._bearer_token = ''

        resp = requests.post(self._get_oauth_url('token'),
                             auth=(self.consumer_key,
                                   self.consumer_secret),
                             data={'grant_type': 'client_credentials'})
        data = resp.json()
        if data.get('token_type') != 'bearer':
            raise TweepError('Expected token_type to equal "bearer", '
                             'but got %s instead' % data.get('token_type'))

        self._bearer_token = data['access_token']

    def _get_oauth_url(self, endpoint):
        return 'https://' + self.OAUTH_HOST + self.OAUTH_ROOT + endpoint

    def apply_auth(self):
        return OAuth2Bearer(self._bearer_token)
{{< /highlight >}}

</details>

<details>
 <summary>oauth1_session1.py 더보기</summary>  

{{< highlight python  "linenos=true,hl_inline=false" >}}
from __future__ import unicode_literals

try:
    from urlparse import urlparse
except ImportError:
    from urllib.parse import urlparse

import logging

from oauthlib.common import add_params_to_uri
from oauthlib.common import urldecode as _urldecode
from oauthlib.oauth1 import SIGNATURE_HMAC, SIGNATURE_RSA, SIGNATURE_TYPE_AUTH_HEADER
import requests

from . import OAuth1

log = logging.getLogger(__name__)

def urldecode(body):
    """Parse query or json to python dictionary"""
    try:
        return _urldecode(body)
    except Exception:
        import json

        return json.loads(body)

class TokenRequestDenied(ValueError):
    def __init__(self, message, response):
        super(TokenRequestDenied, self).__init__(message)
        self.response = response

    @property
    def status_code(self):
        """For backwards-compatibility purposes"""
        return self.response.status_code

class TokenMissing(ValueError):
    def __init__(self, message, response):
        super(TokenMissing, self).__init__(message)
        self.response = response

class VerifierMissing(ValueError):
    pass

class OAuth1Session(requests.Session):
    """Request signing and convenience methods for the oauth dance.

    What is the difference between OAuth1Session and OAuth1?

    OAuth1Session actually uses OAuth1 internally and its purpose is to assist
    in the OAuth workflow through convenience methods to prepare authorization
    URLs and parse the various token and redirection responses. It also provide
    rudimentary validation of responses.

    An example of the OAuth workflow using a basic CLI app and Twitter.

    >>> # Credentials obtained during the registration.
    >>> client_key = 'client key'
    >>> client_secret = 'secret'
    >>> callback_uri = 'https://127.0.0.1/callback'
    >>>
    >>> # Endpoints found in the OAuth provider API documentation
    >>> request_token_url = 'https://api.twitter.com/oauth/request_token'
    >>> authorization_url = 'https://api.twitter.com/oauth/authorize'
    >>> access_token_url = 'https://api.twitter.com/oauth/access_token'
    >>>
    >>> oauth_session = OAuth1Session(client_key,client_secret=client_secret, callback_uri=callback_uri)
    >>>
    >>> # First step, fetch the request token.
    >>> oauth_session.fetch_request_token(request_token_url)
    {
        'oauth_token': 'kjerht2309u',
        'oauth_token_secret': 'lsdajfh923874',
    }
    >>>
    >>> # Second step. Follow this link and authorize
    >>> oauth_session.authorization_url(authorization_url)
    'https://api.twitter.com/oauth/authorize?oauth_token=sdf0o9823sjdfsdf&oauth_callback=https%3A%2F%2F127.0.0.1%2Fcallback'
    >>>
    >>> # Third step. Fetch the access token
    >>> redirect_response = raw_input('Paste the full redirect URL here.')
    >>> oauth_session.parse_authorization_response(redirect_response)
    {
        'oauth_token: 'kjerht2309u',
        'oauth_token_secret: 'lsdajfh923874',
        'oauth_verifier: 'w34o8967345',
    }
    >>> oauth_session.fetch_access_token(access_token_url)
    {
        'oauth_token': 'sdf0o9823sjdfsdf',
        'oauth_token_secret': '2kjshdfp92i34asdasd',
    }
    >>> # Done. You can now make OAuth requests.
    >>> status_url = 'http://api.twitter.com/1/statuses/update.json'
    >>> new_status = {'status':  'hello world!'}
    >>> oauth_session.post(status_url, data=new_status)
    <Response [200]>
    """

    def __init__(
        self,
        client_key,
        client_secret=None,
        resource_owner_key=None,
        resource_owner_secret=None,
        callback_uri=None,
        signature_method=SIGNATURE_HMAC,
        signature_type=SIGNATURE_TYPE_AUTH_HEADER,
        rsa_key=None,
        verifier=None,
        client_class=None,
        force_include_body=False,
        **kwargs
    ):
        """Construct the OAuth 1 session.

        :param client_key: A client specific identifier.
        :param client_secret: A client specific secret used to create HMAC and
                              plaintext signatures.
        :param resource_owner_key: A resource owner key, also referred to as
                                   request token or access token depending on
                                   when in the workflow it is used.
        :param resource_owner_secret: A resource owner secret obtained with
                                      either a request or access token. Often
                                      referred to as token secret.
        :param callback_uri: The URL the user is redirect back to after
                             authorization.
        :param signature_method: Signature methods determine how the OAuth
                                 signature is created. The three options are
                                 oauthlib.oauth1.SIGNATURE_HMAC (default),
                                 oauthlib.oauth1.SIGNATURE_RSA and
                                 oauthlib.oauth1.SIGNATURE_PLAIN.
        :param signature_type: Signature type decides where the OAuth
                               parameters are added. Either in the
                               Authorization header (default) or to the URL
                               query parameters or the request body. Defined as
                               oauthlib.oauth1.SIGNATURE_TYPE_AUTH_HEADER,
                               oauthlib.oauth1.SIGNATURE_TYPE_QUERY and
                               oauthlib.oauth1.SIGNATURE_TYPE_BODY
                               respectively.
        :param rsa_key: The private RSA key as a string. Can only be used with
                        signature_method=oauthlib.oauth1.SIGNATURE_RSA.
        :param verifier: A verifier string to prove authorization was granted.
        :param client_class: A subclass of `oauthlib.oauth1.Client` to use with
                             `requests_oauthlib.OAuth1` instead of the default
        :param force_include_body: Always include the request body in the
                                   signature creation.
        :param **kwargs: Additional keyword arguments passed to `OAuth1`
        """
        super(OAuth1Session, self).__init__()
        self._client = OAuth1(
            client_key,
            client_secret=client_secret,
            resource_owner_key=resource_owner_key,
            resource_owner_secret=resource_owner_secret,
            callback_uri=callback_uri,
            signature_method=signature_method,
            signature_type=signature_type,
            rsa_key=rsa_key,
            verifier=verifier,
            client_class=client_class,
            force_include_body=force_include_body,
            **kwargs
        )
        self.auth = self._client

    @property
    def token(self):
        oauth_token = self._client.client.resource_owner_key
        oauth_token_secret = self._client.client.resource_owner_secret
        oauth_verifier = self._client.client.verifier

        token_dict = {}
        if oauth_token:
            token_dict["oauth_token"] = oauth_token
        if oauth_token_secret:
            token_dict["oauth_token_secret"] = oauth_token_secret
        if oauth_verifier:
            token_dict["oauth_verifier"] = oauth_verifier

        return token_dict

    @token.setter
    def token(self, value):
        self._populate_attributes(value)

    @property
    def authorized(self):
        """Boolean that indicates whether this session has an OAuth token
        or not. If `self.authorized` is True, you can reasonably expect
        OAuth-protected requests to the resource to succeed. If
        `self.authorized` is False, you need the user to go through the OAuth
        authentication dance before OAuth-protected requests to the resource
        will succeed.
        """
        if self._client.client.signature_method == SIGNATURE_RSA:
            # RSA only uses resource_owner_key
            return bool(self._client.client.resource_owner_key)
        else:
            # other methods of authentication use all three pieces
            return (
                bool(self._client.client.client_secret)
                and bool(self._client.client.resource_owner_key)
                and bool(self._client.client.resource_owner_secret)
            )

    def authorization_url(self, url, request_token=None, **kwargs):
        """Create an authorization URL by appending request_token and optional
        kwargs to url.

        This is the second step in the OAuth 1 workflow. The user should be
        redirected to this authorization URL, grant access to you, and then
        be redirected back to you. The redirection back can either be specified
        during client registration or by supplying a callback URI per request.

        :param url: The authorization endpoint URL.
        :param request_token: The previously obtained request token.
        :param kwargs: Optional parameters to append to the URL.
        :returns: The authorization URL with new parameters embedded.

        An example using a registered default callback URI.

        >>> request_token_url = 'https://api.twitter.com/oauth/request_token'
        >>> authorization_url = 'https://api.twitter.com/oauth/authorize'
        >>> oauth_session = OAuth1Session('client-key', client_secret='secret')
        >>> oauth_session.fetch_request_token(request_token_url)
        {
            'oauth_token': 'sdf0o9823sjdfsdf',
            'oauth_token_secret': '2kjshdfp92i34asdasd',
        }
        >>> oauth_session.authorization_url(authorization_url)
        'https://api.twitter.com/oauth/authorize?oauth_token=sdf0o9823sjdfsdf'
        >>> oauth_session.authorization_url(authorization_url, foo='bar')
        'https://api.twitter.com/oauth/authorize?oauth_token=sdf0o9823sjdfsdf&foo=bar'

        An example using an explicit callback URI.

        >>> request_token_url = 'https://api.twitter.com/oauth/request_token'
        >>> authorization_url = 'https://api.twitter.com/oauth/authorize'
        >>> oauth_session = OAuth1Session('client-key', client_secret='secret', callback_uri='https://127.0.0.1/callback')
        >>> oauth_session.fetch_request_token(request_token_url)
        {
            'oauth_token': 'sdf0o9823sjdfsdf',
            'oauth_token_secret': '2kjshdfp92i34asdasd',
        }
        >>> oauth_session.authorization_url(authorization_url)
        'https://api.twitter.com/oauth/authorize?oauth_token=sdf0o9823sjdfsdf&oauth_callback=https%3A%2F%2F127.0.0.1%2Fcallback'
        """
        kwargs["oauth_token"] = request_token or self._client.client.resource_owner_key
        log.debug("Adding parameters %s to url %s", kwargs, url)
        return add_params_to_uri(url, kwargs.items())

    def fetch_request_token(self, url, realm=None, **request_kwargs):
        r"""Fetch a request token.

        This is the first step in the OAuth 1 workflow. A request token is
        obtained by making a signed post request to url. The token is then
        parsed from the application/x-www-form-urlencoded response and ready
        to be used to construct an authorization url.

        :param url: The request token endpoint URL.
        :param realm: A list of realms to request access to.
        :param \*\*request_kwargs: Optional arguments passed to ''post''
        function in ''requests.Session''
        :returns: The response in dict format.

        Note that a previously set callback_uri will be reset for your
        convenience, or else signature creation will be incorrect on
        consecutive requests.

        >>> request_token_url = 'https://api.twitter.com/oauth/request_token'
        >>> oauth_session = OAuth1Session('client-key', client_secret='secret')
        >>> oauth_session.fetch_request_token(request_token_url)
        {
            'oauth_token': 'sdf0o9823sjdfsdf',
            'oauth_token_secret': '2kjshdfp92i34asdasd',
        }
        """
        self._client.client.realm = " ".join(realm) if realm else None
        token = self._fetch_token(url, **request_kwargs)
        log.debug("Resetting callback_uri and realm (not needed in next phase).")
        self._client.client.callback_uri = None
        self._client.client.realm = None
        return token

    def fetch_access_token(self, url, verifier=None, **request_kwargs):
        """Fetch an access token.

        This is the final step in the OAuth 1 workflow. An access token is
        obtained using all previously obtained credentials, including the
        verifier from the authorization step.

        Note that a previously set verifier will be reset for your
        convenience, or else signature creation will be incorrect on
        consecutive requests.

        >>> access_token_url = 'https://api.twitter.com/oauth/access_token'
        >>> redirect_response = 'https://127.0.0.1/callback?oauth_token=kjerht2309uf&oauth_token_secret=lsdajfh923874&oauth_verifier=w34o8967345'
        >>> oauth_session = OAuth1Session('client-key', client_secret='secret')
        >>> oauth_session.parse_authorization_response(redirect_response)
        {
            'oauth_token: 'kjerht2309u',
            'oauth_token_secret: 'lsdajfh923874',
            'oauth_verifier: 'w34o8967345',
        }
        >>> oauth_session.fetch_access_token(access_token_url)
        {
            'oauth_token': 'sdf0o9823sjdfsdf',
            'oauth_token_secret': '2kjshdfp92i34asdasd',
        }
        """
        if verifier:
            self._client.client.verifier = verifier
        if not getattr(self._client.client, "verifier", None):
            raise VerifierMissing("No client verifier has been set.")
        token = self._fetch_token(url, **request_kwargs)
        log.debug("Resetting verifier attribute, should not be used anymore.")
        self._client.client.verifier = None
        return token

    def parse_authorization_response(self, url):
        """Extract parameters from the post authorization redirect response URL.

        :param url: The full URL that resulted from the user being redirected
                    back from the OAuth provider to you, the client.
        :returns: A dict of parameters extracted from the URL.

        >>> redirect_response = 'https://127.0.0.1/callback?oauth_token=kjerht2309uf&oauth_token_secret=lsdajfh923874&oauth_verifier=w34o8967345'
        >>> oauth_session = OAuth1Session('client-key', client_secret='secret')
        >>> oauth_session.parse_authorization_response(redirect_response)
        {
            'oauth_token: 'kjerht2309u',
            'oauth_token_secret: 'lsdajfh923874',
            'oauth_verifier: 'w34o8967345',
        }
        """
        log.debug("Parsing token from query part of url %s", url)
        token = dict(urldecode(urlparse(url).query))
        log.debug("Updating internal client token attribute.")
        self._populate_attributes(token)
        self.token = token
        return token

    def _populate_attributes(self, token):
        if "oauth_token" in token:
            self._client.client.resource_owner_key = token["oauth_token"]
        else:
            raise TokenMissing(
                "Response does not contain a token: {resp}".format(resp=token), token
            )
        if "oauth_token_secret" in token:
            self._client.client.resource_owner_secret = token["oauth_token_secret"]
        if "oauth_verifier" in token:
            self._client.client.verifier = token["oauth_verifier"]

    def _fetch_token(self, url, **request_kwargs):
        log.debug("Fetching token from %s using client %s", url, self._client.client)
        r = self.post(url, **request_kwargs)

        if r.status_code >= 400:
            error = "Token request failed with code %s, response was '%s'."
            raise TokenRequestDenied(error % (r.status_code, r.text), r)

        log.debug('Decoding token from response "%s"', r.text)
        try:
            token = dict(urldecode(r.text.strip()))
        except ValueError as e:
            error = (
                "Unable to decode token from token response. "
                "This is commonly caused by an unsuccessful request where"
                " a non urlencoded error message is returned. "
                "The decoding error was %s"
                "" % e
            )
            raise ValueError(error)

        log.debug("Obtained token %s", token)
        log.debug("Updating internal client attributes from token data.")
        self._populate_attributes(token)
        self.token = token
        return token

    def rebuild_auth(self, prepared_request, response):
        """
        When being redirected we should always strip Authorization
        header, since nonce may not be reused as per OAuth spec.
        """
        if "Authorization" in prepared_request.headers:
            # If we get redirected to a new host, we should strip out
            # any authentication headers.
            prepared_request.headers.pop("Authorization", True)
            prepared_request.prepare_auth(self.auth)
        return
{{< /highlight >}}

</details>

<br> 

#### tweepy를 사용한 구현체

tweepy 라이브러리를 사용해서 실제로 구현을 진행했다. 

<br> 

> 트윗하기 구현체 

{{< highlight python  "linenos=true,hl_inline=false" >}}
def OAuth():
    try:
        api_key = os.environ.get('TWITTER_API_KEY')
        api_key_secret = os.environ.get('TWITTER_API_SECRET')

        access_token = os.environ.get('TWITTER_ACCESS_TOKEN')
        access_token_secret = os.environ.get('TWITTER_ACCESS_TOKEN_SECRET')

        auth = tweepy.OAuthHandler(api_key, api_key_secret)
        auth.set_access_token(access_token, access_token_secret)
        return auth
    except Exception as e:
        return None

def post_tweet(container: dict, date):
    print('work calling')
    oauth = OAuth()
    api = tweepy.API(oauth)
    _current_dir = os.path.dirname(os.path.abspath(__file__))
    _path = Path(_current_dir)

    BASE_DIR = _path.parent.absolute()
    IMG_DIR = f'{BASE_DIR}/img/netflix/{date}'
    print(f'{IMG_DIR}')
    for key in container:
        tTitle = key
        tFile = f'{IMG_DIR}/{tTitle}.png'
        print(f'{tFile}')
        reTitle = regex.change_hyphen(tTitle)

        tweet_format = f'[{reTitle}]\n 공개 여정일:{container[key]}'
        api.update_with_media(tFile, status=tweet_format)
{{< /highlight >}}


<br>

### Github Action 

#### Repository Secret

실제 사용 코드를 보면 `TWITTER_API_KEY`, `TWITTER_API_SECRET` 등 environ 을 이용해 환경에서 받아온 변수들이 있다. 트위터 api를 사용하려면 여러개의 인증키가 필요한데 코드를 프라이빗 repo로 올려도 되지만 `Repository Secret` 으로 인증키들을 등록하는 방법을 선택했다.


[[깃허브 공식 가이드]](https://docs.github.com/en/actions/reference/encrypted-secrets)에 secret을 등록하는 방법이 나와있다. 따라해보다 보면 사진처럼 repo에 노출하지 않아도 사용할 수 있는 secret key들이 만들어진다.


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/git_secret.PNG" >
<figcaption align = "center">[Picture 2] Repository Secret</figcaption>

<br> 

#### Repository Secret 사용하기 

> 사용 시나리오 

1. 액션을 등록할 때 secret을 넘겨준다. 
2. 실행시에 코드로 환경변수에 접근해서 
3. 코드 단에서 환경을 통해 받아온다. 
   - 자바에서 main 실행할 때 args들을 통해 환경값을 넘기는 것  
   - 파이썬에서 environ를 통해 환경값을 넘기는 것 

<br> 


스택 오버 플로우에 있는 [[github action에서 secret을 넘겨 python으로 받아오기]](https://stackoverflow.com/questions/64514500/github-workflow-for-automating-python-script-with-secrets-not-working)를 레퍼런스로 코드를 만들었다. 중요한 점은 secret으로 등록한 키들을 파이썬을 실행하는 스크립트를 실행한 후에 던져주는 것이었다.

<br> 


### Github Action Workflow

깃허브에서는 액션을 등록하기 위해서는 yml로 스크립트를 작성해야 한다. 그 스크립트 안에는 한 작업이 아니라 여러가지 작업이 하나씩 순서대로 처리가 되는데 그래서 액션을 등록하는 파일 이름을 workflow라고 하는 게 아닐까? 

액션을 성공적으로 실행시키기 위해서는 이 workflow 스크립트를 잘 짜는 것이 제일 중요하다. 또 액션이 update (commit) 마다, 스케쥴링에 따라 실행이 되기 때문에 결과를 확인하기 위해서는 짧아도 1~2분 정도는 기다려야 해서 여러번 수정하다보면 많은 시간을 소비하게 된다.

<br>

> workflow 시나리오
1. 파이썬 실행을 위해 플라스크와 requirements.txt 속의 라이브러리들을 설치
2. 상영 예정작 정보가 있는 사이트 크롤링
3. 크롤링한 이미지들을 저장하기 위한 commit/push
4. 실제로 트윗을 하는 파이썬 코드 실행

<br>


> 트위터 봇을 위한 workflow.yaml

{{< highlight yaml  "linenos=true,hl_inline=false" >}}
# This workflow will install Python dependencies, run tests and lint with a single version of Python
# For more information see: https://help.github.com/actions/language-and-framework-guides/using-python-with-github-actions

name: Netflix_Crawl

on:
  schedule: 
    - cron: '0 0 * * Sat'
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - name: Set up Python 3.9
      uses: actions/setup-python@v2
      with:
        python-version: 3.9
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install flake8 pytest
        if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
    - name: Lint with flake8
      run: |
        # stop the build if there are Python syntax errors or undefined names
        flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
        # exit-zero treats all errors as warnings. The GitHub editor is 127 chars wide
        flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
    - name: Run netflix crawler with python 
      run: |
        python3 "./crawl/netflix.py"
    - name: Commits
      run: |
        git config --local user.email "absinthe4902@naver.com"
        git config --local user.name "AUTO_ADD_GIT_ACTION"
        git add .
        git commit -m "AUTO ADD: commit downloaded image"
    - name: Push
      uses: ad-m/github-push-action@master
      with:
        branch: 'master'
        github_token: $ 
    - name: Tweet for final 
      run: |
        python3 "./crawl/tweeting.py"
      env: 
        TWITTER_API_KEY: ${{ secrets.TWITTER_API_KEY }}
        TWITTER_API_SECRET: ${{ secrets.TWITTER_API_SECRET }}
        TWITTER_ACCESS_TOKEN: ${{ secrets.TWITTER_ACCESS_TOKEN }}
        TWITTER_ACCESS_TOKEN_SECRET: ${{ secrets.TWITTER_ACCESS_TOKEN_SECRET }}
{{< /highlight >}}


<br>

매주 토요일 00:00시에 스케쥴러가 돌아가도록 작성했는데 시간대의 기준은 UTC이다.

<br>

> 삽질 구간

아까 스택오버플로우에서 말한 것처럼 환경변수는 파이썬 실행 후 넘겨주고 있다. 제일 헤매던 부분은 프로젝트에서 파이썬 코드가 있는 디렉터리를 찾는 부분이었다. 예를 들어 crawl 디렉터리 안에 있는 netflix.py를 실행할 때 동일한 디렉터리 안에 있는 유틸성 파일 regex.py를 찾지 못했다. 

액션은 repo를 기준으로 동작하기 때문에 current dir가 repo였던 twitter_project였을텐데 무슨 이유로 다른 파일들을 찾지 못했는지 모르겠다. 여러번의 수정을 거친 다음에 `./crawl/netflix.py` 로 실행을 하니 정상적으로 작동을 했다.


<br>

### 실제 동작 화면

<br>

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/newflix_account.PNG" >
<figcaption align = "center">[Picture 3] 트위터 계정</figcaption>

<br>
<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/netflix_work1.PNG" >
<figcaption align = "center">[Picture 4] 트윗 화면 1</figcaption>

<br>
<br>


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/netflix_work2.PNG" >
<figcaption align = "center">[Picture 5] 트윗 화면 2</figcaption>

<br>

# 다음 프로젝트 목표

- 똑같이 twitter api를 사용
- 현재 한국에서 공연 하고 있는 연극과 뮤지컬을 알려주는 자동봇
- tweepy를 사용하지 않고 직접 구현하기
- 최소한 인증을 받는 부분이라도 구현하기 (oauth 공부)
- 동일하게 server-less로 git action 사용

<br> 

### Update in 2022 
위에서 기획했던 트위터 봇을 만들었다. 

- [[지금 공연중인 뮤지컬 알림봇]](https://twitter.com/now_performKr)
- [[오늘의 뮤지컬 스케줄]](https://twitter.com/today_perform)

<br> 

#### 프로젝트 구조 


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="https://user-images.githubusercontent.com/35620531/137567303-9155675c-932e-4331-8207-701b45f0f76f.png" >
<figcaption align = "center">[Picture 6] 프로젝트 구조</figcaption>

#### Dev Stack 
| stack      | info |
|-----------------|------------|
| Backend language       |   python         |
| Backend api | twitter api |  
| Server | Ubuntu 20 |  
| Scheduler | Linux cron job |  