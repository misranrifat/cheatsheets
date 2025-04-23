# Python Requests Cheatsheet

```markdown
# Python Requests Comprehensive Cheatsheet

## Table of Contents
1. [Installation](#installation)
2. [Making Requests](#making-requests)
   - [GET Requests](#get-requests)
   - [POST Requests](#post-requests)
   - [Other HTTP Methods](#other-http-methods)
3. [Request Parameters](#request-parameters)
   - [URL Parameters](#url-parameters)
   - [Headers](#headers)
   - [Cookies](#cookies)
   - [Timeout](#timeout)
4. [Response Handling](#response-handling)
   - [Response Content](#response-content)
   - [Status Codes](#status-codes)
   - [Response Headers](#response-headers)
   - [JSON Responses](#json-responses)
5. [Advanced Features](#advanced-features)
   - [Sessions](#sessions)
   - [Proxies](#proxies)
   - [SSL Verification](#ssl-verification)
   - [Authentication](#authentication)
   - [Streaming](#streaming)
   - [File Uploads](#file-uploads)
6. [Error Handling](#error-handling)
7. [Performance](#performance)
8. [Common Recipes](#common-recipes)

## Installation

```bash
pip install requests
```

## Making Requests

### GET Requests

```python
import requests

# Basic GET request
response = requests.get('https://api.example.com/data')

# GET with parameters in URL
response = requests.get('https://api.example.com/data?param1=value1&param2=value2')

# GET with parameters as dictionary
params = {'key1': 'value1', 'key2': 'value2'}
response = requests.get('https://api.example.com/data', params=params)
```

### POST Requests

```python
# Basic POST request
response = requests.post('https://api.example.com/post', data={'key': 'value'})

# POST with JSON data
response = requests.post('https://api.example.com/post', json={'key': 'value'})

# POST with form data
data = {'key1': 'value1', 'key2': 'value2'}
response = requests.post('https://api.example.com/post', data=data)

# POST with multipart form data (file upload)
files = {'file': ('report.xls', open('report.xls', 'rb'), 'application/vnd.ms-excel')}
response = requests.post('https://api.example.com/upload', files=files)
```

### Other HTTP Methods

```python
# PUT request
response = requests.put('https://api.example.com/put', data={'key': 'value'})

# DELETE request
response = requests.delete('https://api.example.com/delete')

# HEAD request
response = requests.head('https://api.example.com/get')

# OPTIONS request
response = requests.options('https://api.example.com/get')
```

## Request Parameters

### URL Parameters

```python
params = {'key1': 'value1', 'key2': ['value2', 'value3']}
response = requests.get('https://api.example.com/data', params=params)
# URL becomes: https://api.example.com/data?key1=value1&key2=value2&key2=value3
```

### Headers

```python
headers = {
    'User-Agent': 'my-app/0.0.1',
    'Accept': 'application/json',
    'Authorization': 'Bearer my-token'
}
response = requests.get('https://api.example.com/data', headers=headers)
```

### Cookies

```python
# Sending cookies
cookies = {'session_id': '12345'}
response = requests.get('https://api.example.com/data', cookies=cookies)

# Receiving cookies
response = requests.get('https://api.example.com/set-cookie')
print(response.cookies['session_id'])
```

### Timeout

```python
# Timeout in seconds
try:
    response = requests.get('https://api.example.com/data', timeout=3.05)
except requests.exceptions.Timeout:
    print("Request timed out")

# Separate connect and read timeouts (requires Python 3+)
try:
    response = requests.get('https://api.example.com/data', timeout=(1, 5))
except requests.exceptions.Timeout:
    print("Request timed out")
```

## Response Handling

### Response Content

```python
response = requests.get('https://api.example.com/data')

# Raw response content (bytes)
content = response.content

# Decoded response (string)
text = response.text

# Encoding (default is 'utf-8')
response.encoding = 'ISO-8859-1'
text = response.text
```

### Status Codes

```python
response = requests.get('https://api.example.com/data')

# Check status code
if response.status_code == 200:
    print("Success!")
elif response.status_code == 404:
    print("Not Found.")

# Raise an exception for bad status codes (4XX or 5XX)
response.raise_for_status()
```

### Response Headers

```python
response = requests.get('https://api.example.com/data')

# Get all headers
headers = response.headers

# Get specific header
content_type = response.headers['Content-Type']
```

### JSON Responses

```python
response = requests.get('https://api.example.com/data.json')

# Parse JSON response
data = response.json()

# Check if response is JSON
if 'application/json' in response.headers['Content-Type']:
    data = response.json()
```

## Advanced Features

### Sessions

```python
# Create a session
session = requests.Session()

# Set common headers
session.headers.update({'Authorization': 'Bearer my-token'})

# Make requests with the session
response = session.get('https://api.example.com/data')
response = session.post('https://api.example.com/post', data={'key': 'value'})

# Session persists cookies
response = session.get('https://api.example.com/cookie')
```

### Proxies

```python
proxies = {
    'http': 'http://10.10.1.10:3128',
    'https': 'http://10.10.1.10:1080',
}

response = requests.get('https://api.example.com/data', proxies=proxies)

