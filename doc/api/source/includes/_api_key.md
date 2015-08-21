# API Key

All Bookshark API applications should use an API key. 
Including a key in your request:

* Allows you to monitor your application's API usage.
* Enables per-key instead of per-IP-address quota limits.
* Ensures that we can contact you about your application if necessary.

The Bookshark API uses an API key to identify your application. API keys are managed through Bookshark's website. To create your key:

1. [Login](http://bookshark.eu/users/sign_in) or [signup](http://bookshark.eu/users/sign_up) in [bookshark](http://bookshark.eu) website.
2. Go to [API Keys page](http://bookshark.eu/api_keys).
3. Write your application's name and press the create button.
4. Your API Key is ready for use.

### HTTP Request

`GET http://bookshark.eu/api/v1/metadata_type?parameters&key=API_KEY`

<aside class="notice">
You must replace `API_KEY` with your application's API key.
</aside>

## Usage Limits
The Bookshark API has the following limits in place:

* 10 keys per user.
* 15000 requests per 24 hour period for each key.
* 2500 requests per 24 hour period without key.