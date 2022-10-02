+++
title = "Python으로 Myinfo oauth2 client connector 구현하기"
date = "2022-07-23"
description = "All about Myinfo project"
tags = ["Project"]
+++


<br>
<br> 

> oauth2를 사용하고 있는 Myinfo API 를 사용하는 connector client를 Python/Django로 구현한다.
> > [[github]](https://github.com/leeleelee3264/myinfo-connector-python)  
[[api document]](https://leelee-1.gitbook.io/myinfo-connector-python-api-doc/)  
[[quick start]](https://leelee-1.gitbook.io/myinfo-connector-python-api-doc/myinfo-connector-python-api/quick-start)

<br> 

**Index**
1. Myinfo란? 
2. 프로젝트 목표 
3. 프로젝트 구현 
4. 프로젝트 회고 

<br> 

# Myinfo란?
### 싱가폴 Mydata 서비스 
정부가 주도한 Mydata 서비스가 몇 개의 나라에 있다고 하는데, 싱가폴 정부의 Singpass는 그 중에서도 모범사례로 뽑힌다고 한다. Singpass는 **싱가포르의 15세 이상의 인구 중 97%** 가 쓰고 있는 아주 활발한 서비스이다.

Singpass에 있는 여러가지 서비스 중 Myinfo는 Person Data를 제공하는 서비스로, 한국의 카카오나 네이버 아이디 처럼 ouath2 로그인과 회원가입을 할 수 있다. _[Picture 1]_ 에서 singpass에 대해서 조금 더 자세히 살펴볼 수 있다. 



<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="https://github.com/leeleelee3264-api-docs/myinfo-connector-python-api-docs/raw/main/.gitbook/assets/image.png" >
<figcaption align = "center">[Picture 1] Introduce Singpass</figcaption>

<br>

### Myinfo oauth2

Myinfo는 _[Picture 2]_ 와 같은 oauth2 구조를 가진다.


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/myinfo_oauth.png" >
<figcaption align = "center">[Picture 2] Myinfo oauth2 구조</figcaption>

<br>

#### Resource Owner
- Myinfo 사용자

#### Application
- 내가 구현하는 connector로, Myinfo 사용자의 데이터를 사용하는 주체

#### Identify Providers / Service Authorization Platform
- 인증서버
- 사용자의 인증정보와 권한 정보를 소유한 서버
- Singpass 로그인 페이지 제공

#### Resource Server
- 사용자 데이터를 소유한 서버
- 인증 서버에 로그인 성공 후 접근


<br>

### Myinfo Resource API


#### 권한 인증 요청
- [[authorise api]](https://public.cloud.myinfo.gov.sg/myinfo/api/myinfo-kyc-v3.2.2.html#operation/getauthorise)
- `GET /v3/authorise`
- Singpass 로그인 페이지를 불러온다.
- 로그인 후 Singpass에서 사용자의 데이터를 불러오는 것에 대한 동의를 진행한다.
- 사용자가 동의했을 경우 `authcode`를 return 한다.

#### Token 요청
- [[token api]](https://public.cloud.myinfo.gov.sg/myinfo/api/myinfo-kyc-v3.2.2.html#operation/gettoken)
- `POST /v3/token`
- `authocode`를 사용하여 `token`을 요청한다.
- PKI를 사용하여 인증을 진행한다.
- 인증이 완료되면 `token`을 return 한다.

#### 사용자 정보 요청
- [[person api]](https://public.cloud.myinfo.gov.sg/myinfo/api/myinfo-kyc-v3.2.2.html#operation/getperson)
- `GET /v3/person/{sub}`
- `token` 속의 `access token`을 사용하여 사용자 정보를 요청한다.
- 사용자 정보를 return 한다.


<br>


# 프로젝트 목표

Singpass가 제공하는 [[Java]](https://github.com/singpass/myinfo-connector-java)와 [[node.js]](https://github.com/singpass/myinfo-connector-nodejs) 버전의 client connector 처럼 이번에 프로젝트로 python 버전의 connector를 만들었다. 아예 하나의 REST API 형태로 제공을 하기 위해 프레임워크로 Django를 선택했다. 

### 프로젝트 목표 

프로젝트를 진행하면서 이루고자 한 목표는 아래와 같다. 대부분의 토이 프로젝트가 제대로 정리가 되어있지 않거나 코드가 엉망으로 짜여질 때가 많아서 이번에는 처음부터 확실하게 목표를 설정했다.

<br>

> Code Quality

- [x] DDD 아키텍처로 서버를 구현한다. 
- [x] 최소 2회의 리팩토링을 진행한다.
- [x] python lint(flake8, pylint, mypy)를 사용하여 최대한 python style을 고수한다.
- [x] Pipenv를 사용해서 python 패키지를 관리한다.

> Documentation
- [x] Github README를 작성한다.
- [x] API document를 작성한다.
- [x] Project에 대한 블로그 포스팅을 작성한다.
  
<br>

###  Dev Stack

| stack                    | info |
|--------------------------| --- |
| Backend Language         | Python  |
| Backend Framework        | Django |
| Code Architecture        | Domain Driven Desgin |
| Python Package Managment | Pipenv |
| API Security             | PKI |
| Version Control          | Github |
| API Document             | GitBook  |


<br>


# 프로젝트 구현 

### Make Request

Myinfo oauth2 구조를 반영하여, connector 서버의 호출 flow를 _[Picture 3]_ 같이 설계했다.


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="/static/img/post/singpass.png" >
<figcaption align = "center">[Picture 3] connector 서버 호출 flow</figcaption>

<br>

#### Step 1: Get myinfo login url

##### Request

`GET /users/me/external/myinfo-redirect-login`

```
curl -i -H 'Accept: application/json' <http://localhost:3001/user/me/external/myinfo-redirect-login>
```

##### Response

```
{
    "message": "OK",
    "data": {
        "url": "https://test.api.myinfo.gov.sg/com/v3/authorise?client_id=STG2-MYINFO-SELF-TEST&attributes=name,dob,birthcountry,nationality,uinfin,sex,regadd&state=eb03c000-00a3-4708-ab30-926306bfc4a8&redirect_uri=http://localhost:3001/callback&purpose=python-myinfo-connector",
        "state": "eb03c000-00a3-4708-ab30-926306bfc4a8"
    }
}
```

<br>

#### Step 2: Browse myinfo login url

##### Request
```
curl <https://test.api.myinfo.gov.sg/com/v3/authorise?client_id=STG2-MYINFO-SELF-TEST&attributes=name,dob,birthcountry,nationality,uinfin,sex,regadd&state=eb03c000-00a3-4708-ab30-926306bfc4a8&redirect_uri=http://localhost:3001/callback&purpose=python-myinfo-connector>
```

##### Response


<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="https://camo.githubusercontent.com/f182742864359f6e9805e719a3385f933d6573fc513b52775b4cfe3bed24ffcc/68747470733a2f2f333832303939333537342d66696c65732e676974626f6f6b2e696f2f7e2f66696c65732f76302f622f676974626f6f6b2d782d70726f642e61707073706f742e636f6d2f6f2f7370616365732532466c496e76414f684638715879534552494938455825324675706c6f6164732532464536496a746441704f3259345668304a6d763746253246254531253834253839254531253835254233254531253834253846254531253835254233254531253834253835254531253835254235254531253836254142254531253834253839254531253835254133254531253836254241253230323032322d30372d323325323025453125383425384225453125383525413925453125383425384325453125383525413525453125383625414225323031302e31382e35312e706e673f616c743d6d6564696126746f6b656e3d61356465613939372d656161362d346539372d613664322d333464343438373463313734" >
<figcaption align = "center">[Picture 4] Myinfo Login Page</figcaption>

<br>

#### Step 3: Login and check agree terms

##### Login 
Check Login page in _[Picture 5]_

##### Agree Terms 

<img class="img-zoomable medium-zoom-image __web-inspector-hide-shortcut__" src="https://camo.githubusercontent.com/39e35bf85ce639345ebb9274a0978272542465c4b71d0e89ceb6f9cd251fb79e/68747470733a2f2f333832303939333537342d66696c65732e676974626f6f6b2e696f2f7e2f66696c65732f76302f622f676974626f6f6b2d782d70726f642e61707073706f742e636f6d2f6f2f7370616365732532466c496e76414f684638715879534552494938455825324675706c6f61647325324630526b63314c6f44546a5a4e364d656c57316136253246254531253834253839254531253835254233254531253834253846254531253835254233254531253834253835254531253835254235254531253836254142254531253834253839254531253835254133254531253836254241253230323032322d30372d323325323025453125383425384225453125383525413925453125383425384325453125383525413525453125383625414225323031302e31392e33352e706e673f616c743d6d6564696126746f6b656e3d38613537643731392d393333332d343061662d386662632d616635363662393134343731" >
<figcaption align = "center">[Picture 5] Myinfo Terms Agreement Page</figcaption>

<br>

#### Step 4: Callback API get called by Myinfo
> Myinfo에서 Request를 하는 Step이다.  

로그인을 하고 terms에 동의를 하면 **Myinfo에서 connector client의 callback API를 호출**해 `authcode`를 넘겨준다.


##### Request
`GET /callback?{code}`
```
curl <http://localhost:3001/callback?code=8932a98da8720a10e356bc76475d76c4c628aa7f&state=e2ad339a-337f-45ec-98fa-1672160cf463>
```

##### Response
{{< figure height="400" width="500" src="https://camo.githubusercontent.com/f4b5b1eaa871876c63d801411444637001c07491091f731ebbafdd36865ebeac/68747470733a2f2f333832303939333537342d66696c65732e676974626f6f6b2e696f2f7e2f66696c65732f76302f622f676974626f6f6b2d782d70726f642e61707073706f742e636f6d2f6f2f7370616365732532466c496e76414f684638715879534552494938455825324675706c6f61647325324641523347636e3571474c7733584a4f64446b5549253246254531253834253839254531253835254233254531253834253846254531253835254233254531253834253835254531253835254235254531253836254142254531253834253839254531253835254133254531253836254241253230323032322d30372d323325323025453125383425384225453125383525413925453125383425384325453125383525413525453125383625414225323031302e33322e33342e706e673f616c743d6d6564696126746f6b656e3d38386462353065332d633933372d343831642d393365312d306536396234633763313662" caption="[Picture 6] Callback Response Page" >}}


<br>

#### Final Step: Get Person data 
> 자동화된 Step이다. 

Callback API의 응답인 callback 페이지는 자동으로 connector client의 person data API를 호출하도록 했다. 해당 API가 Myinfo에서 사용자 정보를 가져오는 마지막 단계이다.


##### Request

`GET /users/me/external/myinfo`

```
curl -i -H 'Accept: application/json' <http://localhost:3001/user/me/external/myinfo>
```

##### Response

```
{
    "message": "OK",
    "sodata": {
        "regadd": {
            "country": {
                "code": "SG",
                "desc": "SINGAPORE"
            },
            "unit": {
                "value": "10"
            },
            "street": {
                "value": "ANCHORVALE DRIVE"
            },
            "lastupdated": "2022-07-14",
            "block": {
                "value": "319"
            },
            "source": "1",
            "postal": {
                "value": "542319"
            },
            "classification": "C",
            "floor": {
                "value": "38"
            },
            "type": "SG",
            "building": {
                "value": ""
            }
        },
        "dob": "1988-10-06",
        "sex": "M",
        "name": "ANDY LAU",
        "birthcountry": "SG",
        "nationality": "SG",
        "uinfin": "S6005048A"
    }
}
```

<br>

### PKI Digital Signature

Myinfo는 PKI Digital Signature를 필요로 한다. 해당 문서에서는 python에서 구현을 할 때 PKI를 사용하는 방법만을 다루기 때문에 PKI에 대한 더 자세한 설명은 링크로 첨부하겠다. [[LeeLee- Digital Certificate]](https://leeleelee3264.github.io/infra/2022/06/15/digital-certificate-part-one.html)

python 패키지로는 *`jwcrypto`*와 `Crypto`를 사용했다.

<br>  

#### PKI 시나리오

> connector client private key

- [[myinfo token api]]([https://public.cloud.myinfo.gov.sg/myinfo/api/myinfo-kyc-v3.2.2.html#operation/gettoken](https://public.cloud.myinfo.gov.sg/myinfo/api/myinfo-kyc-v3.2.2.html#operation/gettoken))를 호출할 때
- [[myinfo person api]]([https://public.cloud.myinfo.gov.sg/myinfo/api/myinfo-kyc-v3.2.2.html#operation/getperson](https://public.cloud.myinfo.gov.sg/myinfo/api/myinfo-kyc-v3.2.2.html#operation/getperson))를 호출 할 때
- [[myinfo person api]]([https://public.cloud.myinfo.gov.sg/myinfo/api/myinfo-kyc-v3.2.2.html#operation/getperson](https://public.cloud.myinfo.gov.sg/myinfo/api/myinfo-kyc-v3.2.2.html#operation/getperson)) 응답 decrypt 할 때  
  - myinfo에서 connector client의 public key로 응답을 암호화 했기 때문

> myinfo public key

- myinfo token api 응답 verify 할 때  
  - myinfo에서 myinfo의 private key로 응답을 암호화 했기 때문
- myinfo person api 응답 verify 할 때  
  - myinfo에서 myinfo의 private key로 응답을 암호화 했기 때문

<br>

#### public, privateKey 불러오기

{{< highlight shell  "linenos=true,hl_inline=false" >}}
from jwcrypto import jwk

PrivateKey = jwk.JWK
PublicKey = jwk.JWK
    

def _get_key(self, key: str) -> Union[PrivateKey, PublicKey]:
        encode_key = key.encode('utf-8')
        key_dict = jwk.JWK.from_pem(encode_key)

        return key_dict
{{< /highlight >}}

<br>

#### connector client private key로 서명하기

{{< highlight shell  "linenos=true,hl_inline=false" >}}
import base64
from Crypto.Hash import SHA256
from Crypto.PublicKey import RSA
from Crypto.Signature import PKCS1_v1_5

Signature = str

def _sign_on_raw_header(
            self,
            base_string: str,
            private_key: str,
    ) -> Signature:

        digest = SHA256.new()
        digest.update(
            base_string.encode('utf-8'),
        )

        pk = RSA.importKey(private_key)
        signer = PKCS1_v1_5.new(pk)
        signature = str(base64.b64encode(signer.sign(digest)), 'utf-8')

        return signature
{{< /highlight >}}

<br>

#### connector client private key로 응답 decrypt 하기

{{< highlight shell  "linenos=true,hl_inline=false" >}}
import json
from jwcrypto import (
    jwe,
    jwk,
)

PrivateKey = jwk.JWK

def _decrypt(
            self,
            encrypted_payload: str,
            key: PrivateKey,
    ) -> DecryptedPersonData:

        params = self._get_decrypt_params(encrypted_payload)

        encryption = jwe.JWE()
        encryption.deserialize(params, key)

        data = encryption.plaintext
        data_str = json.loads(data)

        return data_str
{{< /highlight >}}

<br>

#### myinfo public key로 응답 verify 하기

{{< highlight shell  "linenos=true,hl_inline=false" >}}
import json
from jwcrypto import jwk
   

PublicKey = jwk.JWK
DecodedPersonData = dict

def _decode(
            self,
            encoded_payload: str,
            key: PublicKey,
    ) -> DecodedPersonData:

        token = jwt.JWT()
        token.deserialize(jwt=encoded_payload, key=key)

        data = token.claims
        data_dict = json.loads(data)

        person = DecodedPersonData(**data_dict)
        return person
{{< /highlight >}}

<br>



# 프로젝트 회고 

### 문서화 
정해둔 목표를 잘 이행한 기분이 들어서 뿌듯했다. 또한 항상 미흡했던 문서화를 꼼꼼하게 해 둔 거 같아 만족스럽다. 하지만 문서화를 하는 과정에서 어떻게 내가 말하고자 하는 바를 더 깔끔하게 글로 옮길 수 있을까 고민을 많이 했고, 아직도 부족한 부분이 많이 보인다.
<br>

### 리팩토링
코드 또한 2번 리팩토링을 진행했지만 포스팅을 위해서 다시 코드를 보니 또 리팩토링 해야겠다는 생각이 든다. 프로젝트를 할 때 1,2번의 리팩토링을 하고 프로젝트가 끝나고 2~3달 지나서 리팩토링을 1 번 진행하면 좋을 거 같다.
<br>

### Boilerplate
어떤 프로젝트를 하더라도 프레임워크 setting을 하는데 초기 시간을 많이 소요하는데, 앞으로 Django로 계속 프로젝트를 진행할 예정이라면 pre-setting이 어느 정도 되어있는 Django Boilerplate 를 만들어야겠다. 