# SOCKS proxies (requires pip install requests[socks])
proxies = {
    'http': 'socks5://user:pass@host:port',
    'https': 'socks5://user:pass@host:port'
}
```

### SSL Verification

```python
# Disable SSL verification (not recommended)
response = requests.get('https://api.example.com/data', verify=False)

# Use custom CA bundle
response = requests.get('https://api.example.com/data', verify='/path/to/cert.pem')

# Client side certificates
response = requests.get('https://api.example.com/data', cert=('/path/client.cert', '/path/client.key'))
```

### Authentication

```python
# Basic auth
from requests.auth import HTTPBasicAuth
response = requests.get('https://api.example.com/auth', auth=HTTPBasicAuth('user', 'pass'))

# Digest auth
from requests.auth import HTTPDigestAuth
response = requests.get('https://api.example.com/auth', auth=HTTPDigestAuth('user', 'pass'))

# OAuth (requires additional libraries)
# Typically you would use the `requests-oauthlib` library
```

### Streaming

```python
# Stream large responses
response = requests.get('https://api.example.com/large-data', stream=True)

for chunk in response.iter_content(chunk_size=8192):
    if chunk:  # filter out keep-alive new chunks
        process_chunk(chunk)

# Stream line by line
response = requests.get('https://api.example.com/log', stream=True)

for line in response.iter_lines():
    if line:  # filter out keep-alive new lines
        print(line.decode('utf-8'))
```

### File Uploads

```python
# Single file
with open('report.xls', 'rb') as f:
    response = requests.post('https://api.example.com/upload', files={'file': f})

# Multiple files
files = [
    ('images', ('foo.png', open('foo.png', 'rb'), 'image/png')),
    ('images', ('bar.png', open('bar.png', 'rb'), 'image/png'))
]
response = requests.post('https://api.example.com/upload', files=files)

# Send file with additional data
data = {'description': 'Quarterly report'}
files = {'file': ('report.xls', open('report.xls', 'rb'), 'application/vnd.ms-excel')}
response = requests.post('https://api.example.com/upload', data=data, files=files)
```

## Error Handling

```python
from requests.exceptions import RequestException

try:
    response = requests.get('https://api.example.com/data', timeout=5)
    response.raise_for_status()
except requests.exceptions.HTTPError as errh:
    print(f"HTTP Error: {errh}")
except requests.exceptions.ConnectionError as errc:
    print(f"Error Connecting: {errc}")
except requests.exceptions.Timeout as errt:
    print(f"Timeout Error: {errt}")
except requests.exceptions.RequestException as err:
    print(f"Oops: Something Else: {err}")
```

## Performance

```python
# Reuse TCP connection with Session
session = requests.Session()

# Enable keep-alive (default in Session)
session.headers.update({'Connection': 'keep-alive'})

# Disable redirects if not needed
response = requests.get('https://api.example.com/data', allow_redirects=False)

# Use streaming for large responses
response = requests.get('https://api.example.com/large-data', stream=True)
```

## Common Recipes

### Download a File

```python
url = 'https://example.com/image.jpg'
response = requests.get(url, stream=True)

if response.status_code == 200:
    with open('image.jpg', 'wb') as f:
        for chunk in response.iter_content(1024):
            f.write(chunk)
```

### POST JSON with Headers

```python
url = 'https://api.example.com/data'
headers = {'Content-Type': 'application/json'}
data = {'key1': 'value1', 'key2': 'value2'}

response = requests.post(url, headers=headers, json=data)
```

### OAuth2 Bearer Token

```python
headers = {
    'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
    'Content-Type': 'application/json'
}

response = requests.get('https://api.example.com/protected', headers=headers)
```

### Follow Redirects

```python
response = requests.get('https://api.example.com/redirect', allow_redirects=True)

# Get final URL after redirects
final_url = response.url

# Get redirect history
for resp in response.history:
    print(resp.status_code, resp.url)
```

### Custom User-Agent

```python
headers = {
    'User-Agent': 'MyApp/1.0 (https://example.com/myapp)'
}

response = requests.get('https://api.example.com/data', headers=headers)
```

### Persistent Cookies

```python
session = requests.Session()

# First request sets cookie
response = session.get('https://api.example.com/setcookie')

# Subsequent requests include the cookie
response = session.get('https://api.example.com/needs-cookie')
```

### Async Requests (with requests-futures)

```python
from concurrent.futures import as_completed
from requests_futures.sessions import FuturesSession

session = FuturesSession(max_workers=5)

futures = [
    session.get('https://api.example.com/data/1'),
    session.get('https://api.example.com/data/2'),
    session.get('https://api.example.com/data/3')
]

for future in as_completed(futures):
    response = future.result()
    print(response.json())
```

### Rate Limiting with Timeout

```python
import time
from requests.exceptions import Timeout

def make_request(url):
    try:
        response = requests.get(url, timeout=5)
        return response
    except Timeout:
        print(f"Timeout occurred for {url}")
        return None

urls = ['https://api.example.com/data/1', 'https://api.example.com/data/2']

for url in urls:
    response = make_request(url)
    if response:
        print(response.json())
    time.sleep(1)  # Rate limit to 1 request per second
```

### Mocking Requests for Testing (with responses)

```python
import responses
import requests

@responses.activate
def test_my_api():
    # Mock a GET request
    responses.add(
        responses.GET,
        'https://api.example.com/data',
        json={'key': 'value'},
        status=200
    )
    
    # Make the request
    response = requests.get('https://api.example.com/data')
    
    # Verify the response
    assert response.status_code == 200
    assert response.json() == {'key': 'value'}
```

### Streaming API Response to File

```python
url = 'https://example.com/large-file.zip'
response = requests.get(url, stream=True)

with open('large-file.zip', 'wb') as f:
    for chunk in response.iter_content(chunk_size=8192):
        if chunk:  # filter out keep-alive new chunks
            f.write(chunk)
            f.flush()
```

### Debugging Requests

```python
import logging
import http.client

# Enable debugging
http.client.HTTPConnection.debuglevel = 1

# You must initialize logging, otherwise you'll not see debug output
logging.basicConfig()
logging.getLogger().setLevel(logging.DEBUG)
requests_log = logging.getLogger("requests.packages.urllib3")
requests_log.setLevel(logging.DEBUG)
requests_log.propagate = True

# Make a request
response = requests.get('https://api.example.com/data')
```

### Using a Custom Retry Strategy

```python
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

session = requests.Session()

retry_strategy = Retry(
    total=3,
    backoff_factor=1,
    status_forcelist=[429, 500, 502, 503, 504],
    allowed_methods=["HEAD", "GET", "OPTIONS"]
)

adapter = HTTPAdapter(max_retries=retry_strategy)
session.mount("https://", adapter)
session.mount("http://", adapter)

response = session.get("https://api.example.com/unreliable-endpoint")
```

### Measuring Request Time

```python
import time

start_time = time.time()
response = requests.get('https://api.example.com/data')
end_time = time.time()

print(f"Request took {end_time - start_time:.2f} seconds")
print(f"Response time: {response.elapsed.total_seconds():.2f} seconds")
```

### Chunked Encoding

```python
def generate_chunked_data():
    yield b'part1'
    yield b'part2'
    yield b'part3'

response = requests.post('https://api.example.com/chunked', data=generate_chunked_data())
```

### Using Hooks

```python
def print_url(r, *args, **kwargs):
    print(r.url)

hooks = {'response': print_url}
response = requests.get('https://api.example.com/data', hooks=hooks)
```

### Pre-Request Callback

```python
def add_header(request, *args, **kwargs):
    request.headers['X-Custom-Header'] = 'CustomValue'
    return request

response = requests.get('https://api.example.com/data', hooks={'request': add_header})
```

### Streaming Upload

```python
def generate_large_file():
    for i in range(10000):
        yield f"Line {i}\n".encode('utf-8')

response = requests.post('https://api.example.com/upload', data=generate_large_file())
```

### Custom DNS Resolution

```python
import socket
from urllib3.util import connection

def patched_create_connection(address, *args, **kwargs):
    """Wrap urllib3's create_connection to resolve the name elsewhere"""
    host, port = address
    hostname = "resolved.example.com"  # Your custom resolution
    return connection.create_connection((hostname, port), *args, **kwargs)

# Monkey patch
connection.create_connection = patched_create_connection

response = requests.get('https://original.example.com/data')
```

### Using HTTP/2 (requires httpx)

```python
# Note: requests doesn't support HTTP/2, but httpx does
import httpx

client = httpx.Client(http2=True)
response = client.get('https://http2.example.com')
print(response.http_version)  # "HTTP/2"
```

### Browser-like Session

```python
session = requests.Session()

# Common browser headers
session.headers.update({
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
    'Accept-Language': 'en-US,en;q=0.5',
    'Accept-Encoding': 'gzip, deflate, br',
    'Connection': 'keep-alive',
    'Upgrade-Insecure-Requests': '1',
    'Cache-Control': 'max-age=0'
})

response = session.get('https://example.com')
```

### Handling Content-Disposition for Downloads

```python
import re
from urllib.parse import unquote

def get_filename_from_cd(cd):
    """
    Get filename from content-disposition header
    """
    if not cd:
        return None
    fname = re.findall('filename=(.+)', cd)
    if len(fname) == 0:
        return None
    return unquote(fname[0].strip('"\''))

url = 'https://example.com/download'
response = requests.get(url, stream=True)

filename = get_filename_from_cd(response.headers.get('content-disposition'))
if not filename:
    filename = url.split('/')[-1]

with open(filename, 'wb') as f:
    for chunk in response.iter_content(chunk_size=8192):
        if chunk:
            f.write(chunk)
```

### Using a SOCKS Proxy

```python
# Requires: pip install requests[socks]
proxies = {
    'http': 'socks5://user:pass@host:port',
    'https': 'socks5://user:pass@host:port'
}

response = requests.get('https://api.example.com/data', proxies=proxies)
```

### Custom SSL Context

```python
import ssl

# Create a custom SSL context
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

# Use the context in your request
response = requests.get('https://api.example.com/data', verify=ctx)
```
